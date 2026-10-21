# Apna Clinic AI: Session Initialization (Signed-In vs Guest)

How Care Companion initializes the SDK session, how **signed_in** vs **guest** differ, and how tokens are cached in `AppPref`.

## High-level flow

1. Cubit `connect()` → `EnsureApnaClinicAiSessionUseCase`
2. Repository reads `AuthGuard.isLoggedIn(appPref)`:
   - `true` → `mode: signed_in` + normalized `msisdn` (`923…`), `name`, `email`
   - `false` → `mode: guest` + `device_id` only
3. `POST /api/v1/sdk/session/init` with `X-SDK-Key`
4. Persist in `AppPref`: api key, session id, user id, access token, expires-at, auth mode
5. Turns use `Authorization: Bearer <access_token>`; refresh via `POST /api/v1/sdk/auth/token` `{ api_key }`
6. When the user is logged into Apna Clinic, every SDK request also sends `X-User-Token: Bearer <appPref.getToken()>` (clinic JWT). Guests omit this header.

## Conversation id (critical)

On a **new Care Companion window**, stash the last `conversation_id` but do not bind it yet. **Continue / Resume** restores that id; any other first action (concern chip, tile, composer, New chat) creates a **new** id. Reuse the bound id for every later turn in that window (typed, chips, cards, voice, “yes”, sign-in resume). Persist in `AppPref` (`apnaClinicAiConversationId`). Session token refresh / guest↔signed-in re-init must **not** rotate it mid-chat, or pending confirmations (`awaiting_confirmation`), triage, and sign-in resume break.

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

Cleared on logout via `LocalLogoutService` → `clearApnaClinicAiSession()`. Guest→signed-in (or reverse) re-inits the session (`forceRefresh` / mode mismatch).

## Code map

- Repository: `ApnaClinicAiRepositoryImpl.ensureSession`
- Remote: `ApnaClinicAiRemoteDataSourceImpl.ensureSession`
- Client: `ApnaClinicAiSdkClient.initSession` / `ensureToken` / `hydrateFromPrefs`
