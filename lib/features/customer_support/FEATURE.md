# Customer Support feature

## Purpose

Help centre screen with Apna Clinic support card; tapping opens a dialog with CMS support contact details and a call CTA.

## Routes / entry

- `AppRoutes.customerSupport` (from menu / navigation shell).

## Data & APIs

- `AppUrls.mobileSupport` → CMS `GET /api/v1/mobile/support`
- Fetched **on every app open** from splash (`GetCustomerSupportContentUseCase`), and again when the support cubit loads / session refresh remounts tabs. In-flight calls are deduped in the repository.
- Response `data`: `id`, `phone`, `email`, `description`, `buttonText`, `faqsUrl`, `privacyPolicyUrl`, `termsAndConditionsUrl`, `updatedAt`
- Full payload is persisted in `AppPref` (`AppPrefKeys.supportSettings`) and reused if the network call fails. Kept across logout.
- FAQ / Terms / Privacy links in the menu and login footer read those URLs from prefs (not `AppUrls`).
- Mock: `CustomerSupportMockApi` when `MockConfig.enableMocks` is true

## State

- `CustomerSupportCubit` — hydrates from prefs, then refreshes from CMS; `dialNumber()` launches `tel:` URI.

## DI

- `customer_support_injection.dart` — `ApiService`, remote data source, repository (`AppPref`), use case, cubit.

## UI

- `CustomerSupportScreen` — header + `SupportBodyPanel`.
- Support dialog: phone (+ email when API provides it), description, button text from API.
