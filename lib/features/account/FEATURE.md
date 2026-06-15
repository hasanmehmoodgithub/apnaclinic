# Account feature

## Purpose

Manage linked JazzCash phone numbers on the user profile (account details).

## Routes / entry

- `AppRoutes.accountDetails` — list linked phones from profile API.
- `AppRoutes.addAccount` — add a new phone number.

## Data & APIs

| Action | Method | `AppUrls` | Body |
|--------|--------|-----------|------|
| List phones | GET | `userProfileById(userId)` → `/acs-auth/api/v1/users/{id}` | — (`data.phones[]`) |
| Add phone | POST | `userPhone(userId)` → `/acs-auth/api/v1/users/{id}/phone` | `{ "phone": "923012123412" }` |
| Delete phone | DELETE | `userPhone(userId)` | `{ "phone": "923012123412" }` |

Phone entries: `msisdn`, `jazzCashVerified`, `primary`. UI shows `03…` local format; API uses `92…` MSISDN.

`userId` for phone endpoints prefers `UserLocalModel.apiUserId` (`data.id` from profile), falling back to `AppPref.getUserId()`.

## State

- Profile tab loads phones via `GetAccountsListUseCase`.
- Add/delete via `AddUserPhoneUseCase` / `DeleteUserPhoneUseCase`.

## DI

`initAccountInjector()` — remote data source, repository, use cases.

## Mocks

`AccountMockApi` when `MockConfig.enableAccountMocks` is true (default off; real API in debug).

Before add/delete phone, the app resolves numeric `data.id` via cached profile (`apiUserId`) or a profile GET using the session user id.

After add/delete, account details refresh via `GetProfileSetupContentUseCase` + `GetAccountsListUseCase` (GET profile → `data.phones`).
