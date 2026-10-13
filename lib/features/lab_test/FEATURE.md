# Lab test feature

## Purpose

Browse labs in a city, then tests for a selected lab, booking/cart flow, payment details checkout, and order view details.

## Routes / entry

- `AppRoutes.labTest` — city + **Select Lab** grid (`GET` labs).
- `AppRoutes.labTestSelectTest` — tests for the chosen lab (`GET` lab/tests?labId=). Extra: `LabTestSelectTestArgs` (`city`, `lab`, `requirementLines`).
- `AppRoutes.labTestBooking`, `labTestCart`, `labTestCheckout`, `labTestViewDetails`, `labTestReportViewer`.
- Tapping a lab or catalog test requires login (`AuthGuard.requireLogin`); guests are redirected to `AppRoutes.authLogin`.
- Opening cart (`labTestOpenCart`) also requires login; guests are redirected to `AppRoutes.authLogin`. Cart badge count is hidden for guests.

## UI

- Hub (`LabTestScreen`): city selector + lab logo grid (`LabTestBookingVendorGridWidget`). No cart icon. First visit without a saved city auto-opens the city sheet; after a city is chosen, labs load.
- Select Test (`LabTestSelectTestScreen`): selected-lab Change row, search, catalog tiles (no labs-summary line). Tiles show Sample Type + price on the first row and Requirement (**Fasting**) below when `fastingRequired` is true/`1`. Change pops back to the hub.
- Booking with a preferred lab hides partner tabs and the lab grid (lab already chosen). Partner “fulfilled by” banner (partner name **bold**), Walk In / Home Sample. When `fastingRequired` is true (`requirementLabel` set), a **Requirements** card (`LabTestBookingRequirementsCardWidget`) sits below the test summary — grey header with **Requirements** + green **Fasting** badge, white body with numbered `requirementLines`; hidden when fasting is not required. Summary card shows test title + **lab logo** (no lab name under the title), Sample Type + price only (no Requirement row). Home Sample is omitted when that lab/test has no home-sampling offer, with `labTestHomeSamplingUnavailable` copy. **Add Patient Details** shows **Self** until the pencil opens a bottom sheet (name, age, gender). Saved details go on the cart line and prefill checkout.
- Cart (`LabTestCartScreen`): `LabTestCartItemTileWidget.fromCartItem` cards — lab logo, test title, partner “Test fulfilled by” line, trash remove, divider, Sample Type + Requirement pills. Prices are not shown on cart tiles. CTA **Proceed to Checkout**.
- `LabTestPricePill` (catalog, booking) hides the strikethrough original price when it matches the discounted price.
- Checkout **Payment Details** (`LabTestCheckoutScreen`):
  - One test card per cart line — the **same** `LabTestCartItemTileWidget` as the cart, built from `LabTestCheckoutLineArgs` with `onRemove` omitted (no trash, no price).
  - `labTestCartToCheckoutArgs` sums original fees, discounts, and discounted totals across all cart lines for the breakdown.
  - Payment breakdown card (`LabTestCheckoutPaymentBreakdownCardWidget`): white card with title, **Fee**, shared **promo code** field (`PromoCodeCubit`, `service=LAB`, `amount` = original `price` (not `finalPrice`), `isPro` from membership; Book does not validate a typed code), **Promo Discount** when applied, yellow discount-code strip (`discountCode` non-empty only) with `labTestShowCodeInstruction`, then a grey **Total** bar flush to the card bottom (promo uses API `payableAmount`). Non-members see `ProServiceOfferSlot` above the card. Active Pro members see **Fee** as the original amount and a **Discount (percent)** row with `proBadge.svg` and the discount amount.
  - **Address** card (`LabTestCheckoutAddressCardWidget`) sits above Emergency Contact: radio **Use saved address from profile** (prefills `UserLocalModel.address`) vs **Use a different address** (clears the field), plus a multiline address input (required; empty turns red like emergency). Defaults to saved when profile has an address, otherwise different.
  - Emergency contact sits in its own white card (required; accepts 10-digit landline or 11-digit mobile). Empty or invalid number turns the input red (`clrFFF8F8` fill, `clrBA2025` border/text) together with the CTA error banner.
  - Patient details card is a **fallback only** (`showPatientDetails`): it renders when name / phone / age are not already complete from the Add Patient sheet or profile. **before Edit** = read-only rows with **Edit**; **after Edit** = form with **Done** (age digits only, max 3).
  - Required-fields / invalid-phone errors above the CTA use `LabTestCheckoutErrorBannerWidget` (light-pink background + info icon), not plain red text.
  - Bottom CTA has no separate white bar behind the button. Panel top radius `20`.
- On open, `LabTestCubit.bootstrap()` reads `AppPrefKeys.labTestSelectedCity`, loads cities, then calls **GET labs** when a saved city resolves to a `cityId`; first visit without a saved city auto-opens the city selection dialog (labs load after pick).
- Booking detail load shows the shared heart loader (`showHeartLoaderDialog`); failure renders the shared `EmptyBookingWidget` with the API message and a retry CTA.
- Selected city is persisted in `AppPrefKeys.labTestSelectedCity` and restored on every lab test visit until the user changes it.

## Data & APIs

- **Cities:** shared `CitiesRepository` + `showSelectCityDialog` (`lib/core/cities/`). Catalog load resolves `cityId` via `cityIdForName`.
- **Labs in a city:** `GET AppUrls.labs` → `/acs-aggregator/api/v1/mobile/labs?cityId=...`
  - Required: `cityId` (resolved from the selected city name).
  - Response `data[]`: `id`, `publicId`, `name`, `slug`, `logoUrl` (HTTP upgraded to HTTPS), `supportsHomeSampling`, `supportsWalkIn`, `homeSamplingFee`, `rating`, `estimatedReportHours`, `accreditationBadges`. Mapped to `LabTestVendorEntity` via `LabListMapper`. Tests catalog uses `id` as `labId`.
- **Lab tests catalog:** `GET AppUrls.labTests` → `/acs-aggregator/api/v1/mobile/lab/tests`
  - Required: `cityId`
  - Optional: `page` (default 1), `limit` (default 20, max 50), `search`, `labId` (**required on Select Test** so prices/offers are for the chosen lab)
  - Response: `data.items[]` with `testId`, `testName`, `sampleType`, `fastingRequired`, `turnaroundHours`, `description`, `labs[]` (pricing per lab/order type); pagination via `data.page`, `data.limit`, `data.total`, `data.totalPages`.
  - Browse list loads **page 1 / limit 20**, then `LabTestCubit.loadMoreCatalog()` appends the next page when the user scrolls near the bottom.
- **Lab test detail (booking):** `GET AppUrls.labTestDetail` → `/acs-aggregator/api/v1/mobile/lab/tests/{id}?cityId=...`
  - On test tap, app navigates to booking with `LabTestBookingArgs.pending` including `preferredLabId` from the hub selection; global search does the same using the first `labs[]` `labId`. `LabTestBookingCubit.loadDetailIfNeeded()` fetches detail and locks partner/lab to that id.
  - Response: `data.partners[]` each with `labs[]` and `pricing.HOME_SAMPLING` / `pricing.WALK_IN` (`price`, `discountPct`, `finalPrice`).
  - Lab `logoUrl` may be a full `http(s)` URL (e.g. `{host}/acs-media/apna-clinic/{id}.svg|.webp`) or a relative key (`apna-clinic/{id}.webp`). `LabTestMediaUrlResolver` upgrades HTTP→HTTPS (cleartext is blocked on iOS/Android), prefixes relative keys with `{apiBaseUrl}/acs-media/`, and ignores localhost. SVG/WebP/PNG render via `LabTestFigmaImage`. Partner `partnerLogoUrl` uses the same media rules, then bundled MedIQ/Oladoc assets if empty.
  - Booking screen filters partners/labs by booking method (`WALK_IN` / `HOME_SAMPLING`). On detail load, auto-selects the first available method (Walk In when both exist; Home Sample when only `HOME_SAMPLING` offers). Method tiles are disabled when that order type has no pricing. When the selected method has no offers, partner/lab grids are hidden, sample type shows **N/A**, and **Add to Cart** is disabled.
- **Book lab test:** `POST AppUrls.labBookTest` → `/acs-aggregator/api/v1/mobile/lab/book-test`
  - Triggered from **checkout** CTA after picking a payment method via `PaymentMethodSheet(module: labTesting)` → `GET payment-provider?module=lab-testing`. Response `data[]`: `code`, `title`, `subtitle`, `label` `{ text, color }`, `termsAndCondition` `{ title, description }`, `logo` (legacy string `label` / `termsAndCondition` still parsed). Rows use API `title` + `logo` (title left, vertically centered with the icon/radio). Loading uses `PaymentMethodOptionShimmerWidget`. Non-empty `label.text` shows a chip with `label.color` as background (yellow fallback). `subtitle` is the first line under the title (only when it differs from `title`). `termsAndCondition.title` is the second subtitle; the info icon opens `description` (`AppInfoDialog`, or browser when it is an http(s) URL). `COD` comes from the API. JazzCash prompts for an account msisdn; otherwise the patient phone is used.
  - While `POST lab/book-test` runs, shows the JazzCash verification bottom sheet ("Verification Required") when paying with JazzCash, or the shared heart loader for other payment methods; on failure shows shared `AlertDialogCard` with the API message only (no “Something went wrong” title; larger message text). Detail-load failure on the booking screen uses the same dialog, then pops.
  - Response may include `data.paymentUrl` → opens the **same** shared card payment WebView as pharmacy (`settleCardPaymentIfNeeded` → `AppRoutes.cardPayment` / `PaymentWebViewScreen`, with `allowClose: true` so the AppBar **X** can dismiss) before the booked success dialog. Cancel/fail shows a single `PaymentOutcomeDialogWidget` (CTA **View My Bookings**). Payment URL parsing mirrors pharmacy unwrap (`data` / nested `data.data`, plus `paymentUrl` / `payment_url` and common aliases). If `data.blockingOrder` is present, skip the WebView and show `PaymentPendingDialogWidget` (CTA **View My Bookings**; app copy, or `blockingOrder.message` when present). If `blockingOrder.canAbandon` is true, a secondary CTA calls `POST AppUrls.labBookTestAbandon` with `{ "order_id": publicId, "unified_order_id": 0 }` (`publicId` from `blockingOrder` then booking `data`). Cart is not cleared on a blocking order so the user can Proceed again after abandon. If `blockingOrder` is absent, the booking can proceed. Success / pending dialogs are non-cancelable (`barrierDismissible: false` + `PopScope(canPop: false)`); only the CTA dismisses them. After a successful booking or successful card payment, the local lab cart is cleared via `LabTestCartRepository`.
  - Body: `{ partnerId, labId, cityId, homeSample, paymentMethod, msisdn, patient: { name, age, gender, phoneNumber, address }, tests: [ { testId } ], optional promoCode }`.
  - `testId`s come from every cart line (supports multiple tests in one booking); `partnerId` / `labId` / `homeSample` come from the first cart line; `cityId` is resolved from the city name via `CitiesRepository`.
- **POST** `AppUrls.labBookTestAbandon` — `/api/v1/mobile/lab/book-test/abandon` JSON `{ "order_id": "<publicId>", "unified_order_id": 0 }` via `AbandonLabTestBookingUseCase`. Called from the pending-payment dialog when `blockingOrder.canAbandon` is true. After success, user stays on checkout and can pay again.
- **Lab orders (bookings list):** `GET AppUrls.labOrders` — envelope `{ success, message, data: { data[], page, limit, total } }`. Items use `orderId` (int), display `status` (`Confirmed` / `Payment Pending` / `Failed` / `Pending`), `orderType` (`WALK_IN` / `HOME_SAMPLING`), nested `lab` / `partner` / `patient` / `tests[]` / `pricing`, optional `promoCode`, **`totalFee`** (final payable; preferred over `pricing.total`), optional `reports[]` (no `invoice` / `publicId` on current API). Mapped through `LabOrderModel` → `LabOrderEntity` → bookings list. Lab logos use API `logoUrl` via `LabTestMediaUrlResolver` (HTTPS upgrade, relative `acs-media` keys, localhost ignored); missing logos show the shared placeholder — **no remapping to another lab’s bundled asset**.
- **Lab order detail:** `GET AppUrls.labOrderById(id)` → `/acs-aggregator/api/v1/mobile/lab-orders/{id}` via `GetLabOrderDetailUseCase` when opening View Details from bookings. Header title is **Details** (`labTestViewDetailsTitle`). Same order shape as list items (`data` is a single object). Result cards show lab name under the test title with `bookedCity` when present (e.g. `Chughtai Lab, Islamabad`); **Sample Type** with two pills — biological `sampleType` and booking method from `orderType` (`WALK_IN` → Walk In, `HOME_SAMPLING` → Home Sample); footer **Status** | **Fee**. A full-width **Download Report** button below the cards is enabled (teal `#0FAA9A`) when `data.reports[]` is non-empty (`reportStatus` `READY` / `AVAILABLE` shows the ready note); otherwise pill-shaped and disabled (`#EDEDED` bg, gray text) and not tappable. Tapping it downloads each PDF with Dio to app documents (`lab_reports/`) via `DownloadLabReportUseCase` (does **not** launch the remote URL). The heart loader is dismissed first, then the local file is shown on `LabTestReportViewerScreen` (`AppRoutes.labTestReportViewer`) with `flutter_pdfview` (floating Share / Download pills, bottom-right). Snackbar on fetch failure. **E-Invoice** (`BookingInvoiceTileWidget`) is omitted when order status is Failed; otherwise uses **GET** `AppUrls.mobileInvoice(LAB, orderId)` via shared `DownloadInvoiceUseCase` (numeric unified `orderId`, not `publicId`; same PDF viewer).
- Search runs when the user taps the search icon (or keyboard Search); no debounce. A cross icon appears while the field has text and clears the query (`submitSearch('')`). Empty results show `LabTestCatalogEmptyWidget` (“No Record Found” + empty box). Re-fetches from the API when a city is selected.

## State

- `LabTestCubit` — `bootstrap()` on create loads cities then `GET labs` when saved/selected city is set; `selectCity()` re-fetches labs; Select Test uses `autoBootstrap: false` + `startSelectTest()` then `GET lab/tests` with `labId`. `submitSearch()` / `loadMoreCatalog()` keep that `labId`.
- `LabTestBookingCubit` — cart + partner/vendor selection for a single test. When `preferredLabId` is set, partner tabs and lab grid are hidden and offers are scoped to that lab. Opening another test while the cart has items prefills the cart’s booking method and partner tab (and lab when offered on that test). If the test only has one partner and it differs from the cart partner, labs for that partner are hidden; tapping that partner shows the cart-clear warning so the user can clear the cart and continue (Add to Cart stays disabled until cart is cleared or partner can match). Patient details from the booking sheet are stored on the cubit and copied onto each cart line.
- Changing **city** (browse), **booking method**, **service provider**, or **lab** while the cart has items shows `LabTestCartChangeWarningDialogWidget` via `labTestGuardCartClearingChange`; Continue clears the cart (`LabTestCartRepository` + shared `LabTestCartCubit`), View Cart opens the cart without applying the change. A successful Pro subscribe or unsubscribe also clears the cart (`LabTestCartCubit.clearAfterProMembershipChange`). **Add to Cart** uses the same warning when the selected lab / partner / method differs from the cart (e.g. user went back to the listing and opened a test from another lab). Continue then adds the new selection. Listing / booking headers rebuild cart badge from the shared cubit on add/remove/clear.

## DI

- `lab_test_injection.dart` — data source, repository, use cases (`GetLabsUseCase`, catalog/detail/book/abandon/orders), cubit factory (`AppPref` + catalog/labs use cases), singleton `LabTestCartCubit`.

## Analytics

Firebase via `LabTestAnalytics` / `AnalyticsService`. BRD Lab Journey events are logged in addition to existing lab events (Meta/TikTok not wired). `lab_module` + `lab_module_opened` fire on the hub (`AppRoutes.labTest`); `source` is `home` / `search` / `bookings` from route extra (defaults to `home`). City restore on bootstrap does not fire `lab_city_change`; only a user pick in the city dialog does. Global search lab results fire `lab_item_select` + `lab_test_selected` (and `search_result_clicked`); they do not fire `lab_module` / `lab_module_opened` unless the hub opens. Not logged: `fb_content_type` / `content_type` (Firebase only), JazzCash `auth_code` (not on book-test response). `transaction_id` uses booking `publicId` when present. `promo` is the applied checkout promo code when present, otherwise cart `discountCode`. `lab_booking_confirmed` / `lab_test_booked` / AF `af_purchase_lab` fire only after successful book + payment (not on API fail, card fail, or pending). Cash checkout sends `payment_method`=`COD`. Lab booking details fire `booking_viewed` (`type=lab`) via `BookingsAnalytics`.

| Event | When | Params |
|---|---|---|
| `lab_module` | Lab hub opens | — |
| `lab_module_opened` | Lab hub opens (BRD) | `source` |
| `lab_city_change` | User picks a city | `selected_city` |
| `lab_search_clicked` | Search field or search icon tap | — |
| `lab_search_performed` | Non-empty catalog search | `keyword`, `result_items` |
| `lab_selected` | User taps a lab (BRD) | `lab_name` |
| `lab_item_select` | Catalog card or global search result | `test_name`, `lab_name`, `sample_type` |
| `lab_test_selected` | Same as item select (BRD) | `test_name` |
| `lab_add_to_cart` | Add to cart succeeds | `af_content_type`=`Lab`, `test_name`, `lab_name`, `partner_name`, `sample_type`, `sampling_mode` |
| `lab_cart_viewed` | Cart screen opens | `af_content_type`=`Lab Cart` |
| `lab_checkout` | Checkout screen opens (BRD) | `af_content_type`=`Lab Checkout` |
| `lab_patient_details_edit` | Patient details Edit tap | — |
| `lab_booking_confirmed` | Book + payment succeed | `af_content_type`=`Lab`, `booking_id`, `user_name`, `msisdn`, `number_of_tests`, `lab_name`, `timestamp`, `payment_method`, `payment_status`=`Successful`, `promo_applied`, `promo` |
| `lab_test_booked` | Same success path (BRD) | `booking_id`, `timestamp`, `user_name`, `msisdn`, `lab_name`, `test_name`, `test_id`, `sampling_mode`, `total_amount`, `discount`, `payment_method`, `payment_status`, `transaction_id` (when available) |

AppsFlyer (separate): `af_content_view` (`af_content_type`=`Lab`) on catalog/search test select; `af_add_to_cart` (`af_content_type`, `test_name`, `lab_name`, `partner_name`, `sample_type`, `sampling_mode`); `af_initiated_checkout` (`af_content_type`=`Lab Checkout`); `af_purchase_lab` on booking confirm (`content_type`/`af_content_type`=`Lab`, booking/user/lab/payment fields; `address` from checkout Address card; `partner` from cart line; `transaction_id` from `publicId`).

## Mocks

- When `MockConfig.enableLabTestMocks` is true, `LabTestMockApi` / `LabOrdersMockApi` return sample mobile API shapes (defaults to real API), including `getLabsSuccessResponse`. Lab orders mock matches the nested `data.data[]` list (`Confirmed` / `Payment Pending`, no invoice).
