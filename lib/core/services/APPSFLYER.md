# AppsFlyer

## Purpose

Mobile attribution and in-app analytics (install source, sessions, custom events).

## Status

**Scaffolded with placeholders.** SDK does **not** start until business fills credentials.

| Value | Where | Current |
|-------|--------|---------|
| Dev Key | `AppFlavor.appsFlyerDevKey` / `FlavorConfig.appsFlyerDevKey` | `''` (empty → skip init) |
| iOS App ID | `AppFlavor.appsFlyerIosAppId` / `FlavorConfig.appsFlyerIosAppId` | `''` |

## Files

- `lib/core/services/appsflyer_service.dart` — init / `setCustomerUserId` / `logEvent`
- `lib/core/flavor/app_flavor.dart` — per-flavor key placeholders
- DI: `AppsFlyerService` in `_initCore`
- `main.dart` — `unawaited(_initializeAppsFlyer())` after DI (non-blocking)
- Login: `AuthCubit._saveUserSession` → `setCustomerUserId`
- Logout: `LocalLogoutService.clearAll` → `clearCustomerUserId`

## Enable when credentials arrive

1. AppsFlyer dashboard → App Settings → **Dev Key**
2. App Store Connect → Apple ID (numeric) for iOS
3. Set the same (or flavor-specific) values on `AppFlavor.development` / `staging` / `production`
4. Full restart the app (not just hot reload)

iOS: Dev Key alone is not enough — fill `appsFlyerIosAppId` before expecting iOS attribution.

## Optional next steps

- Log product events (`af_login` already covered via customer id; add consultation / lab / surgery via `logEvent`)
- OneLink / deferred deep links into `go_router`
- ATT prompt UX on iOS 14.5+ (SDK waits up to 15s when configured)
