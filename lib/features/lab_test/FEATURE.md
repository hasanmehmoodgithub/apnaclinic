# Lab test feature

## Purpose

Browse lab tests, booking/cart flow, payment details checkout, and order view details.

## Routes / entry

- `AppRoutes.labTest`, `labTestBooking`, `labTestCart`, `labTestCheckout`, `labTestViewDetails`.
- Tapping a catalog test requires login (`AuthGuard.requireLogin`); guests are redirected to `AppRoutes.authLogin`.
- Opening cart (`labTestOpenCart`) also requires login; guests are redirected to `AppRoutes.authLogin`. Cart badge count is hidden for guests.

## UI

- `LabTestPricePill` (catalog, booking, cart) hides the strikethrough original price when it matches the discounted price.
- Checkout **Payment Details** (`LabTestCheckoutScreen`):
  - Summary card (`LabTestCheckoutSummaryCardWidget`): bordered card with lab logo, test title, lab name, sample type label + pill / method pill, fee + strikethrough **only when original price differs from discounted**, partner logo.
  - Payment breakdown: section title, fee/discount rows, divider, gray total bar (not a nested shadow card).
  - Patient details: **before Edit** = read-only rows with **Edit**; **after Edit** = form with **Done**. Emergency contact always below (required; accepts 10-digit landline or 11-digit mobile).
  - Bottom CTA has no separate white bar behind the button. Panel top radius `20`.
- On open, `LabTestCubit.bootstrap()` reads `AppPrefKeys.labTestSelectedCity`, loads cities, then immediately calls the lab tests API when a saved city resolves to a `cityId`; first visit without a saved city auto-opens the city selection dialog (tests load after pick).
- Booking detail load shows the shared heart loader (`showHeartLoaderDialog`); failure renders the shared `EmptyBookingWidget` with the API message and a retry CTA.
- Selected city is persisted in `AppPrefKeys.labTestSelectedCity` and restored on every lab test visit until the user changes it.

## Data & APIs

- **Cities:** shared `CitiesRepository` + `showSelectCityDialog` (`lib/core/cities/`). Catalog load resolves `cityId` via `cityIdForName`.
- **Lab tests catalog:** `GET AppUrls.labTests` → `/acs-aggregator/api/v1/mobile/lab/tests`
  - Required: `cityId`
  - Optional: `page` (default 1), `limit` (default 20, max 50), `search`, `labId`
  - Response: `data.items[]` with `testId`, `testName`, `sampleType`, `fastingRequired`, `turnaroundHours`, `description`, `labs[]` (pricing per lab/order type).
- **Lab test detail (booking):** `GET AppUrls.labTestDetail` → `/acs-aggregator/api/v1/mobile/lab/tests/{id}?cityId=...`
  - On test tap, app navigates to booking with `LabTestBookingArgs.pending`; `LabTestBookingCubit.loadDetailIfNeeded()` fetches detail on that screen (shimmer → content, same route).
  - Response: `data.partners[]` each with `labs[]` and `pricing.HOME_SAMPLING` / `pricing.WALK_IN` (`price`, `discountPct`, `finalPrice`).
  - Booking screen filters partners/labs by booking method (`WALK_IN` / `HOME_SAMPLING`); when no lab supports home sampling, partner/lab grids are hidden, sample type shows **N/A**, and **Add to Cart** is disabled.
- **Book lab test:** `POST AppUrls.labBookTest` → `/acs-aggregator/api/v1/mobile/lab/book-test`
  - Triggered from **checkout** CTA after picking a payment method via `PaymentMethodSheet(module: lab, includeLocalCashOption: true)` → `GET payment-provider?module=lab` plus a local **Pay via Cash** row (`paymentMethod`: `COD`, not from the API). JazzCash prompts for an account msisdn; otherwise the patient phone is used.
  - While `POST lab/book-test` runs, shows the shared heart loader; on failure shows shared `AlertDialogCard` with the API message.
  - Response may include `data.paymentUrl` → opens shared card payment WebView (`AppRoutes.cardPayment`) before the booked success dialog (`LabTestBookingConfirmationDialogWidget`: **Lab Test Booked!** + **View My Bookings** → Bookings → Labs tab).
  - Body: `{ partnerId, labId, cityId, homeSample, paymentMethod, msisdn, patient: { name, age, gender, phoneNumber }, tests: [ { testId } ] }`.
  - `testId`s come from every cart line (supports multiple tests in one booking); `partnerId` / `labId` / `homeSample` come from the first cart line; `cityId` is resolved from the city name via `CitiesRepository`.
- **Lab orders (bookings list):** `GET AppUrls.labOrders` — response items include optional `invoice` (PDF URL). Mapped through `LabOrderModel` → `LabOrderEntity` → bookings list.
- **Lab order detail:** `GET AppUrls.labOrderById(id)` → `/acs-aggregator/api/v1/mobile/lab-orders/{id}` via `GetLabOrderDetailUseCase` when opening View Details from bookings. Same order shape as list items (`data` is a single object). E-invoice (`LabTestViewDetailsInvoiceCard`) is disabled on this screen.
- Search runs when the user taps the search icon (or keyboard Search); no debounce. A cross icon appears while the field has text and clears the query (`submitSearch('')`). Empty results show `LabTestCatalogEmptyWidget` (“No Record Found” + empty box). Re-fetches from the API when a city is selected.

## State

- `LabTestCubit` — `bootstrap()` on create loads cities then `GET lab/tests` when saved/selected city is set; `selectCity()` / `submitSearch()` re-fetches with resolved `cityId`.
- `LabTestBookingCubit` — cart + partner/vendor selection for a single test. Opening another test while the cart has items prefills the cart’s booking method and partner tab (and lab when offered on that test). If the test only has one partner and it differs from the cart partner, labs for that partner are hidden; tapping that partner shows the cart-clear warning so the user can clear the cart and continue (Add to Cart stays disabled until cart is cleared or partner can match).
- Changing **city** (browse), **booking method**, **service provider**, or **lab** while the cart has items shows `LabTestCartChangeWarningDialogWidget` via `labTestGuardCartClearingChange`; Continue clears the cart (`LabTestCartRepository`), View Cart opens the cart without applying the change.

## DI

- `lab_test_injection.dart` — `LabTestRemoteDataSource`, `LabTestRepository`, `GetLabTestCatalogUseCase`, `GetLabTestDetailUseCase`, `GetLabOrdersUseCase`, `GetLabOrderDetailUseCase`, `BookLabTestUseCase`, `LabTestCubit`, `LabTestCartCubit`.

## Mocks

- When `MockConfig.enableLabTestMocks` is true, `LabTestMockApi` returns sample mobile API shapes (defaults to real API).
