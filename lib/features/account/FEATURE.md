# Account feature

## Purpose

Manage linked JazzCash phone numbers on the user profile (account details).

## Routes / entry

- `AppRoutes.accountDetails` — post add-account confirmation only (no API). Route `extra`: `showSuccessDialog`, `addedPhone`. Shows the newly added number and optional success dialog; full account list lives on the profile tab.
- `AppRoutes.addAccount` — add a new phone number (POST only; no profile GET on open/save). On success, pushes account details (success dialog), then pops back with `true` so profile can refresh accounts.

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
- Add/delete via `AddUserPhoneUseCase` / `DeleteUserPhoneUseCase`.

## DI

`initAccountInjector()` — remote data source, repository, use cases.

## Mocks

`AccountMockApi` when `MockConfig.enableAccountMocks` is true (default off; real API in debug).

Before add/delete phone, the app resolves numeric `data.id` via cached profile (`apiUserId`) or a profile GET using the session user id.

After add/delete, profile tab refreshes phones via `GetAccountsListUseCase` (GET profile → `data.phones`). `AccountDetailsScreen` does not fetch accounts.
