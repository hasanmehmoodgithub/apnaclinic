# Auth feature

## Purpose

Phone OTP request/verify, session persistence via `AppPref`, logout API.

Login footer legal links (`LoginLegalText`) open `AppUrls.termsAndConditions` and
`AppUrls.privacyPolicy` in the device browser via `AppUrlLauncher`.

After OTP verification, users go to **home** when the backend marks profile
complete (`userOnboarding: false` / `isOnboardingCompleted: true`). Otherwise
they go to **profile setup** (`userOnboarding: true`).

`AppPref.isOnboardingCompleted` is only for the intro carousel (not overwritten
on login). `AppPref.isProfileCompleted` tracks whether profile setup is done.

On login, `AuthSessionRefresh.notifyLoggedIn()` runs only when profile is
already complete (avoids remounting `HomeScreen` under the login route, which
would open the dashboard promo heart loader). After first-time profile save,
profile setup calls `notifyLoggedIn()` then navigates home.
Splash and `/home` redirect logged-in users without a completed profile to
profile setup.

## Data layer

- **Remote:** `data/data_sources/auth_remote_data_source_impl.dart`
  - OTP verify: `AppUrls.verifyOtp` — body includes `msisdn`, `otp`, and `fcmToken` when the device token is available (`NotificationService` / `AppPref`).
  - If login shows “unable to reach server”, check device network/VPN, iOS ATS (HTTP allowed for Jazz domains), and dev SSL config (`dio_app_network_config.dart`).
  - Request OTP `data.expiresIn` is in **seconds** (e.g. `300` → 5 min resend timer).
  - Logout: `AppUrls.logout` (POST body `{ "refreshToken": "<stored refresh token>" }`). Local session is **always** cleared via `LocalLogoutService` even if the API fails; a snackbar may show the server error.
  - After successful OTP when onboarding is complete, may fetch `AppUrls.userProfileById` and merge into response.

## Shared core helpers

MSISDN normalization and user id extraction from auth JSON live in **`lib/core/utils/auth_api_utils.dart`** (`AuthApiUtils.normalizeMsisdn`, `AuthApiUtils.extractUserIdFromAuthResponse`) so other features or services can reuse them without importing the data source. User id is resolved from explicit `userId` first, then JWT `userId` / `sub`.

## DI

- `auth_injection.dart` — `AuthRemoteDataSource`, repository, OTP use cases, `LogoutUseCase`, `AuthCubit`.

## Mocks

- `data/mock/auth_mock_api.dart` — toggled via `MockConfig` / `AuthMockApi.useMockResponses`.
