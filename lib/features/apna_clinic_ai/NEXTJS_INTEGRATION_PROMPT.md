# Apna Clinic AI — Next.js Web App Prompt (copy into a new repo)

Paste the block below into Cursor (or another agent) in an **empty or new Next.js** project. Fill the `{{PLACEHOLDERS}}`. Keep product rules as written unless the product owner changes them.

---

## PROMPT START

Build a **Next.js (App Router) web app** that recreates the **Apna Clinic AI / Care Companion** module currently shipped in the Flutter ApnaClinic app.

### Product identity

- Assistant display name: **Apna Clinic Ai Noor** (rewrite API aliases like “Apna Clinic”, “Noor”, “ApnaClinic Assistant” to this name)
- Brand / tenant: `{{TENANT}}` (default `apnaclinic`)
- Base URL: `{{AI_BASE_URL}}` (e.g. `https://jazzred-msa-stg.jazz.com.pk/ai-services/jimi`)
- SDK key: `{{AI_SDK_KEY}}` — **server-only**, never expose to the browser
- Guest allowed; when the user is signed into the host app, send clinic JWT as `X-User-Token: Bearer <app_token>`
- Locales: English + Urdu (`ur`) where practical
- Visual: calm clinical teal (CTA ≈ `#0FAA9A`, deep ≈ `#00897B`), mint page background, white panels, hairline borders. **Do not** invent a purple / cream-serif / newspaper aesthetic.

### Stack

- Next.js 15+ App Router + TypeScript
- Tailwind CSS
- Server Components where safe; client components for chat / mic / SSE
- State: Zustand (or React Query + local store) for session + chat thread
- Env: `.env.local` with `AI_BASE_URL`, `AI_SDK_KEY`, `AI_TENANT` (aliases `APNA_CLINIC_AI_*` optional)
- **BFF pattern:** browser talks only to Next.js Route Handlers under `/api/ai/*`. Those handlers call the real AI SDK with `X-SDK-Key`. Never put `AI_SDK_KEY` in `NEXT_PUBLIC_*`.

---

## 1) Screens / routes

| Route | Purpose |
|---|---|
| `/ai` | Home (hero, medical disclaimer, concern chips, composer) |
| `/ai/chat` | Chat thread + composer + speaking bar |

Flow:

```
open /ai
  → ensureSession (init + token) via BFF
  → GET /sdk/app branding
  → render home + play greeting audio ONCE per browser entry
user sends text / voice / taps concern from home
  → mint new conversation_id → navigate /ai/chat → stream turn
in-chat follow-ups
  → same conversation_id
New chat
  → mint new id, clear thread
Back to home
  → clear thread UI, detach id; do NOT replay greeting
```

---

## 2) BFF API routes (implement these)

Proxy to `{{AI_BASE_URL}}`. Forward / attach headers correctly.

| Next route | Upstream |
|---|---|
| `POST /api/ai/session/init` | `POST /api/v1/sdk/session/init` |
| `POST /api/ai/auth/token` | `POST /api/v1/sdk/auth/token` |
| `GET  /api/ai/app` | `GET  /api/v1/sdk/app` |
| `POST /api/ai/turn/stream` | `POST /api/v1/sdk/assistant/turn/stream` (SSE passthrough) |
| `POST /api/ai/turn` | `POST /api/v1/sdk/assistant/turn` (optional JSON + speak) |
| `POST /api/ai/turn/audio/stream` | `POST /api/v1/sdk/assistant/turn/audio/stream` (multipart + SSE) |

Upstream headers:

| Header | When |
|---|---|
| `X-SDK-Key` | always (server) |
| `Authorization: Bearer <sdk_access_token>` | after session/init + refresh |
| `X-User-Token: Bearer <app_jwt>` | only if signed in (from cookie/session of host app) |
| `Accept: text/event-stream` | SSE endpoints |

Store SDK session (`api_key`, `session_id`, `user_id`, `access_token`, `expires_at`, `auth_mode`) in an **httpOnly cookie** or encrypted server session — not `localStorage` for tokens. Greeting JSON (large `audio.base64`) may live in server cache / IndexedDB / sessionStorage for the greeting clip only.

---

## 3) Session init

On `/ai` mount → `connect()`:

```
1. mode:
   - signed_in → { mode, device_id, msisdn (923…), name, email }
   - guest     → { mode, device_id }
2. POST /api/ai/session/init ONLY when:
   - cold app/tab start (first AI open this session), OR
   - no cached SDK session (after logout), OR
   - forceRefresh / guest↔signed_in mismatch (login), OR
   - user taps Retry
   Re-opening /ai in the same session must NOT re-init — token refresh only.
3. Persist SDK credentials server-side
4. Cache full init JSON (greeting + audio.base64)
5. Refresh token via POST /api/ai/auth/token { api_key } ~30s before expiry
6. GET /api/ai/app for branding
```

**MSISDN:** digits only; `0300…` / `300…` → `92300…`.

**Init may return:**

```json
{
  "greeting": "Assalam o alaikum…",
  "audio": { "base64": "…", "media_type": "audio/wav", "format": "wav" }
}
```

- Show greeting on home.
- Auto-play greeting audio **once per app entry**.
- While playing: home speaking panel (wave + typewriter text); click to pause/play; hide when audio ends.

---

## 4) Home UI

- Teal gradient hero: logo, **Apna Clinic Ai Noor**, status badge (Getting ready… / Online / Unavailable), close
- Medical disclaimer card under hero (caution cream box)
- Common concern chips from `suggestions`
- Composer: “Type, or tap the mic to speak…” + mic + send
- Connecting: hero + disclaimer + loading — **no composer**
- Error: Unavailable + Retry (`forceRefresh: true`) — **no composer**

---

## 5) Conversation id rules (critical)

| Action | conversation_id |
|---|---|
| Open `/ai` | detach in-memory id |
| Home text / home voice / concern chip | **mint new** when turn starts |
| In-chat follow-ups | keep bound id |
| New chat | mint new |
| Token refresh / re-init mid-chat | **must not** rotate bound id |

---

## 6) Text chat (SSE)

`voice.output.enabled` from `/sdk/app` gates `speak`.

Prefer `POST /api/ai/turn/stream` and pipe SSE to the client (`ReadableStream` / `EventSource`-style parser).

Body fields (typical): `message`, `conversation_id`, `channel: "app"`, optional `speak`, `language`, `client_turn_id`.

| SSE type | UI |
|---|---|
| `stage` | “Just a moment…” / stage label |
| `token` / `delta` / `chunk` | typewriter / slow character reveal into assistant bubble |
| `final` / `done` | finalize reply, parse chips/cards from `blocks`; keep `turn_id` |
| `audio` | delayed clip — match `turn_id`, attach to that bubble |
| `error` | if **after** final, ignore (don’t wipe reply) |
| `keepalive` | ignore |

**Product rules:**

- No browser TTS for replies.
- No autoplay of reply audio; show **Play** only after server `audio.base64` is attached.
- If `final` has `audio_pending: true` and `audio: null`: show reply/chips first; later `type: audio` with same `turn_id` → attach → Play.
- Never treat `done: true` on `type: audio` as a second final.
- Never overwrite a non-empty reply with a later empty final/failure.
- Card / chip / slot taps = send another chat message (same conversation).

Hard finalize rule:

```
only type == "final" || type == "done"  → complete turn
type == "audio"                        → attach by turn_id only
```

---

## 7) Voice

1. Mic → `MediaRecorder` (prefer WAV/webm; keep capture simple). Do **not** run browser STT during capture if it steals the mic.
2. Max ~30s auto-send. Ignore clips &lt; 1s or tiny blobs.
3. `POST /api/ai/turn/audio/stream` multipart + SSE passthrough:

```
fields: api_key (server), session_id, conversation_id,
        channel=voice, language (en|ur|auto),
        speak=true|false, client_turn_id, audio=<file>
```

4. SSE same as text + `transcription` → show “Transcribing…” then transcript on user bubble.
5. Delayed `audio` by `turn_id` → Play (no autoplay).
6. Stop playback if user starts recording or sends a new message.
7. Home greeting: speaking panel. Chat: compact speaking bar.

---

## 8) Suggested project structure

```
app/
  ai/page.tsx                 # home
  ai/chat/page.tsx            # chat
  api/ai/session/init/route.ts
  api/ai/auth/token/route.ts
  api/ai/app/route.ts
  api/ai/turn/stream/route.ts
  api/ai/turn/audio/stream/route.ts
lib/ai/
  sdk-client.ts               # server-only fetch to upstream SDK
  session.ts                  # cookie/session helpers
  msisdn.ts
  sse.ts                      # parse SSE lines
  brand.ts                    # rewrite assistant name → Apna Clinic Ai Noor
components/ai/
  HomeHero.tsx
  MedicalDisclaimer.tsx
  ConcernChips.tsx
  Composer.tsx
  ListeningBar.tsx
  ChatHeader.tsx
  MessageBubble.tsx
  SpeakingBar.tsx
  HomeSpeakingPanel.tsx
  ReplyRail.tsx               # doctors / slots / payments chips
store/ai-store.ts             # session + messages + streaming flags
```

---

## 9) Acceptance checklist

- [ ] Guest open → init → home greeting; audio plays **once**; speaking panel shows
- [ ] Full page reload of `/ai` → greeting can play again
- [ ] Back from chat → home **does not** replay greeting
- [ ] Text streams tokens → final reply; Play only if audio attached
- [ ] Voice: record → transcribing → reply → delayed audio by `turn_id` → Play
- [ ] Signed-in requests include `X-User-Token`; guest omits it
- [ ] Home start always new `conversation_id`; in-chat keeps same id
- [ ] `AI_SDK_KEY` never appears in client bundles / Network as a browser request header to upstream

## PROMPT END

---

## Notes from the Flutter source of truth

| Topic | Flutter path |
|---|---|
| Feature index | `lib/features/apna_clinic_ai/FEATURE.md` |
| Session detail | `lib/features/apna_clinic_ai/SESSION_INIT.md` |
| Flutter integrate prompt | `lib/features/apna_clinic_ai/INTEGRATION_PROMPT.md` |
| SDK init steps | `lib/features/apna_clinic_ai/data/sdk_init/` |
| SSE / turns | `lib/features/apna_clinic_ai/data/data_sources/` |
