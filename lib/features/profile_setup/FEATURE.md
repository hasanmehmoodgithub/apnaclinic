# Profile setup feature

## Purpose

Collect or edit user profile (name, gender, optional email, address, DOB, optional profile image) and sync with user-auth service. Email may be left empty; if filled, it must look like an email (contains `@`).

## Routes

- `AppRoutes.profile` — `ProfileScreen` (BlocProvider `ProfileCubit`); guest vs logged-in content; account list, edit profile, add/remove accounts.
- `AppRoutes.profileSetup` — entry from menu, login (`push` / `pushReplacement`), onboarding/splash (`go` with `ProfileSetupLaunchSource` extra). Back arrow only in **edit** mode (`isProfileCompleted`); first-time setup hides back and blocks system back.
- After **first-time** profile save: `pop()` when possible (returns to the service screen that required login), otherwise `go` home. Edit/update mode still `pop(true)` when possible.

## Analytics

| Event | When | Params |
|---|---|---|
| `profile_creation_screen` | Setup opens from login or Profile/menu edit | `source` (`authentication_screen` / `profile`) |
| `profile_created` | First-time profile save succeeds | — |

Splash/onboarding entry does not send `profile_creation_screen` (source not in spec). Edit/update save does not send `profile_created`.

## Data & APIs

- **GET** `AppUrls.userProfileById(userId)` — loads profile; response `data` may include `dob` and/or `dateOfBirth` (strings) and `image` (profile photo URL).
- **PUT** `AppUrls.userProfileById(userId)` — same `/api/v1.0/user-auth/users/{id}` endpoint as GET; sends `multipart/form-data` via `profileSetupSaveFormData` with text fields + optional `image` file. DOB is sent as `dd-MM-yyyy` under `dob`.

## Parsing & UI

- `ProfileSetupMapper` maps API strings to `DateTime?` using ISO `DateTime.tryParse` first, then `dd-MM-yyyy HH:mm:ss`, `dd-MM-yyyy`, and `yyyy-MM-dd` via `intl`. Profile tiles and account-list cache use the same parser so DOB does not show `--` after add-account refresh.
- GET profile response is read from `data` and supports backend `dob` (for example `02-03-2000 00:00:00`).
- API gender values are normalized to `male` or `female` before binding to the picker.
- `data.image` is stored on `UserLocalModel.imageUrl` and shown on home app bar / profile / menu when non-empty (`UserProfileAvatar` + `CachedNetworkImage`).
- `ProfileSetupScreen` calls `loadProfile()` only when the profile is already completed, so edit/update mode hydrates from API. First-time setup (`userOnboarding: true`) prefills fields from OTP `data.user` stored in `AppPref` (`firstName`, `lastName`, `email`, `gender`, `address`, `dob`, `image`; blank/`[NULL]` names stay empty). `AppPref.isProfileCompleted` is set on **save** only (not on GET).
- Dismisses any global heart loader overlay on open (home banner loader uses root navigator). Edit avatar shows API/local `imageUrl` via `UserProfileAvatar`; a newly picked file takes priority until save.
- Tapping the avatar (full circle or camera badge) opens `ProfileImageSourceSheet` with **Use camera** and **Choose from gallery** (same flow for first-time onboarding and profile update).
- Address accepts letters, numbers, and special characters (`# / & ( ) , . -` and similar); emoji are still blocked. Name fields keep the tighter punctuation allowlist.
- Field max lengths (edit + onboarding): first name **50**, last name **50**, address **255** (`LengthLimitingTextInputFormatter` + `maxLength`; counter UI hidden).
- Completed profiles show edit/update wording; pending onboarding shows setup/save wording.
- On successful update, the PUT runs first, local `AppPref` profile is updated in the repository, GET reloads `imageUrl`, the avatar disk cache is evicted, and `AuthSessionRefresh.notifyProfileUpdated()` rebuilds menu/home avatars. `ProfileScreen` also refreshes after the edit route returns.

## State

- `ProfileCubit` / `ProfileState` — profile screen: reads UI from `AppPref`; fetches GET profile only when `ProfileSessionSync` says the session is not synced and cached prefs exist. After login, logout, or app launch (in-memory reset), the first home/profile open syncs once; revisiting profile uses `AppPref` + cached linked phones without another GET. Explicit `refreshProfile(force: true)` / `loadAccounts(force: true)` after edit or delete account. Add Account from profile pops the new number, opens Account Details (one GET via `GetAccountsListUseCase` + `markSynced`), then `loadAccounts()` without force so Profile tiles reuse `ProfileSessionSync` (no extra GET; network only if details fetch failed).
- `ProfileSetupCubit` / `ProfileSetupState` — `dateOfBirth` drives the date picker label and initial picker date. Manual calendar entry uses `TextInputType.text` so `/` and other date separators are available on the keyboard.

## Session cache

- `ProfileSessionSync` (`lib/core/session/profile_session_sync.dart`) — in-memory guard for the current app launch / login session. Invalidated on login and logout. Marked synced after successful GET profile (`ProfileSetupRepositoryImpl`, `AccountRepositoryImpl`). `hasCachedUserProfile(AppPref)` checks local `UserLocalModel` before skipping network.

## DI

- `profile_setup_injection.dart`

## Mocks

- `data/mock/profile_setup_mock_api.dart` — `MockConfig` / `ProfileSetupMockApi.useMockResponses`.
