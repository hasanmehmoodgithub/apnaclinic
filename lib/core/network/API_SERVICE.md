# ApiService

Thin **Dio** facade used across features for JSON REST calls. Lives in `lib/core/network/api_service.dart`; HTTP error types live in `api_exceptions.dart` and are **re-exported** from `api_service.dart` so `import '.../api_service.dart';` still exposes `ApiException`, etc.

## Responsibilities

| Area | Behavior |
|------|----------|
| **Base URL** | `ApiConfig.baseUrl` → `FlavorConfig.apiBaseUrl` (override via constructor `baseUrl`). |
| **Headers** | Default `Content-Type` / `Accept`: `application/json`. For `FormData` posts, overrides to `multipart/form-data; boundary=...` (same value on header + `contentType`) so Dio does not conflict with BaseOptions JSON content-type and servers can parse multipart. Device/app metadata is added by `HeaderInterceptor` (see `DEVICE_HEADERS_CONTRACT.md`). CMS/aggregator calls include `x-api-key` (`AppUrls.mobileApiKey`) for guest access; `x-tenant-id` when logged in. Bearer token is synced from `AppPref` before each request. |
| **Interceptors** | `HeaderInterceptor`, `AuthInterceptor` (401 → refresh + retry, see `REFRESH_TOKEN_LOGIC.md`), optional `ApiLoggerInterceptor`, optional `ChuckerDioInterceptor`. |
| **Timeouts** | Connect / send / receive default 60s; per-call override via `timeout` on `get`/`post`/… |
| **Response** | 2xx returns `Map<String, dynamic>` (empty map if body null). Non-2xx throws `ApiException` with parsed message via `ApiErrorMessageUtils`. |
| **Dio errors** | Mapped to typed `ApiException` subclasses (`ApiUnauthorizedException`, `ApiNetworkException`, …). |
| **Jazz / HTTP / proxy** | `configureDioForAppNetwork` sets Dio `findProxy` from `AppHttpOverrides.activeProxy` (auto-detect at startup) and trusts certs when a proxy is active or debug features are on. Global `HttpOverrides` covers non-Dio `HttpClient` traffic. |

## Public API

- `get` / `post` / `put` / `patch` / `delete` — `endpoint` is usually a **full URL** from `AppUrls` (not only a path), matching current app usage.
- `refreshToken()` — re-read access token from prefs into Dio default headers (call after login or token update).
- `removeToken()` — clear `Authorization` header (e.g. after logout).

## What it does *not* do

- No automatic JSON encoding beyond Dio defaults; send `Map` / `List` as `data` for JSON body.
- No request deduplication or offline queue (handle in features if needed).

## Related files

- `auth_interceptor.dart` — token refresh single-flight.
- `device_headers_provider.dart` / `header_interceptor.dart` — app/device metadata headers.
- `DEVICE_HEADERS_CONTRACT.md` — backend-facing contract for app/device headers.
- `api_error_message_utils.dart` — nested `message` / validation arrays from APIs.
- `api_exceptions.dart` — exception hierarchy for `ErrorHandler` and callers.
- `../cities/` — `CitiesRepository` caches `AppUrls.cities` in-session; shared UI is `showSelectCityDialog` (Lab / Surgery / Pharmacy).
- `API_INTEGRATION_STATUS.html` — visual matrix of integrated vs remaining APIs (open in browser).

## Constructor flags

- `enableLogging` — defaults to `FlavorConfig.enableLogging` when null.
- `timeout` — optional global timeout for the `BaseOptions` of this Dio instance.
