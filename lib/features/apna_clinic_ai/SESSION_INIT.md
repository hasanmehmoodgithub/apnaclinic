# Apna Clinic AI: Session Initialization (Signed-In vs Guest)

How Care Companion initializes the SDK session, how **signed_in** vs **guest** differ, and how tokens are cached in `AppPref`.

## How to call

**Preferred (UI / feature):**

```dart
await cubit.connect();                 // reopen feature → token refresh only
await cubit.connect(forceRefresh: true); // cold start / login / Retry
```

Call chain:

`ApnaClinicAiCubit.connect` → `EnsureApnaClinicAiSessionUseCase` → `ApnaClinicAiRepository.ensureSession` → `ApnaClinicAiSdkInitializer.initialize`

**When `POST /sdk/session/init` runs**

| Trigger | Init? |
|---|---|
| Cold app start (first AI open this process) | yes |
| Open AI again while app stays alive | no (reuse prefs + token refresh) |
| Logout (`clearApnaClinicAiSession`) then open AI | yes (no cached session) |
| Login / guest↔signed-in mismatch | yes |
| Retry on home error | yes (`forceRefresh: true`) |
| Mid-chat turns | no |

**Direct (DI / tests / another host app):**

```dart
final initializer = sl<ApnaClinicAiSdkInitializer>();
if (!initializer.isConfigured) { /* AI_BASE_URL / AI_SDK_KEY missing */ }
final session = await initializer.initialize(forceRefresh: false);
```

Do **not** call `ApnaClinicAiSdkClient.initSession` from UI — use the initializer.

### Steps inside `initialize`

| Step | Method | What |
|---|---|---|
| 1 | `ensureConfigured()` | `AI_*` / `APNA_CLINIC_AI_*` dart-defines |
| 2 | `resolveAuth()` | guest vs signed-in (`ApnaClinicAiSdkAuthResolver`) |
| 3 | `ensureSdkSession()` | `POST /sdk/session/init` or token refresh |
| 4 | `loadGreeting()` | `{appSupport}/apna_clinic_ai_session_init.json` |
| 5 | `loadBranding()` | `GET /sdk/app` |
| 6 | assemble | `ApnaClinicAiSessionModel` |

## High-level flow

1. Cubit `connect()` → use case → repository → `ApnaClinicAiSdkInitializer`
2. Auth resolver reads `AuthGuard.isLoggedIn(appPref)`:
   - `true` → `mode: signed_in` + normalized `msisdn` (`923…`), `name`, `email`
   - `false` → `mode: guest` + `device_id` only
3. `POST /api/v1/sdk/session/init` with `X-SDK-Key` **only** when cold start / no cached session / mode mismatch / `forceRefresh` — otherwise refresh token only
4. Persist in `AppPref`: api key, session id, user id, access token, expires-at, auth mode
5. Persist full init JSON (including `greeting` + `audio.base64`) to app-support file `apna_clinic_ai_session_init.json` — too large for SharedPreferences. **Not** cleared with `clearSession` / logout — overwritten only on a successful new init
6. Init may return `greeting` + `audio` (`base64`, `media_type`). Home always loads greeting/audio from that saved file when present; `audio.base64` auto-plays via `playHomeGreeting` **once** when Care Companion is opened from the app (not on back-from-chat or reconnect)
7. Turns use `Authorization: Bearer <access_token>`; refresh via `POST /api/v1/sdk/auth/token` `{ api_key }`
8. When the user is logged into Apna Clinic, every SDK request also sends `X-User-Token: Bearer <appPref.getToken()>` (clinic JWT). Guests omit this header.

## Conversation id (critical)

On open, the in-memory id is detached so a leftover singleton id cannot be reused. **`POST /session/init`** runs on cold app start, after logout, on login/mode change, or Retry — **not** every Care Companion open (then token refresh only). In-feature login still uses `resumeAfterSignIn` (`forceRefresh: true`). Mid-chat turns only refresh the token — they do not re-init. **Every home start** — common concerns, home text, and home voice — always mints a new `conversation_id`, even if this window already had a thread. Continue / resume last complaint uses `AppPref.apnaClinicAiHistoryConversationId`. History id is written only after a turn is sent. Follow-up turns in the open chat stay on the bound id (typed, cards, in-chat voice, “yes”, sign-in resume). **New chat** mints a new id. Session token refresh / guest↔signed-in re-init must **not** rotate a bound conversation mid-chat, or pending confirmations (`awaiting_confirmation`), triage, and sign-in resume break.

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

Written by `ApnaClinicAiSdkClient.saveInitResponse` after a successful init; always read by `loadGreeting` → `readInitResponse`.

## Code map

| Piece | Path |
|---|---|
| Orchestrator | `data/sdk_init/apna_clinic_ai_sdk_initializer.dart` |
| Auth context | `data/sdk_init/apna_clinic_ai_sdk_auth_context.dart` |
| Auth resolver | `data/sdk_init/apna_clinic_ai_sdk_auth_resolver.dart` |
| Greeting parse | `data/sdk_init/apna_clinic_ai_sdk_greeting.dart` |
| Branding parse | `data/sdk_init/apna_clinic_ai_sdk_branding.dart` |
| Repository | `ApnaClinicAiRepositoryImpl.ensureSession` → initializer |
| Client | `ApnaClinicAiSdkClient.initSession` / `saveInitResponse` / `readInitResponse` / `ensureToken` |
| DI | `initApnaClinicAiInjector()` → `ApnaClinicAiSdkAuthResolver` + `ApnaClinicAiSdkInitializer` |
