# Account feature

## Purpose

Manage linked JazzCash phone numbers on the user profile (account details).

## Routes / entry

- `AppRoutes.accountDetails` — list linked phones from profile API. Optional route `extra`: `showSuccessDialog`, `addedPhone`. When both are set after add-account, the list shows **only the newly added number** behind the success dialog; after **Continue**, the full list reloads.
- `AppRoutes.addAccount` — add a new phone number (`AddAccountFormWidget`). On success: navigates to account details with success dialog (default / profile); pops with added phone when `AddAccountLaunchSource.consultationCheckout` (shared JazzCash Select Account sheet used by consultation / lab / surgery).

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

`AccountMockApi` when `MockConfig.enableAccountMocks` is true (default off; real API).

Before add/delete phone, the app resolves numeric `data.id` via cached profile (`apiUserId`) or a profile GET using the session user id.

After add/delete, account details refresh via `GetAccountsListUseCase` (GET profile → `data.phones`). Profile tab uses the same single call after phone changes; full profile fields reload separately via `GetProfileSetupContentUseCase` on screen open / edit.
