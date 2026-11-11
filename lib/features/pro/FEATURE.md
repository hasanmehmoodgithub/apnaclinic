# ApnaClinic Pro

## Purpose

Paid **ApnaClinic Pro** membership: show catalog (benefits + plans) in a bottom sheet and let the user pick a plan. Copy, images, benefits, and prices come from the API (mock until backend is live).

## Entry

- `showApnaClinicProSheet(context)` → returns `ProSheetResult?` (`planId`, selected `plan`).
- After a plan is confirmed, a static **Payment Method** sheet (`ProJazzCashPaymentMethodSheet`, JazzCash only) opens **over** the Pro sheet via `pushProNestedSheet` on a nested `Navigator` inside the Pro modal (not a second `showModalBottomSheet`, so Pro is never dismissed). Proceed opens accounts the same way. Dismissing either leaves Pro open. Subscribe / payment WebView run next; on success the Pro sheet closes and the success dialog shows on the page underneath.
- If login or logout happens while the sheet is open, details reload. An already-active member sees the manage view instead of the plan picker.
- Menu → **ApnaClinic Pro** tile opens the sheet.
- Home → `ApnaClinicProHomeBanner` (above Secure Your Health) opens the sheet.
- Also ready for checkout upsell / profile later.

## UI

- Catalog bottom sheet: logo/banner, title, tagline, benefits table, plan cards, CTA (all from API). Uses `useSafeArea: true` so the sheet top sits below the status bar / Dynamic Island; CTA includes bottom inset padding. Height caps at ~94%. Dragging the handle, or scrolling down once the content is at the top, follows the finger and eases the sheet closed (or springs it back). The modal's own drag is off because the nested navigator would swallow it. Subscribe / loading use full capped height; **active member** and error states shrink-wrap to content (no empty white footer). While details load, `ProSheetShimmerWidget` fills the sheet (banner, copy, benefits, plans, button).
- **Active Pro** (`membership.isPro` + `status` `active`/`cancelled`): manage view in a rounded card — ⋮ menu → Cancel Subscription confirm dialog; renew/expiry banner from `expiresAt` + `autoRenew`; Pro benefits list (pro values only). Sheet height matches header + card. Mock: `ProMockApi.mockAsActivePro`.
- Success dialog: `proUserLogo2.webp` header, Satoshi title (20 / medium) and subtitle (14 / regular, 150% line height). Home and menu (`showServiceActions: true`) show consultation, pharmacy, and lab. Other entry points, including checkout upsell, show Continue only. Consultation uses `docLogo.webp`. Order Pharmacy uses `pharmacyLogo.webp`. Book Lab uses `labLogo.png` (`pro_subscribe_success_dialog.dart`).
- `ProUserAvatar` (`lib/core/widgets/pro_user_avatar.dart`) — `imageUrl` + `isPro`; when Pro shows `leftLeave` / `right` laurels + `badgeCrown` under the circle.
- `ProShowInfoWidget` — upsell card (`title`, `subtitle`, `discount`). `ProServiceOfferSlot` shows it on pharmacy checkout, consultation checkout, and lab checkout when the user is not an active Pro member. Pharmacy checkout also puts `proBadge.svg` on **Delivery Charges** for active members and shows Free (delivery not added to total), even if the cart API still returns a delivery fee. Active members see a Discount row with the percent and `proBadge.svg` (`Assets.proProBadge`). On consultation checkout this sits just before payment methods. Copy prefers the matching catalog benefit (`consultation`, `lab`, `pharmacy`). Subscribe or cancel from that sheet reloads membership so the checkout discount, delivery badge, and upsell stay in sync. After a successful subscribe from **consultation** checkout, pops to `consultation-doctors` so the list refreshes Pro prices. From **lab** checkout, pops to `labTestSelectTest` (or `labTest` hub) for the same reason.

## Data & APIs

| Action | Method | `AppUrls` |
|--------|--------|-----------|
| Details | GET | `proDetails` → `/acs-aggregator/api/v1/mobile/pro/details` |

Response `{ success, message, data }` parsed by `ProDetailsModel`. `data`: `isActive`, `planCode`, `planName`, `status`, `renewsOn`, `bannerUrl` (nullable), `title`, `subtitle`, `priceOptions[]` (`code`, `title`, `durationLabel`, `durationDays`, `amount`, `currency`), `benefits[]` (`key`, `title`, `basic`, `pro`). Mapped onto the catalog entity: `isActive` → membership, `subtitle` → tagline, `priceOptions` → plans (`code` is the plan id), `renewsOn` → expiry. `bannerUrl: null` keeps the sheet header placeholder.

Subscribe: **POST** `proSubscribe` → `/acs-aggregator/api/v1/mobile/pro/subscribe`. Body: `planCode` (`PRO`), `planPriceCode` (selected `priceOptions.code`, e.g. `PRO_30D`), `msisdn` (JazzCash number chosen in the accounts sheet, sent as local `03…`), `channel` (`android` or `ios`). Confirming a plan opens static payment method (JazzCash → accounts) over the Pro sheet; subscribe runs after a number is chosen, before the payment WebView. Response `data`: `planCode`, `planPriceCode`, `publicId`, `status` (`PENDING_PAYMENT`), `paymentAttemptRef`, `link`, `message`. When `link` is an http(s) URL, `AppRoutes.proUserWebView` (`ProUserWebViewScreen`) opens it. Card checkout still uses `AppRoutes.cardPayment`. Close returns cancel. The page posts `AndroidInterface.postMessage` with `{ status: success|fail|pending, success, message, statusCode }`. `status` decides the result. The WebView stays open after the callback. A back-like in-page button (`Return to App`, close, cancel) or the app bar close leaves the WebView first. After it closes, a dialog always shows for the stored result: success uses the Pro success dialog (subtitle `proSubscribeSuccessMessage`) after the Pro sheet closes; fail, pending, and cancel use the payment outcome dialog (title for that status, callback `message` when present — example fail: “We could not confirm this transaction.”) and leave the Pro sheet open. Close with no callback is cancel.

Unsubscribe: **POST** `proUnsubscribe` → `/acs-aggregator/api/v1/mobile/pro/unsubscribe`. Body: `{ planCode }` (`PRO`, or the active membership `planCode`). Confirm dialog first. Success clears the lab cart, tells home and menu the member banner should go (`AuthSessionRefresh.notifyProMembershipChanged`), closes the sheet, and shows `showProUnsubscribeSuccessDialog` (`proUserLogo2.webp`, title `proUnsubscribeSuccessTitle`, message `proUnsubscribeSuccessMessage`, gray Okay). Home and menu reload details until membership is inactive (immediate clear, then up to 4 details reads). Failure keeps the sheet open and shows the error snackbar. A successful subscribe (payment confirmed, or subscribe with no payment link) also clears the lab cart and notifies home and menu to show the member banner.

## State

- `ProCubit` / `ProState` — load catalog, `selectedPlanId` (defaults to `isCurrent` then `isRecommended`), subscribe, and unsubscribe. `subscribeStateStatus` covers both subscribe and unsubscribe (only one is on screen). Home banner reads `membership` / `isCatalogLoading` via `BlocSelector` (no screen `setState`). `loadCatalog` / membership refresh write the confirmed membership into `ProMembershipCache` for the current auth epoch and Pro revision so Menu reuses Home’s details call and does not hit `pro/details` again. The optimistic inactive emit after unsubscribe is not cached.

## DI

- `pro_injection.dart` → `initProInjector()` from `dependency_injection.dart`. `ProMembershipCache` is a lazy singleton shared by `ProCubit` and the side menu.

## Mocks

- `ProMockApi` when `MockConfig.enableProMocks` is true (default **false**; live `pro/details` is used).
