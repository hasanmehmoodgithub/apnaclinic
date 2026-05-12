# Profile setup feature

## Purpose

Collect or edit user profile (name, gender, email, address, DOB, optional profile image) and sync with user-auth service.

## Routes

- `AppRoutes.profileSetup` — entry from menu or post-login onboarding.

## Data & APIs

- **GET** `AppUrls.userProfileById(userId)` — loads profile; response `data` may include `dob` and/or `dateOfBirth` (strings).
- **PATCH** `AppUrls.saveProfileSetup` — body includes `dob` as `dd-MM-yyyy HH:mm:ss` (see `profileSetupSavePayload`).

## Parsing & UI

- `ProfileSetupMapper` maps API strings to `DateTime?` using ISO `DateTime.tryParse` first, then `dd-MM-yyyy HH:mm:ss`, `dd-MM-yyyy`, and `yyyy-MM-dd` via `intl`.
- `ProfileSetupScreen` calls `loadProfile()` when `getLoginStatus()` is true so DOB and other fields hydrate from the API (not only when profile was previously marked complete).

## State

- `ProfileSetupCubit` / `ProfileSetupState` — `dateOfBirth` drives the date picker label and initial picker date.

## DI

- `profile_setup_injection.dart`

## Mocks

- `data/mock/profile_setup_mock_api.dart` — `MockConfig` / `ProfileSetupMockApi.useMockResponses`.
