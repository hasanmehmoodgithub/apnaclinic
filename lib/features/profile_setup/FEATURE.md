# Profile setup feature

## Purpose

Collect or edit user profile (name, gender, email, address, DOB, optional profile image) and sync with user-auth service.

## Routes

- `AppRoutes.profile` — `ProfileScreen` (BlocProvider `ProfileCubit`); guest vs logged-in content; account list, edit profile, add/remove accounts.
- `AppRoutes.profileSetup` — entry from menu, login (`push`), onboarding/splash (`go` with `ProfileSetupLaunchSource` extra). Back arrow only in **edit** mode (`isProfileCompleted`); first-time setup hides back and blocks system back.

## Data & APIs

- **GET** `AppUrls.userProfileById(userId)` — loads profile; response `data` may include `dob` and/or `dateOfBirth` (strings) and `image` (profile photo URL).
- **PUT** `AppUrls.userProfileById(userId)` — same `/api/v1.0/user-auth/users/{id}` endpoint as GET; sends `multipart/form-data` via `profileSetupSaveFormData` with text fields + optional `image` file. DOB is sent as `dd-MM-yyyy` under `dob`.

## Parsing & UI

- `ProfileSetupMapper` maps API strings to `DateTime?` using ISO `DateTime.tryParse` first, then `dd-MM-yyyy HH:mm:ss`, `dd-MM-yyyy`, and `yyyy-MM-dd` via `intl`.
- GET profile response is read from `data` and supports backend `dob` (for example `02-03-2000 00:00:00`).
- API gender values are normalized to `male` or `female` before binding to the picker.
- `data.image` is stored on `UserLocalModel.imageUrl` and shown on home app bar / profile / menu when non-empty (`UserProfileAvatar` + `CachedNetworkImage`).
- `ProfileSetupScreen` calls `loadProfile()` only when the profile is already completed, so edit/update mode hydrates from API while first-time onboarding stays in setup mode. `AppPref.isProfileCompleted` is set on **save** only (not on GET).
- Dismisses any global heart loader overlay on open (home banner loader uses root navigator). Edit avatar shows API/local `imageUrl` via `UserProfileAvatar`; a newly picked file takes priority until save.
- Completed profiles show edit/update wording; pending onboarding shows setup/save wording.
- On successful update, the PUT runs first, local `AppPref` profile is updated in the repository, and `ProfileScreen` refreshes after the edit route returns.

## State

- `ProfileCubit` / `ProfileState` — profile screen: refresh profile from API, load/delete linked accounts; `ProfileViewData` maps `AppPref` user fields for UI.
- `ProfileSetupCubit` / `ProfileSetupState` — `dateOfBirth` drives the date picker label and initial picker date.

## DI

- `profile_setup_injection.dart`

## Mocks

- `data/mock/profile_setup_mock_api.dart` — `MockConfig` / `ProfileSetupMockApi.useMockResponses`.
