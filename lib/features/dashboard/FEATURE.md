# Dashboard feature

## Purpose

Home services grid, promotional banner, search entry, and shell navigation. Keeps **user profile** in sync with the auth user API when the user is logged in.

## Analytics

See `lib/core/analytics/ANALYTICS.md`. Home fires `home_screen` on open; service tiles (`pharmacy` / `consultation` / `lab` / `surgery` `_tile_clicked`); `search_clicked` (`source_screen` `home screen`); `notifications_screen_open`; `banner_clicked` (`content_url`); Instant Doctor entry via `instant_doctor_clicked`; menu/bottom-nav `my_bookings_clicked` / `support_clicked`.

## Profile sync on dashboard

- **`DashboardCubit`** (created when `HomeScreen` loads) calls **`GetProfileSetupContentUseCase`** in **`syncUserProfileFromApi()`** after services load, unless **`ProfileSessionSync`** already synced this session and **`AppPref`** has cached profile fields. Promo banners are fetched via **`PromotionalBannerSession.ensureLoaded()`** from this cubit only (not app start / shell login).
- Skips when **`AppPref.getLoginStatus()`** is false.
- On success, **`ProfileSetupRepositoryImpl`** already persists **`UserLocalModel`** (name, email, address, gender, DOB, `imageUrl` from API `image`, etc.) and **`AuthSessionRefresh.notifyProfileUpdated()`** so menu rebuilds.
- Skip cache requires first/last name or email (phone from OTP alone is not enough).
- **`DashboardServicesState.profileSyncNonce`** increments so **`BlocConsumer`** on home rebuilds and **`HomeHeaderSection`** / greeting reads updated prefs.

## Data & APIs (dashboard-specific)

- Services: `AppUrls.ourServices` → `DashboardRemoteDataSourceImpl` (live CMS). `ServiceCardImage` loads remote icons (PNG, WebP, SVG); on empty URL or load failure shows a styled placeholder only.
- Promo: `AppUrls.promotionalBanner` → CMS `GET /api/v1/mobile/banners`. Fetched **only when the dashboard (`HomeScreen`) opens** via `DashboardCubit.syncPromotionalBannerFromSession` → `PromotionalBannerSession.ensureLoaded()`. Login clears the session queue (`prepareForLoginRefresh`) so the next home open refetches; no banner call from `main.dart` or shell. Response may include multiple banners (sorted by `displayOrder`); home shows them **one after another** (close 1st → show 2nd → …). Each item: `imagePath`, optional `ctaUrl` (external `http(s)` URL), `route` string split on `/` (object form still accepted). Banner tap: `bottomsheet/1` → bottom-nav tab (`0` Home, `1` Instant Doctor, `2` Bookings, `3` Support; Instant Doctor / Bookings require login); `screen/{name}` or `sheet/{name}` → Instant Doctor tab when `{name}` is `instant-doctor`, otherwise `go_router`. http `ctaUrl` → external browser. Empty/`null` `ctaUrl` does not hide `route`. Network banner image (`CachedNetworkImage`) uses rounded `PromotionalBannerShimmer` as `placeholder` (opacity 0.4); load failure falls back to `Assets.imgBanner`.
- App update: `AppUrls.appVersion(platform: ios|android)` → CMS `GET /api/v1/mobile/app-version?platform=…`. Checked on **every dashboard open** (`DashboardCubit.checkAppUpdate`). CMS `data`: `minVersion`, `latestVersion`, `isForceUpgrade`, `releaseNotes`, `isActive` (inactive ignored). Compares device `package_info` version; shows themed `AppUpdateDialog` (`isForceUpgrade` / below min = non-dismissible). Optional update before promo banners; force blocks banners. No `storeUrl` in CMS → Play/App Store fallbacks in `AppUrls`. Missing record (HTTP 200 + code 404) = no update.

Profile uses **`profile_setup`** remote (`GET …/users/{userId}`) — no duplicate URL in dashboard.

## DI

- `dashboard_injection.dart` — registers `DashboardCubit` with `GetProfileSetupContentUseCase` + `AppPref` (profile setup injector must run before dashboard).

## UI

- `HomeScreen` — teal `HomeHeaderSection` (rounded bottom `30.r`, drawer menu (`assets/img/ic_menu_drawer.png`) + combined wordmark (`assets/img/brand_apnaclinic_home.png`) + notification + Login/profile avatar, greeting, white pill **search button** — tap opens `AppRoutes.search`; search glyph `assets/svg/ic_search.svg`, mic `ic_search_mic.svg` for voice). Right avatar opens `AppRoutes.profile` (`ProfileScreen`; login required). Light gray body, 2×2 services grid (`DashboardUiConfig`: **195×122** cards, **90×103** icons, 12px gap, `20.r` radius), `ServiceDiscountBadge` (API text as-is in a reserved top-right slot so image/title stay aligned when CMS `discount` is empty; wraps so full text shows), `InstantDoctorHomeBanner` (`assets/img/instantDocBanner.png`, Figma card **398×98.35**, radius **16**, padding **4**, artwork **104.22×94.35** flush bottom-right), `FikrfreeHealthBanner` (tap opens the FikrFree app if installed via `ExternalAppLauncher`; otherwise [App Store](https://apps.apple.com/us/app/fikrfree/id6739287582) on iOS / [Play Store](https://play.google.com/store/apps/details?id=com.fikrfree.android) on Android). `DashboardCubit` + `NotificationCubit`.
- `MenuScreen` — thin screen: session listener always rebuilds on `AuthSessionRefresh` (login + `notifyProfileUpdated`) so the profile card picks up hydrated name/phone. Composes `MenuHeader`, `MenuScreenBody` (profile card, action tiles, about), `MenuLogoutButton`. Config in `menu_screen_config.dart`; profile labels in `menu_profile_mapper.dart`; logout in `menu_logout_handler.dart`. Confirm logout shows `showHeartLoaderDialog` until the logout API and `LocalLogoutService` finish. **App Version** in About is the device `package_info` value (`version (build)` from `pubspec.yaml`, currently `1.0.1 (1)`), not a hardcoded string. **My Bookings** switches to Bookings bottom-nav tab (login required). Customer Support, FAQ, About (terms/privacy via in-app browser / Custom Tabs; FAQ/website external). FAQ / Terms / Privacy URLs come from CMS support settings in `AppPref` (`faqsUrl`, `termsAndConditionsUrl`, `privacyPolicyUrl`). Logout clears local session via `LocalLogoutService` even when API fails.
- `MainNavigationShell` — four-tab bar (Home, Instant Doctor, Bookings, Support). Nav icons use filled SVG (or PNG for Support) when selected and inactive outline PNGs (`nav_*_outline.png`) when unselected; selected tab shows filled icon. Tab order in `MainNavigationTabs`. Profile is not a bottom tab (home header avatar / menu). Exposes `MainNavigationCubit` for in-shell tab switches. Tabs switch **only via bottom nav tap** (no horizontal swipe). Instant Doctor and Bookings require login: guest taps store a pending tab via `AuthSessionRefresh.requestTabIndex`, open login, then after login `pop` the shell resumes that tab (instead of forcing Home). Listens to `AuthSessionRefresh` (login/logout) to remount tabs and reload cubits. Bottom bar (`ApnaBottomNavigationBar`): fixed height, no extra bottom padding. Shell sets `systemNavigationBarColor` to white. System back on a non-home tab returns to Home; on Home shows themed `AppCloseDialog` (same confirm style as logout); confirm calls `SystemNavigator.pop()`. Showing the Bookings tab logs `my_bookings_tab` (bottom nav, menu My Bookings, post-checkout, or after login resume).

## Session refresh

- `AuthSessionRefresh.notifyLoggedIn()` — after OTP when profile is already complete, or after first-time profile save: shell remounts tabs and loads profile. Defaults to **Home** unless a **pending tab** was requested before login (Instant Doctor / Bookings / menu My Bookings); then that tab is resumed after login. Skipped on login when profile is still pending (prevents promo **heart loader** overlay on profile setup). `HomeScreen` only shows the heart loader when `/home` is the active route.
- `MenuScreen` **My Bookings** (guest): requests Bookings tab, opens login; after successful login closes the menu so the Bookings tab is visible.
- `AuthSessionRefresh.notifyLoggedOut()` — logout (`MenuScreen`) or failed token refresh (`AuthInterceptor`): guest tabs, `ProfileSetupCubit.resetState()`. Menu logout always clears local session via `LocalLogoutService` even when the logout API fails.
