# Profile setup feature

## Purpose

Collect or edit user profile (name, gender, email, address, DOB, optional profile image) and sync with user-auth service.

## Routes

- `AppRoutes.profileSetup` — entry from menu or post-login onboarding.

## Data & APIs

- **GET** `AppUrls.userProfileById(userId)` — loads profile; response `data` may include `dob` and/or `dateOfBirth` (strings).
- **PATCH** `AppUrls.userProfileById(userId)` — same `/api/v1.0/user-auth/users/{id}` endpoint as GET; sends `multipart/form-data` via `profileSetupSaveFormData` with text fields + optional `image` file. DOB is sent as `dd-MM-yyyy` under `dob`.

## Parsing & UI

- `ProfileSetupMapper` maps API strings to `DateTime?` using ISO `DateTime.tryParse` first, then `dd-MM-yyyy HH:mm:ss`, `dd-MM-yyyy`, and `yyyy-MM-dd` via `intl`.
- GET profile response is read from `data` and supports backend `dob` (for example `02-03-2000 00:00:00`).
- API gender values are normalized to the form values `male`, `female`, or `other` before binding to the dropdown.
- `ProfileSetupScreen` calls `loadProfile()` only when the profile is already completed, so edit/update mode hydrates from API while first-time onboarding stays in setup mode.
- Completed profiles show edit/update wording; pending onboarding shows setup/save wording.
- On successful update, the PATCH runs first, local `AppPref` profile is updated in the repository, and `ProfileScreen` refreshes after the edit route returns.

## State

- `ProfileSetupCubit` / `ProfileSetupState` — `dateOfBirth` drives the date picker label and initial picker date.

## DI

- `profile_setup_injection.dart`

## Mocks

- `data/mock/profile_setup_mock_api.dart` — `MockConfig` / `ProfileSetupMockApi.useMockResponses`.
