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
  - Booking screen filters partners/labs by booking method (`WALK_IN` / `HOME_SAMPLING`); when no lab supports home sampling, partner/lab grids are hidden, sample type shows **N/A**, and **Add to Cart** is disabled.
- **Book lab test:** `POST AppUrls.labBookTest` → `/acs-aggregator/api/v1/mobile/lab/book-test`
  - Triggered from **checkout** CTA after picking a payment method (JazzCash prompts for an account msisdn; otherwise the patient phone is used).
  - Body: `{ partnerId, labId, cityId, homeSample, paymentMethod, msisdn, patient: { name, age, gender, phoneNumber }, tests: [ { testId } ] }`.
  - `testId`s come from every cart line (supports multiple tests in one booking); `partnerId` / `labId` / `homeSample` come from the first cart line; `cityId` is resolved from the city name via `CitiesRepository`.
- **Lab orders (bookings list):** `GET AppUrls.labOrders` — response items include optional `invoice` (PDF URL). Mapped through `LabOrderModel` → `LabOrderEntity` → bookings list.
- **Lab order detail:** `GET AppUrls.labOrderById(id)` → `/acs-aggregator/api/v1/mobile/lab-orders/{id}` via `GetLabOrderDetailUseCase` when opening View Details from bookings. Same order shape as list items (`data` is a single object). When `invoice` is non-empty (or mocked), `LabTestViewDetailsInvoiceCard` opens the PDF via `AppUrlLauncher`.
- Search debounces (400ms) and re-fetches from the API when a city is selected.

## State

- `LabTestCubit` — `bootstrap()` on create loads cities then `GET lab/tests` when saved/selected city is set; `selectCity()` / search re-fetches with resolved `cityId`.
- `LabTestBookingCubit` — cart + partner/vendor selection for a single test.

## DI

- `lab_test_injection.dart` — `LabTestRemoteDataSource`, `LabTestRepository`, `GetLabTestCatalogUseCase`, `GetLabTestDetailUseCase`, `GetLabOrdersUseCase`, `GetLabOrderDetailUseCase`, `BookLabTestUseCase`, `LabTestCubit`, `LabTestCartCubit`.

## Mocks

- When `MockConfig.enableLabTestMocks` is true, `LabTestMockApi` returns sample mobile API shapes (defaults to real API).
