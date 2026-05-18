# Auth feature

## Purpose

Phone OTP request/verify, session persistence via `AppPref`, logout API.

After OTP verification, users go directly to home when the backend marks
onboarding/profile complete (`userOnboarding: false`). Profile setup is shown
when onboarding is still pending (`userOnboarding: true`).

## Data layer

- **Remote:** `data/data_sources/auth_remote_data_source_impl.dart`
  - OTP: `AppUrls.requestOtp`, `AppUrls.verifyOtp`
  - Request OTP `data.expiresIn` is in **seconds** (e.g. `300` → 5 min resend timer).
  - Logout: `AppUrls.logout(userId)` (POST with `{}` body), expects `success: true` before local session is cleared.
  - After successful OTP when onboarding is complete, may fetch `AppUrls.userProfileById` and merge into response.

## Shared core helpers

MSISDN normalization and user id extraction from auth JSON live in **`lib/core/utils/auth_api_utils.dart`** (`AuthApiUtils.normalizeMsisdn`, `AuthApiUtils.extractUserIdFromAuthResponse`) so other features or services can reuse them without importing the data source. User id is resolved from explicit `userId` first, then JWT `userId` / `sub`.

## DI

- `auth_injection.dart` — `AuthRemoteDataSource`, repository, OTP use cases, `LogoutUseCase`, `AuthCubit`.

## Mocks

- `data/mock/auth_mock_api.dart` — toggled via `MockConfig` / `AuthMockApi.useMockResponses`.
