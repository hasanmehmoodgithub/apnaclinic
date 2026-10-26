# Care Companion / JIMI SDK — Integration Prompt (copy into a new app)

Paste the block below into Cursor (or another agent) in the **target app**. Fill the `{{PLACEHOLDERS}}`. Keep product rules as written unless the product owner changes them.

---

## PROMPT START

You are integrating a **health Care Companion** (JIMI / ApnaClinic AI SDK) into this app.

### Product identity (fill in)

- Assistant display name: `{{ASSISTANT_NAME}}` (e.g. Noor)
- Brand / tenant: `{{TENANT}}` (e.g. apnaclinic)
- Base URL: `{{JIMI_BASE_URL}}`
- SDK key: `{{JIMI_SDK_KEY}}`
- App auth: guest allowed; when user is logged in, send clinic JWT as `X-User-Token: Bearer <app_token>`
- UI language: support EN + `{{SECONDARY_LOCALE}}` (e.g. Urdu)
- Theme: reuse this app’s design system; do not invent a new purple theme

### Config

Read from dart-defines / env (order: `JIMI_*` then app-specific aliases):

```
JIMI_BASE_URL
JIMI_SDK_KEY
JIMI_TENANT={{TENANT}}
```

Dedicated Dio client for this SDK only — **do not** mix with the app’s main HMAC/JWT clinic API client.

Headers on SDK calls:

| Header | When |
|---|---|
| `X-SDK-Key` | always |
| `Authorization: Bearer <sdk_access_token>` | after session/init + token refresh |
| `X-User-Token: Bearer <app_jwt>` | only if app user is signed in |
| `Accept: text/event-stream` | SSE endpoints |

---

## 1) Boot / Init (session)

On feature open → `connect()`:

```
1. Determine mode from app login:
   - signed_in → { mode, device_id, msisdn (923…), name, email }
   - guest     → { mode, device_id }
2. If no cached SDK session (or forceRefresh / guest↔signed_in mismatch):
   POST /api/v1/sdk/session/init   (header X-SDK-Key)
3. Persist: api_key, session_id, user_id, access_token, expires_at, auth_mode
4. Save full init JSON to app-support file (greeting + audio.base64 are large)
5. Ensure token: POST /api/v1/sdk/auth/token { api_key } (~30s before expiry)
```

**MSISDN:** digits only; `0300…` / `300…` → `92300…`.

**Init may return:**

```json
{
  "greeting": "Assalam o alaikum…",
  "audio": { "base64": "…", "media_type": "audio/wav", "format": "wav" }
}
```

- Show `greeting` on home hero.
- Auto-play greeting audio **once per feature entry** (not again on back-from-chat / reconnect).
- While greeting plays, show **home speaking panel**: centered wave animation + typewriter greeting text; tap to pause/play; **dismiss when audio completes**.

Clear SDK prefs on app logout. Keep init JSON file across logout (overwrite only on new successful init).

---

## 2) Home + App branding APIs

After session is ready (authorized):

```
GET /api/v1/sdk/app
  → branding.assistant_name, welcome_message, theme.header_subtitle,
    theme.input_placeholder, suggestions, voice.input.enabled, voice.output.enabled

GET /api/v1/sdk/home
  → assistant_name, welcome / welcome_message, prompt (composer hint),
    suggestions / concerns / chips, cards[], resume{ conversation_id, expires_at, card }
```

**Home UI (simple):**

- Hero: online badge + assistant name + welcome text (no decorative bot on the right unless product asks)
- Medical disclaimer under hero
- Common concern chips from suggestions
- Composer: “Type, or tap the mic to speak…”
- Optional: capability cards from `home.cards` (can hide behind TODO)
- Optional: Continue/resume card from `home.resume` (restore that `conversation_id`, send `resume.card.send`)

While connecting: hero “Getting ready…”, disclaimer, loading — **no composer**.
On error: “Unavailable” + Retry (`forceRefresh: true`) — **no composer**.

---

## 3) Conversation id rules (critical)

| Action | conversation_id |
|---|---|
| Open feature | detach in-memory id |
| Home text / home voice / concern chip | **mint new** id when turn starts |
| In-chat follow-ups (text, cards, voice) | keep bound id |
| New chat | mint new |
| Resume card | restore `resume.conversation_id` |
| Token refresh / re-init mid-chat | **must not** rotate bound id |

---

## 4) Text chat flow

`voice.output.enabled` from `/sdk/app` gates speak:

| Speak | Endpoint |
|---|---|
| false | `POST /api/v1/sdk/assistant/turn/stream` SSE |
| true  | Prefer stream with speak, or `POST /api/v1/sdk/assistant/turn` JSON `{ speak: true }` |

Typical text body fields: `message`, `session_id` / credentials via headers, `conversation_id`, `channel: "app"`, optional `speak`, `language`, `client_turn_id`.

**SSE events (consume in order):**

| type | UI |
|---|---|
| `stage` | thinking label |
| `token` / `delta` / `chunk` | stream assistant bubble text |
| `final` / `done` | finalize reply, chips/cards from blocks; store `turn_id` |
| `audio` | delayed clip — match by `turn_id`, attach to that bubble |
| `error` | if **after** final, ignore (don’t wipe reply) |
| `keepalive` | ignore |

**Product rules (current):**

- **No on-device / local TTS** for text or voice turns.
- **No autoplay** of reply audio; show **Play** only after server `audio.base64` is attached.
- If `final` has `audio_pending: true` and `audio: null`: show reply/chips first; when later `type: audio` arrives with same `turn_id`, attach clip → show Play.
- Never treat `done: true` on `type: audio` as a second final.
- Never overwrite a non-empty reply/chips/clip with a later empty final/failure.

Cards/chips taps = send another chat message (same conversation). Do not open native booking unless product asks.

---

## 5) Voice flow (simple)

1. Mic → start recorder (prefer WAV 16 kHz mono; else AAC/M4A). **Do not** run local STT during capture (steals mic).
2. Max ~30s auto-send. Ignore clips &lt; 1s or &lt; 8 KB.
3. `POST /api/v1/sdk/assistant/turn/audio/stream` multipart + SSE:

```
fields:
  api_key, session_id, conversation_id,
  channel=voice, language (en|ur|auto),
  speak=true|false (from voice.output.enabled),
  client_turn_id, audio=<file>
headers:
  Accept: text/event-stream
  X-SDK-Key
  Authorization (sdk)
  X-User-Token (if signed in)
  (let client set multipart Content-Type)
```

4. SSE same as text, plus:

```
status:transcribing → show “Transcribing…” on user bubble; then transcription.text
final → reply + turn_id + maybe audio_pending
audio → match turn_id → attach base64 → show Play (no autoplay)
```

5. Fallbacks: 403 retry ≤2×; no-speech → friendly reply; 502 → optional text fallback with STT transcript if available.

6. Home greeting: centered speaking panel (wave + typewriter) — dismiss on complete. Chat clips: compact speaking bar with pause/play. Stop playback if user starts recording or sends a new message.

---

## 6) API checklist (only these for core integrate)

```
GET  /api/v1/sdk/ping
POST /api/v1/sdk/session/init
POST /api/v1/sdk/auth/token
GET  /api/v1/sdk/app
GET  /api/v1/sdk/home
POST /api/v1/sdk/assistant/turn/stream          # text SSE
POST /api/v1/sdk/assistant/turn                # text JSON + speak (optional)
POST /api/v1/sdk/assistant/turn/audio/stream   # voice multipart SSE
GET  /api/v1/sdk/voice/speak/status            # optional
GET  /api/v1/sdk/voice/transcribe/status       # optional
```

---

## 7) Architecture to implement in this app

```
presentation/  Cubit + Home + Chat + Composer + HomeSpeakingPanel + SpeakingBar + MessageBubble
domain/        UseCases (ensureSession, sendMessage, sendAudio) + entities + Params classes
data/          SdkClient (Dio), RemoteDataSource (SSE parse), Repository, AudioRecorder, AudioPlayer
DI             SdkClient + repo singleton; Cubit factory
```

Suggested connect pipeline:

```
open feature
  → ensureSession (init + token)
  → fetchApp + fetchHome
  → render home + play greeting once
user text/voice from home
  → mint conversation_id → open chat → stream turn
in-chat turns
  → same conversation_id
back from chat
  → clear thread UI, detach id, home (no greeting replay)
```

SSE finalize rule (hard):

```
only type == "final" || type == "done"  → complete turn
type == "audio"                        → attach by turn_id only
```

---

## 8) Acceptance tests

- [ ] Guest open → init → home shows greeting; audio plays **once**; speaking bar visible
- [ ] Leave feature and re-enter → greeting audio can play again (new cubit/session entry)
- [ ] Back from chat → home **does not** replay greeting
- [ ] Text turn streams tokens → final shows reply; Play appears only if audio attached
- [ ] Voice: record → transcribing → reply → delayed audio by `turn_id` → Play (no autoplay, no local TTS)
- [ ] Signed-in: `X-User-Token` present; guest: absent
- [ ] Home start always new conversation; in-chat keeps same id

## PROMPT END

---

## Quick reference (this ApnaClinic repo)

| Topic | File |
|---|---|
| Feature index | `FEATURE.md` |
| Session detail | `SESSION_INIT.md` |
| HTML walkthrough | `APNA_CLINIC_AI_GUIDE.html` |
| SDK Dio client | `data/data_sources/apna_clinic_ai_sdk_client.dart` |
| Home/app merge + SSE | `data/data_sources/apna_clinic_ai_remote_data_source.dart` |
| State / flows | `presentation/cubit/apna_clinic_ai_cubit.dart` |
| Keys example | `apna_clinic_ai.keys.json.example` |
)
