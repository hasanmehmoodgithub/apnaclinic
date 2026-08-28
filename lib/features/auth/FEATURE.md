# Auth feature

## Purpose

Phone OTP request/verify, session persistence via `AppPref`, logout API.

Login footer legal links (`LoginLegalText`) open Terms and Privacy from
`AppPref.getSupportSettings()` (`termsAndConditionsUrl` / `privacyPolicyUrl`,
loaded from CMS support settings on app open) via `AppUrlLauncher` with
`LaunchMode.inAppBrowserView` (Safari / Chrome Custom Tabs — not the raw
in-app WebView, which showed a black screen).

After OTP verification, users with a completed profile (`userOnboarding: false` /
`isOnboardingCompleted: true`) return to the previous screen via `pop()` when
login was pushed from any guest-gated action (`AuthGuard.requireLogin` —
consultation, pharmacy, lab test, surgery, dashboard menus, etc.). If there is
nothing to pop (login opened as a root destination), they `go` to **home**.

For **Instant Doctor** and **My Bookings** bottom-nav (and home banner /
menu entry), the intended tab is stored with
`AuthSessionRefresh.requestTabIndex` before login; after login the shell
resumes that tab instead of forcing Home.

Incomplete profiles go to **profile setup**. When login itself was pushed from a
service screen, login is **replaced** by profile setup so the stack stays
`… → service → profile setup`; on first save, profile setup `pop()`s back to
that service. Cold/onboarding entry still ends on **home**.

`AppPref.isOnboardingCompleted` is only for the intro carousel (not overwritten
on login). `AppPref.isProfileCompleted` tracks whether profile setup is done.

Guest login from a service passes `source` on `AppRoutes.authLogin` via
`AuthGuard.requireLogin(loginSource:)` (`pharmacy` / `instant_doctor` /
`consultancy` / `lab` / `surgery`). Explicit login CTAs (home, profile, menu)
use `source=login`.

## Analytics

| Event | When | Params |
|---|---|---|
| `authentication_screen_viewed` | Login screen opens | `source` |
| `otp_sent` | OTP request succeeds (including resend) | — |
| `otp_verified` | OTP verify succeeds | — |

## Data layer

On login, `AuthSessionRefresh.notifyLoggedIn()` runs **after** `isLoading` is
cleared, and only when profile is already complete (avoids remounting
`HomeScreen` under the login route, which would open the dashboard promo heart
loader). Post-OTP `GET …/users/{id}` still runs before that notify so prefs have
the name, but it does **not** call `notifyProfileUpdated()` — that used to jump
the shell to a pending Bookings tab while Verify was still spinning. Session
save errors always clear the Verify spinner. After first-time profile save,
profile setup calls `notifyLoggedIn()` then navigates home.
Splash and `/home` redirect logged-in users without a completed profile to
profile setup.

## Data layer

- **Remote:** `data/data_sources/auth_remote_data_source_impl.dart`
  - OTP verify: `AppUrls.verifyOtp` — body includes `msisdn`, `otp`, and `fcmToken` when a token is **already cached** (`NotificationService.fcmToken` / `AppPref`). Verify does **not** wait on Firebase/FCM init. After success, FCM upload/sync runs in the background (`markDeviceTokenUploaded` / `syncDeviceTokenIfNeeded`).
  - FCM rotation (logged in only, token changed): `PUT AppUrls.updateFcmDeviceToken` → `/acs-auth/api/v1/notifications/device-token` body `{ "fcmToken": "..." }` via `UpdateFcmDeviceTokenUseCase`. Triggered by Firebase `onTokenRefresh`, app start, or resume — never on JWT refresh or every API.
  - If login shows “unable to reach server”, check device network/VPN, iOS ATS (HTTP allowed for Jazz domains), and dev SSL config (`dio_app_network_config.dart`).
  - Request OTP `data.expiresIn` is in **seconds** (e.g. `300` → 5 min resend timer).
  - Logout: `AppUrls.logout` (POST body `{ "refreshToken": "<stored refresh token>" }`). Local session is **always** cleared via `LocalLogoutService` even if the API fails; a snackbar may show the server error. FCM prefs + Firebase `deleteToken()` run on this path (delete is not awaited on the UI).
  - Auto-logout (JWT refresh fail on 401): `AuthInterceptor` calls the same `LocalLogoutService.clearAll()` — no logout API and no device-token PUT (tokens are already dead).
  - After successful OTP, `AuthCubit` persists `data.user` (`id`, `firstName`, `lastName`, `gender`, `email`, `address`, `dob` / `dateOfBirth`, `image`) into `UserLocalModel`. User id is taken from `user.id` (then JWT `sub`). Null / `"[NULL]"` fields are stored empty. When `userOnboarding` is **false** (profile already complete), it also calls `GetProfileSetupContentUseCase` (`GET …/users/{id}`) before `notifyLoggedIn` (prefs only — no `notifyProfileUpdated`). When `userOnboarding` is **true**, profile setup prefills from that local `user` payload (no GET), including the avatar URL.

## Shared core helpers

MSISDN normalization and user id extraction from auth JSON live in **`lib/core/utils/auth_api_utils.dart`** (`AuthApiUtils.normalizeMsisdn`, `AuthApiUtils.extractUserIdFromAuthResponse`) so other features or services can reuse them without importing the data source. User id is resolved from explicit `userId` first, then JWT `userId` / `sub`.

## DI

- `auth_injection.dart` — `AuthRemoteDataSource`, repository, OTP use cases, `LogoutUseCase`, `UpdateFcmDeviceTokenUseCase`, `AuthCubit`.

## Mocks

- `data/mock/auth_mock_api.dart` — toggled via `MockConfig` / `AuthMockApi.useMockResponses`.
