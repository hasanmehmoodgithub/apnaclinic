# Refresh Token Logic

This document explains how automatic token refresh works in the networking layer.

## Overview

- Access tokens are attached to every request.
- If an API returns `401`, the app tries to refresh the token.
- Only one refresh call is made even if many requests fail with `401` at the same time.
- After successful refresh, failed requests are retried automatically.
- If refresh fails, auth session is cleared.

## Files Involved

- `lib/core/network/auth_interceptor.dart`
- `lib/core/network/api_service.dart`
- `lib/core/network/api_exceptions.dart`
- `lib/core/network/app_urls.dart`
- `lib/core/preference/app_pref.dart`
- `lib/core/preference/app_pref_impl.dart`

## Refresh Endpoint

- URL: `POST /api/v1.0/user-auth/auth/token/refresh`
- Full host example:
  `http://apnaclinic-auth.apps.jpocp.jazz.com.pk/api/v1.0/user-auth/auth/token/refresh`
- Request body:

```json
{
  "refreshToken": "<refresh_token>"
}
```

## Request Flow

1. `AuthInterceptor.onRequest` reads latest token from `AppPref`.
2. Adds `Authorization: Bearer <accessToken>` if available.
3. Request is sent.

## 401 Handling Flow

When `onError` receives `401`:

1. Skip refresh for:
   - requests already retried once
   - refresh endpoint request itself
   - **guest requests** when there is no refresh token (fail fast; avoids logout-notification loops)
2. Call `_refreshAccessTokenSingleFlight()`.
3. On success:
   - retry original request with new access token
4. On failure:
   - propagate original error
   - session is cleared and `AuthSessionRefresh.notifyLoggedOut()` runs so tabs/menu update immediately

## Single-Flight Refresh (No Multiple Refresh Calls)

`AuthInterceptor` uses `Completer<bool>? _refreshCompleter`.

- If refresh is already in progress:
  - other `401` requests wait on the same future
- If no refresh is in progress:
  - first `401` starts refresh
  - all others share the result

This prevents multiple simultaneous refresh calls.

## Token Save Rules After Refresh

The client requires `success: true` in the JSON body; otherwise the session is cleared.

Typical success body (access token only — **no new refresh token**):

```json
{
  "success": true,
  "message": "Access token refreshed successfully.",
  "data": {
    "tokenType": "Bearer",
    "accessToken": {
      "token": "<jwt>",
      "expiresIn": 900000
    }
  }
}
```

Persisted values:

- `data.accessToken.token` → access token (required)
- `data.refreshToken.token` → refresh token **only if** the backend returns a new refresh object; otherwise the **existing** stored refresh token is kept
- `data.accessToken.expiresIn` → access TTL in milliseconds when present (parsed as `int`, `num`, or numeric `string`)
- `data.refreshToken.expiresIn` → refresh TTL when a new refresh block is returned

## Retry Protection

- Retried requests are marked with `extra['auth_retry'] = true`.
- Same request is retried only once to avoid loops.

## Session Clear Behavior

If refresh token is missing or refresh call fails:

- clear access token
- clear refresh token
- clear access expiry
- clear refresh expiry
- set login status to false
- `notifyLoggedOut()` runs **once** when a session was active (`_clearSession` is idempotent)

Guest `401` responses (no refresh token) do not clear session or notify the shell.

## Notes

- `ApiService` registers `AuthInterceptor` before other interceptors.
- A separate internal `Dio` instance is used for refresh call to avoid interceptor recursion.
- UI redirection to login should be handled at app/session layer when login status becomes false.
