# Lab test feature

## Purpose

Browse lab tests, booking/cart flow, payment details checkout, and order view details.

## Routes / entry

- `AppRoutes.labTest`, `labTestBooking`, `labTestCart`, `labTestCheckout`, `labTestViewDetails`, `labTestReportViewer`.
- Tapping a catalog test requires login (`AuthGuard.requireLogin`); guests are redirected to `AppRoutes.authLogin`.
- Opening cart (`labTestOpenCart`) also requires login; guests are redirected to `AppRoutes.authLogin`. Cart badge count is hidden for guests.

## UI

- `LabTestPricePill` (catalog, booking, cart) hides the strikethrough original price when it matches the discounted price.
- Checkout **Payment Details** (`LabTestCheckoutScreen`):
  - One summary card per cart line (`LabTestCheckoutSummaryCardWidget` / `LabTestCheckoutLineArgs`): lab logo, test title, lab name, sample type + Walk In/Home Sample pill, per-test fee + strikethrough when original differs, partner logo.
  - `labTestCartToCheckoutArgs` sums original fees, discounts, and discounted totals across all cart lines for the breakdown.
  - Payment breakdown: section title, aggregated Fee / Discount (%) / Total (discount row hidden when amount is 0), divider, gray total bar.
  - Patient details: **before Edit** = read-only rows with **Edit**; **after Edit** = form with **Done**. Age accepts digits only, max 3. Emergency contact always below (required; accepts 10-digit landline or 11-digit mobile).
  - Required-fields / invalid-phone errors above the CTA use `LabTestCheckoutErrorBannerWidget` (light-pink background + info icon), not plain red text.
  - Bottom CTA has no separate white bar behind the button. Panel top radius `20`.
- On open, `LabTestCubit.bootstrap()` reads `AppPrefKeys.labTestSelectedCity`, loads cities, then immediately calls the lab tests API when a saved city resolves to a `cityId`; first visit without a saved city auto-opens the city selection dialog (tests load after pick).
- Booking detail load shows the shared heart loader (`showHeartLoaderDialog`); failure renders the shared `EmptyBookingWidget` with the API message and a retry CTA.
- Selected city is persisted in `AppPrefKeys.labTestSelectedCity` and restored on every lab test visit until the user changes it.

## Data & APIs

- **Cities:** shared `CitiesRepository` + `showSelectCityDialog` (`lib/core/cities/`). Catalog load resolves `cityId` via `cityIdForName`.
- **Lab tests catalog:** `GET AppUrls.labTests` → `/acs-aggregator/api/v1/mobile/lab/tests`
  - Required: `cityId`
  - Optional: `page` (default 1), `limit` (default 20, max 50), `search`, `labId`
  - Response: `data.items[]` with `testId`, `testName`, `sampleType`, `fastingRequired`, `turnaroundHours`, `description`, `labs[]` (pricing per lab/order type); pagination via `data.page`, `data.limit`, `data.total`, `data.totalPages`.
  - Browse list loads **page 1 / limit 20**, then `LabTestCubit.loadMoreCatalog()` appends the next page when the user scrolls near the bottom.
- **Lab test detail (booking):** `GET AppUrls.labTestDetail` → `/acs-aggregator/api/v1/mobile/lab/tests/{id}?cityId=...`
  - On test tap, app navigates to booking with `LabTestBookingArgs.pending`; `LabTestBookingCubit.loadDetailIfNeeded()` fetches detail on that screen (shimmer → content, same route).
  - Response: `data.partners[]` each with `labs[]` and `pricing.HOME_SAMPLING` / `pricing.WALK_IN` (`price`, `discountPct`, `finalPrice`).
  - Booking screen filters partners/labs by booking method (`WALK_IN` / `HOME_SAMPLING`). On detail load, auto-selects the first available method (Walk In when both exist; Home Sample when only `HOME_SAMPLING` offers). Method tiles are disabled when that order type has no pricing. When the selected method has no offers, partner/lab grids are hidden, sample type shows **N/A**, and **Add to Cart** is disabled.
- **Book lab test:** `POST AppUrls.labBookTest` → `/acs-aggregator/api/v1/mobile/lab/book-test`
  - Triggered from **checkout** CTA after picking a payment method via `PaymentMethodSheet(module: lab, includeLocalCashOption: true)` → `GET payment-provider?module=lab` plus a local **Pay via Cash** row (`paymentMethod`: `COD`, not from the API). JazzCash prompts for an account msisdn; otherwise the patient phone is used.
  - While `POST lab/book-test` runs, shows the shared heart loader; on failure shows shared `AlertDialogCard` with the API message.
  - Response may include `data.paymentUrl` → opens the **same** shared card payment WebView as pharmacy (`settleCardPaymentIfNeeded` → `AppRoutes.cardPayment` / `PaymentWebViewScreen`, with `allowClose: true` so the AppBar **X** can dismiss) before the booked success dialog. Cancel/fail shows `PaymentOutcomeDialogWidget`. Payment URL parsing mirrors pharmacy unwrap (`data` / nested `data.data`, plus `paymentUrl` / `payment_url` and common aliases). If `data.blockingOrder` is present, skip the WebView and show `PaymentPendingDialogWidget` (CTA **View My Bookings**; app copy, or `blockingOrder.message` when present). If `blockingOrder.canAbandon` is true, a secondary CTA calls `POST AppUrls.labBookTestAbandon` with `{ "order_id": publicId, "unified_order_id": 0 }` (`publicId` from `blockingOrder` then booking `data`). Cart is not cleared on a blocking order so the user can Proceed again after abandon. If `blockingOrder` is absent, the booking can proceed. Success / pending dialogs are non-cancelable (`barrierDismissible: false` + `PopScope(canPop: false)`); only the CTA dismisses them. After a successful booking or successful card payment, the local lab cart is cleared via `LabTestCartRepository`.
  - Body: `{ partnerId, labId, cityId, homeSample, paymentMethod, msisdn, patient: { name, age, gender, phoneNumber }, tests: [ { testId } ] }`.
  - `testId`s come from every cart line (supports multiple tests in one booking); `partnerId` / `labId` / `homeSample` come from the first cart line; `cityId` is resolved from the city name via `CitiesRepository`.
- **POST** `AppUrls.labBookTestAbandon` — `/api/v1/mobile/lab/book-test/abandon` JSON `{ "order_id": "<publicId>", "unified_order_id": 0 }` via `AbandonLabTestBookingUseCase`. Called from the pending-payment dialog when `blockingOrder.canAbandon` is true. After success, user stays on checkout and can pay again.
- **Lab orders (bookings list):** `GET AppUrls.labOrders` — envelope `{ success, message, data: { data[], page, limit, total } }`. Items use `orderId` (int), display `status` (`Confirmed` / `Payment Pending`), `orderType` (`WALK_IN` / `HOME_SAMPLING`), nested `lab` / `partner` / `patient` / `tests[]` / `pricing`, optional `reports[]` (no `invoice` / `publicId` on current API). Mapped through `LabOrderModel` → `LabOrderEntity` → bookings list. Lab logos use API HTTP `logoUrl` only (localhost ignored); missing logos show the shared placeholder — **no remapping to another lab’s bundled asset**.
- **Lab order detail:** `GET AppUrls.labOrderById(id)` → `/acs-aggregator/api/v1/mobile/lab-orders/{id}` via `GetLabOrderDetailUseCase` when opening View Details from bookings. Same order shape as list items (`data` is a single object). View Details **Sample Type** maps `orderType` (`HOME_SAMPLING` → Home Sample, `WALK_IN` → Walk In). **Test Results** renders one card per `data.tests[]` (name, per-test `price`, per-test `status`). A single **Download Report** button below the cards is enabled when `data.reports[]` is non-empty (`reportStatus` `READY` / `AVAILABLE` shows the ready note). Tapping it downloads each PDF with Dio to app documents (`lab_reports/`) via `DownloadLabReportUseCase` (does **not** launch the remote URL). The heart loader is dismissed first, then the local file is shown on `LabTestReportViewerScreen` (`AppRoutes.labTestReportViewer`) with `flutter_pdfview`. Snackbar on download failure. **E-Invoice** (`BookingInvoiceTileWidget`) uses **GET** `AppUrls.mobileInvoice(LAB, orderId)` via shared `DownloadInvoiceUseCase` (numeric unified `orderId`, not `publicId`; same PDF viewer).
- Search runs when the user taps the search icon (or keyboard Search); no debounce. A cross icon appears while the field has text and clears the query (`submitSearch('')`). Empty results show `LabTestCatalogEmptyWidget` (“No Record Found” + empty box). Re-fetches from the API when a city is selected.

## State

- `LabTestCubit` — `bootstrap()` on create loads cities then `GET lab/tests` when saved/selected city is set; `selectCity()` / `submitSearch()` re-fetches page 1; `loadMoreCatalog()` appends the next page while scrolling.
- `LabTestBookingCubit` — cart + partner/vendor selection for a single test. Opening another test while the cart has items prefills the cart’s booking method and partner tab (and lab when offered on that test). If the test only has one partner and it differs from the cart partner, labs for that partner are hidden; tapping that partner shows the cart-clear warning so the user can clear the cart and continue (Add to Cart stays disabled until cart is cleared or partner can match).
- Changing **city** (browse), **booking method**, **service provider**, or **lab** while the cart has items shows `LabTestCartChangeWarningDialogWidget` via `labTestGuardCartClearingChange`; Continue clears the cart (`LabTestCartRepository` + shared `LabTestCartCubit`), View Cart opens the cart without applying the change. **Add to Cart** uses the same warning when the selected lab / partner / method differs from the cart (e.g. user went back to the listing and opened a test from another lab). Continue then adds the new selection. Listing / booking headers rebuild cart badge from the shared cubit on add/remove/clear.

## DI

- `lab_test_injection.dart` — `LabTestRemoteDataSource`, `LabTestRepository`, `GetLabTestCatalogUseCase`, `GetLabTestDetailUseCase`, `GetLabOrdersUseCase`, `GetLabOrderDetailUseCase`, `BookLabTestUseCase`, `AbandonLabTestBookingUseCase`, `DownloadLabReportUseCase`, `LabTestCubit`, singleton `LabTestCartCubit` (shared badge/count across listing, booking, and cart).

## Analytics

Firebase via `LabTestAnalytics` / `AnalyticsService`. `lab_module` fires on the hub (`AppRoutes.labTest`). City restore on bootstrap does not fire `lab_city_change`; only a user pick in the city dialog does. Global search lab results fire `lab_item_select` (and `search_result_clicked`); they do not fire `lab_module` (no `source` on that event). Not logged: `fb_content_type` / `content_type` (Firebase only), `transaction_id`, `partner` on confirm (cart stores partner id, not display name), `address` (checkout has no street field). `promo` is sent only when `discountCode` is non-empty. Pending card payment without URL does not fire `lab_booking_confirmed`. Cash checkout sends `payment_method`=`COD` (spec samples list JazzCash / Card). Lab booking details fire `booking_viewed` (`type=lab`) via `BookingsAnalytics`.

| Event | When | Params |
|---|---|---|
| `lab_module` | Lab hub opens | — |
| `lab_city_change` | User picks a city | `selected_city` |
| `lab_search_clicked` | Search field or search icon tap | — |
| `lab_search_performed` | Non-empty catalog search | `keyword`, `result_items` |
| `lab_item_select` | Catalog card or global search result | `test_name`, `lab_name`, `sample_type` |
| `lab_add_to_cart` | Add to cart succeeds | `af_content_type`=`Lab`, `test_name`, `lab_name`, `partner_name`, `sample_type`, `sampling_mode` |
| `lab_cart_viewed` | Cart screen opens | `af_content_type`=`Lab Cart` |
| `lab_checkout` | Checkout screen opens | `af_content_type`=`Lab Checkout` |
| `lab_patient_details_edit` | Patient details Edit tap | — |
| `lab_booking_confirmed` | Book succeeds or fails | `af_content_type`=`Lab`, `booking_id`, `user_name`, `msisdn`, `number_of_tests`, `lab_name`, `timestamp`, `payment_method`, `payment_status`, `promo_applied`, `promo` |

## Mocks

- When `MockConfig.enableLabTestMocks` is true, `LabTestMockApi` / `LabOrdersMockApi` return sample mobile API shapes (defaults to real API). Lab orders mock matches the nested `data.data[]` list (`Confirmed` / `Payment Pending`, no invoice).
