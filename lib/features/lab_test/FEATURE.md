# Lab test feature

## Purpose

Browse lab tests, booking/cart flow, payment details checkout, and order view details.

## Routes / entry

- `AppRoutes.labTest`, `labTestBooking`, `labTestCart`, `labTestCheckout`, `labTestViewDetails`.

## UI

- `LabTestCheckoutBottomBarWidget` — payment details screen CTA uses shared `AppButtonWidget` (`labTestBookCta`).
- On open, `LabTestCubit.bootstrap()` reads `AppPrefKeys.labTestSelectedCity`, loads cities, then immediately calls the lab tests API when a saved city resolves to a `cityId`; first visit without a saved city auto-opens the city selection dialog (tests load after pick).
- Selected city is persisted in `AppPrefKeys.labTestSelectedCity` and restored on every lab test visit until the user changes it.

## Data & APIs

- **Cities:** `CitiesRepository` (prefetched at app open from `AppUrls.cities`). `cityId` resolved via `cityIdForName` when a city is selected.
- **Lab tests catalog:** `GET AppUrls.labTests` → `/acs-aggregator/api/v1/mobile/lab/tests`
  - Required: `cityId`
  - Optional: `page` (default 1), `limit` (default 20, max 50), `search`, `labId`
  - Response: `data.items[]` with `testId`, `testName`, `sampleType`, `fastingRequired`, `turnaroundHours`, `description`, `labs[]` (pricing per lab/order type).
- **Lab test detail (booking):** `GET AppUrls.labTestDetail` → `/acs-aggregator/api/v1/mobile/lab/tests/{id}?cityId=...`
  - On test tap, app navigates to booking with `LabTestBookingArgs.pending`; `LabTestBookingCubit.loadDetailIfNeeded()` fetches detail on that screen (shimmer → content, same route).
  - Response: `data.partners[]` each with `labs[]` and `pricing.HOME_SAMPLING` / `pricing.WALK_IN` (`price`, `discountPct`, `finalPrice`).
  - Booking screen shows all partner labs; when Home Sample is selected for a lab without `HOME_SAMPLING` pricing, sample type shows **N/A**, price is hidden, and **Add to Cart** is disabled.
- Search debounces (400ms) and re-fetches from the API when a city is selected.

## State

- `LabTestCubit` — `bootstrap()` on create loads cities then `GET lab/tests` when saved/selected city is set; `selectCity()` / search re-fetches with resolved `cityId`.
- `LabTestBookingCubit` — cart + partner/vendor selection for a single test.

## DI

- `lab_test_injection.dart` — `LabTestRemoteDataSource`, `LabTestRepository`, `GetLabTestCatalogUseCase`, `GetLabTestDetailUseCase`, `LabTestCubit`.

## Mocks

- When `MockConfig.enableLabTestMocks` is true, `LabTestMockApi` returns sample mobile API shapes (defaults to real API).
