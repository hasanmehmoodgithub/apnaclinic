# Apna Clinic AI: Session Initialization (Signed-In vs Guest)

How Care Companion initializes the SDK session, how **signed_in** vs **guest** differ, and how tokens are cached in `AppPref`.

## High-level flow

1. Cubit `connect()` → `EnsureApnaClinicAiSessionUseCase`
2. Repository reads `AuthGuard.isLoggedIn(appPref)`:
   - `true` → `mode: signed_in` + normalized `msisdn` (`923…`), `name`, `email`
   - `false` → `mode: guest` + `device_id` only
3. `POST /api/v1/sdk/session/init` with `X-SDK-Key` (when no cached session)
4. Persist in `AppPref`: api key, session id, user id, access token, expires-at, auth mode
5. Persist full init JSON (including `greeting` + `audio.base64`) to app-support file `apna_clinic_ai_session_init.json` — too large for SharedPreferences. **Not** cleared with `clearSession` / logout — overwritten only on a successful new init
6. Init may return `greeting` + `audio` (`base64`, `media_type`). Home always loads greeting/audio from that saved file when present; `audio.base64` auto-plays via `playHomeGreeting` **once** when Care Companion is opened from the app (not on back-from-chat or reconnect)
7. Turns use `Authorization: Bearer <access_token>`; refresh via `POST /api/v1/sdk/auth/token` `{ api_key }`
8. When the user is logged into Apna Clinic, every SDK request also sends `X-User-Token: Bearer <appPref.getToken()>` (clinic JWT). Guests omit this header.

## Conversation id (critical)

On open, the in-memory id is detached so a leftover singleton id cannot be reused. **Every home start** — common concerns, What I can do, home text, and home voice — always mints a new `conversation_id`, even if this window already had a thread. **`GET /sdk/home` `resume`** (when present and before `expires_at`) is the Continue card (UI may be hidden): restore `resume.conversation_id` and send `resume.card.send` (`__resume__`). That card is omitted from What I can do. If `resume` is absent or expired, Continue falls back to `AppPref.apnaClinicAiHistoryConversationId`. History id is written only after a turn is sent. Follow-up turns in the open chat stay on the bound id (typed, cards, in-chat voice, “yes”, sign-in resume). **New chat** mints a new id. Session token refresh / guest↔signed-in re-init must **not** rotate a bound conversation mid-chat, or pending confirmations (`awaiting_confirmation`), triage, and sign-in resume break.

`sign_in_required`: open app login (do not send “Sign in to continue” as a chat message). After login, send `auth.resume.message` in the **same** conversation with `X-User-Token`.

## Request payloads

### Guest

```json
{
  "mode": "guest",
  "device_id": "ac-…"
}
```

### Signed-in

```json
{
  "mode": "signed_in",
  "device_id": "ac-…",
  "msisdn": "923001234567",
  "name": "Ayesha Khan",
  "email": "user@example.com"
}
```

MSISDN normalization (`normalizeApnaClinicAiMsisdn`): digits only; `0300…` / `300…` → `92300…`.

## AppPref keys

| Pref | Purpose |
|---|---|
| `apnaClinicAiApiKey` | SDK `api_key` |
| `apnaClinicAiSessionId` | `session_id` |
| `apnaClinicAiUserId` | `user_id` |
| `apnaClinicAiAccessToken` | JWT |
| `apnaClinicAiTokenExpiresAt` | epoch ms |
| `apnaClinicAiAuthMode` | `guest` \| `signed_in` |

Cleared on logout via `LocalLogoutService` → `clearApnaClinicAiSession()`. Guest→signed-in (or reverse) re-inits the session (`forceRefresh` / mode mismatch). Init JSON file is **kept** across session clears.

## Init response file cache

| File | Purpose |
|---|---|
| `{appSupport}/apna_clinic_ai_session_init.json` | Full last `POST /sdk/session/init` body — home greeting text + audio (audio plays once per app entry) |

Written by `ApnaClinicAiSdkClient.saveInitResponse` after a successful init; always read by `readInitResponse` in `ensureSession` for greeting/audio.

## Code map

- Repository: `ApnaClinicAiRepositoryImpl.ensureSession`
- Remote: `ApnaClinicAiRemoteDataSourceImpl.ensureSession`
- Client: `ApnaClinicAiSdkClient.initSession` / `saveInitResponse` / `readInitResponse` / `ensureToken` / `hydrateFromPrefs`
