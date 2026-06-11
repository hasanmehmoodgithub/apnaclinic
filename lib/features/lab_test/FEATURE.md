# Lab test feature

## Purpose

Browse lab tests, booking/cart flow, payment details checkout, and order view details.

## Routes / entry

- `AppRoutes.labTest`, `labTestBooking`, `labTestCart`, `labTestCheckout`, `labTestViewDetails`.

## UI

- `LabTestCheckoutBottomBarWidget` — payment details screen CTA uses shared `AppButtonWidget` (`labTestBookCta`).
- Catalog loads **after city selection**; first visit without a saved city auto-opens the city selection dialog.
- Selected city is persisted in `AppPrefKeys.labTestSelectedCity` and restored on every lab test visit until the user changes it.

## Data & APIs

- **Cities:** `CitiesRepository` (prefetched at app open from `AppUrls.cities`). `cityId` resolved via `cityIdForName` when a city is selected.
- **Lab tests catalog:** `GET AppUrls.labTests` → `/acs-aggregator/api/v1/mobile/lab/tests`
  - Required: `cityId`
  - Optional: `page` (default 1), `limit` (default 20, max 50), `search`, `labId`
  - Response: `data.items[]` with `testId`, `testName`, `sampleType`, `fastingRequired`, `turnaroundHours`, `description`, `labs[]` (pricing per lab/order type).
- Search debounces (400ms) and re-fetches from the API when a city is selected.

## State

- `LabTestCubit` — `loadCities()` on init; `selectCity()` / search triggers `loadCatalog` with resolved `cityId`.
- `LabTestBookingCubit` — cart + partner/vendor selection for a single test.

## DI

- `lab_test_injection.dart` — `LabTestRemoteDataSource`, `LabTestRepository`, `GetLabTestCatalogUseCase`, `LabTestCubit`.

## Mocks

- When `MockConfig.enableMocks` is true, `LabTestMockApi.getLabTestsSuccessResponse` returns sample mobile API shape.
