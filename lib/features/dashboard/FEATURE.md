# Dashboard feature

## Purpose

Home services grid, promotional banner, search entry, and shell navigation. Keeps **user profile** in sync with the auth user API when the user is logged in.

## Profile sync on dashboard

- **`DashboardCubit`** (created when `HomeScreen` loads) calls **`GetProfileSetupContentUseCase`** in **`syncUserProfileFromApi()`** after services load. Promo banner is read from **`PromotionalBannerSession`** (not fetched per cubit).
- Skips when **`AppPref.getLoginStatus()`** is false.
- On success, **`ProfileSetupRepositoryImpl`** already persists **`UserLocalModel`** (name, email, address, gender, DOB, `imageUrl` from API `image`, etc.).
- **`DashboardServicesState.profileSyncNonce`** increments so **`BlocConsumer`** on home rebuilds and **`SearchHeader`** / greeting reads updated prefs.

## Data & APIs (dashboard-specific)

- Services: `AppUrls.ourServices` (see `DashboardRemoteDataSourceImpl`).
- Promo: `AppUrls.promotionalBanner` → CMS `GET /api/v1/mobile/banners`. Fetched once at **app open** (`main.dart`) and again only after **login** (`AuthSessionRefresh.consumeReloadPromotionalBanner`). Not called on logout tab remount. `PromotionalBannerSession` caches result and tracks whether the dialog was already shown this session.

Profile uses **`profile_setup`** remote (`GET …/users/{userId}`) — no duplicate URL in dashboard.

## DI

- `dashboard_injection.dart` — registers `DashboardCubit` with `GetProfileSetupContentUseCase` + `AppPref` (profile setup injector must run before dashboard).

## UI

- `HomeScreen` — `DashboardCubit` + `NotificationCubit`.
- `MainNavigationShell` — tab shell around `HomeScreen`; tabs switch **only via bottom nav tap** (no horizontal swipe between tabs). Listens to `AuthSessionRefresh` (login/logout) to remount all tabs and reload cubits.

## Session refresh

- `AuthSessionRefresh.notifyLoggedIn()` — after OTP when profile is already complete, or after first-time profile save: shell selects **Home** tab, loads profile, remounts tabs. Skipped on login when profile is still pending (prevents promo **heart loader** overlay on profile setup). `HomeScreen` only shows the heart loader when `/home` is the active route.
- `AuthSessionRefresh.notifyLoggedOut()` — logout (`MenuScreen`) or failed token refresh (`AuthInterceptor`): guest tabs, `ProfileSetupCubit.resetState()`. Does **not** refetch promotional banner.
