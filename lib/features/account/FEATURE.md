# Account feature

## Purpose

Manage linked JazzCash phone numbers on the user profile (account details).

## Routes / entry

- `AppRoutes.accountDetails` — list linked phones via `GetAccountsListUseCase`. Optional route `extra`: `showSuccessDialog`, `addedPhone`. After add-account, success dialog shows, then Account Details lists **all** saved phones (newly added first when present). Continue / back pops so Profile can apply `ProfileSessionSync` cache.
- `AppRoutes.addAccount` — add a new phone number (`AddAccountFormWidget`). On success: pops the added phone for `profile` / `consultationCheckout`; Account Details + success dialog is opened by Profile (or via `pushReplacement` from Account Details). Successful add invalidates `ProfileSessionSync`; Account Details GET re-syncs it.

## Data & APIs

| Action | Method | `AppUrls` | Body |
|--------|--------|-----------|------|
| List phones | GET | `userProfileById(userId)` → `/acs-auth/api/v1/users/{id}` | — (`data.phones[]`) |
| Add phone | POST | `userPhone(userId)` → `/acs-auth/api/v1/users/{id}/phone` | `{ "phone": "923012123412" }` |
| Delete phone | DELETE | `deleteUserPhone(userId, phoneId)` → `/acs-auth/api/v1/users/{id}/phone/{phoneId}` | — (no body) |

Delete success response: `{ "success": true, "message": "User account removed successfully.", "data": null }`.

Phone entries: `id`, `msisdn`, `jazzCashVerified`, `primary`. UI shows `03…` local format; API uses `92…` MSISDN. Delete uses the phone record `id` from profile `data.phones[]`.

`userId` for phone endpoints prefers `UserLocalModel.apiUserId` (`data.id` from profile), falling back to `AppPref.getUserId()`.

## State

- Profile tab loads phones via `GetAccountsListUseCase`.
- Add/delete via `AddUserPhoneUseCase` / `DeleteUserPhoneUseCase`. Add-account API failure / `success: false` shows `AccountAddFailedDialogWidget` with the API `message` (fallback copy if empty).

## DI

`initAccountInjector()` — remote data source, repository, use cases.

## Mocks

`AccountMockApi` when `MockConfig.enableAccountMocks` is true (default off; real API).

Before add/delete phone, the app resolves numeric `data.id` via cached profile (`apiUserId`) or a profile GET using the session user id.

After add/delete, account details refresh via `GetAccountsListUseCase` (GET profile → `data.phones`). Profile tab caches phones via `ProfileSessionSync` from the same profile GET (must include phone `id`); DOB from `dob`/`dateOfBirth` is parsed to ISO before writing `AppPref` so Profile tiles keep showing the date. Full profile fields reload separately via `GetProfileSetupContentUseCase` on screen open / edit. Add from Profile: one GET on Account Details; Profile `loadAccounts()` after close uses cache unless that GET failed.
