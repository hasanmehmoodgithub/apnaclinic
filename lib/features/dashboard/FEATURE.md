# Dashboard feature

## Purpose

Home services grid, promotional banner, search entry, and shell navigation. Keeps **user profile** in sync with the auth user API when the user is logged in.

## Profile sync on dashboard

- **`DashboardCubit`** (created when `HomeScreen` loads) calls **`GetProfileSetupContentUseCase`** in **`syncUserProfileFromApi()`** after services load. Promo banner is read from **`PromotionalBannerSession`** (not fetched per cubit).
- Skips when **`AppPref.getLoginStatus()`** is false.
- On success, **`ProfileSetupRepositoryImpl`** already persists **`UserLocalModel`** (name, email, address, gender, DOB, `imageUrl` from API `image`, etc.).
- **`DashboardServicesState.profileSyncNonce`** increments so **`BlocConsumer`** on home rebuilds and **`HomeHeaderSection`** / greeting reads updated prefs.

## Data & APIs (dashboard-specific)

- Services: `AppUrls.ourServices` → `DashboardRemoteDataSourceImpl` (live CMS). `ServiceCardImage` uses `CachedNetworkImage` for remote `iconPath`; on error, bundled `assets/img/services/*.webp` via `service.route` (`service_icon_fallbacks.dart`).
- Promo: `AppUrls.promotionalBanner` → CMS `GET /api/v1/mobile/banners`. Fetched once at **app open** (`main.dart`) and again only after **login** (`AuthSessionRefresh.consumeReloadPromotionalBanner`). Not called on logout tab remount. `PromotionalBannerSession` caches result and tracks whether the dialog was already shown this session.

Profile uses **`profile_setup`** remote (`GET …/users/{userId}`) — no duplicate URL in dashboard.

## DI

- `dashboard_injection.dart` — registers `DashboardCubit` with `GetProfileSetupContentUseCase` + `AppPref` (profile setup injector must run before dashboard).

## UI

- `HomeScreen` — teal `HomeHeaderSection` (rounded bottom `30.r`, menu + `apna clinic` logo + notification + Login, greeting, white pill **search button** — tap opens `AppRoutes.search`; mic opens voice search), light gray body, 2×2 services grid (`DashboardUiConfig`: **195×122** cards, **63×72** icons, 12px gap, `20.r` radius), `ServiceDiscountBadge`, `InstantDoctorHomeBanner` (`assets/svg/instant_doc.svg` via `InstantDoctorBannerArtwork`), `FikrfreeHealthBanner`. `DashboardCubit` + `NotificationCubit`.
- `MainNavigationShell` — four-tab bar (Home, Instant Doctor, Bookings, Support). Nav icons use filled/outline SVG pairs (`nav_*_filled.svg` / `nav_*_outline.svg`); selected tab shows filled icon. Tab order in `MainNavigationTabs`. Profile is not a bottom tab (header/menu). Exposes `MainNavigationCubit` for in-shell tab switches. Tabs switch **only via bottom nav tap** (no horizontal swipe). Listens to `AuthSessionRefresh` (login/logout) to remount tabs and reload cubits. Bottom bar (`ApnaBottomNavigationBar`) bleeds white into the home-indicator area; shell sets `systemNavigationBarColor` to white (no `SafeArea` wrapper on the bar).

## Session refresh

- `AuthSessionRefresh.notifyLoggedIn()` — after OTP when profile is already complete, or after first-time profile save: shell selects **Home** tab, loads profile, remounts tabs. Skipped on login when profile is still pending (prevents promo **heart loader** overlay on profile setup). `HomeScreen` only shows the heart loader when `/home` is the active route.
- `AuthSessionRefresh.notifyLoggedOut()` — logout (`MenuScreen`) or failed token refresh (`AuthInterceptor`): guest tabs, `ProfileSetupCubit.resetState()`. Does **not** refetch promotional banner.
