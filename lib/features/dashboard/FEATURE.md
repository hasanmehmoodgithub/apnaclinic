# Dashboard feature

## Purpose

Home services grid, promotional banner, search entry, and shell navigation. Keeps **user profile** in sync with the auth user API when the user is logged in.

## Profile sync on dashboard

- **`DashboardCubit`** (created when `HomeScreen` loads) calls **`GetProfileSetupContentUseCase`** in **`syncUserProfileFromApi()`** right after services and banner loads start.
- Skips when **`AppPref.getLoginStatus()`** is false.
- On success, **`ProfileSetupRepositoryImpl`** already persists **`UserLocalModel`** (name, email, address, gender, DOB, `imageUrl` from API `image`, etc.).
- **`DashboardServicesState.profileSyncNonce`** increments so **`BlocConsumer`** on home rebuilds and **`SearchHeader`** / greeting reads updated prefs.

## Data & APIs (dashboard-specific)

- Services: `AppUrls.ourServices` (see `DashboardRemoteDataSourceImpl`).
- Promo: `AppUrls.promotionalBanner`.

Profile uses **`profile_setup`** remote (`GET …/users/{userId}`) — no duplicate URL in dashboard.

## DI

- `dashboard_injection.dart` — registers `DashboardCubit` with `GetProfileSetupContentUseCase` + `AppPref` (profile setup injector must run before dashboard).

## UI

- `HomeScreen` — `DashboardCubit` + `NotificationCubit`.
- `MainNavigationShell` — tab shell around `HomeScreen`; tabs switch **only via bottom nav tap** (no horizontal swipe between tabs). Listens to `AuthSessionRefresh` (login/logout) to remount all tabs and reload cubits.

## Session refresh

- `AuthSessionRefresh.notifyLoggedIn()` — after OTP login (`AuthCubit`): shell selects **Home** tab (index 2), `ProfileSetupCubit.loadProfile()` (GET user profile), remounts tabs (new `HomeScreen` → new `DashboardCubit` → `syncUserProfileFromApi()` again).
- `AuthSessionRefresh.notifyLoggedOut()` — logout (`MenuScreen`): guest tabs, `ProfileSetupCubit.resetState()`.
