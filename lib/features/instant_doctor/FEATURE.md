# Instant Doctor feature

## Purpose

**Instant Doctor** — loads multiple provider subscription plans from the aggregator API. Unsubscribed plans use OTP send/verify (`action: subscribe`) before opening consultation; subscribed plans open `redirectUrl` directly. Cancel subscription: confirm dialog → OTP sheet (`action: unsubscribe`, no provider card, **Unsubscribe** CTA) → verify → success snackbar.

## Routes / entry

- Bottom nav tab: `dashboardBottomInstantDoctor` → `InstantDoctorScreen` (via main navigation shell). **Login required** — guests are sent to `AppRoutes.authLogin` (bottom nav, home banner, and promo banner `bottomsheet/1` or `screen/instant-doctor`). The tab is not keep-alive; each visit remounts the screen and `InstantDoctorScreen` calls `loadContent(refresh: true)`.
- `AppRoutes.instantDoctorConsultation` — `InstantDoctorConsultationWebViewScreen`; extra: `InstantDoctorConsultationArgs` (`url`, `title`). Opens after OS camera + mic permission; WebView grants getUserMedia immediately (deny of OS permission → snackbar).

## Data & APIs

- `AppUrls.instantDoctorConsultation(msisdn)` — `GET /acs-aggregator/api/v1/mobile/doctor-consultation/instant?msisdn=...`
- Instant Doctor bookings list: **GET** `AppUrls.instantDoctorBookings(page, limit)` → `/acs-aggregator/api/v1/mobile/bookings?type=teleconsultation&page=1&limit=20` via `GetInstantDoctorBookingsUseCase`. Called when My Bookings is selected and the Instant Doctor inner tab becomes visible (including switching inner tabs or leaving/returning to Bookings). Response `data.data[]`: `orderId`, `status`, `createdAt`, `bookingAt`, `imageUrl`, `doctorName`, `specialty`, `fee`, `currency`, `partnerId`, `partnerName`, `partnerImageUrl`, `prescription` (newline-separated). Pagination: `page`, `limit`, `total`. Aggregator may omit `success`/`code`; `data` present is treated as success. List card omits the Fee column when `fee` is 0.
- `AppUrls.instantDoctorSendOtp` — `POST …/doctor-consultation/instant/send-otp` — body: `msisdn`, `productId`, `uuid`, `action` (`subscribe` | `unsubscribe`)
- `AppUrls.instantDoctorVerifyOtp` — `POST …/doctor-consultation/instant/verify-otp` — body: `msisdn`, `productId`, `otp`, `uuid`, `action` (`subscribe` | `unsubscribe`); success `data`: `resultCode`, `status`, `transactionId`, `description`, `redirectUrl`
- Response `data[]`: `providerId`, `providerName`, `logoUrl`, `isSubscribed`, `product` (`productId`, `productCode`, `productType`, `productTitle`, `priceDisplay`, `benefits[]`, `redirectUrl`)
- `msisdn` from logged-in user (`AppPref.getUserLocalModel().phone`, normalized via `PhoneFormatUtils.toMsisdn`)
- `uuid` generated per OTP flow via `SubscriptionUuidUtils.generate()`
- Mock when `MockConfig.enableInstantDoctorMocks` is true (`InstantDoctorMockApi`).

## State

- `InstantDoctorCubit` — loads providers; `loadContent(refresh: true)` is pull-to-refresh, bottom-tab revisit, and silent reload and shows the provider-list shimmer; `onProviderPrimaryTap` / `onCancelSubscriptionConfirmed` orchestrate subscribe/unsubscribe OTP; `verifyOtp` reloads content on success; `consultationUrl` returns provider `redirectUrl`.
- `InstantDoctorScreen` — layout and UI reactions (OTP sheet is not swipe/tap-outside dismissible; close via X; dialogs, snackbars); opens consultation via `AppRoutes.instantDoctorConsultation` web view screen; reloads providers when the Instant Doctor bottom tab is selected, when the web view closes, and after a successful unsubscribe. Provider list supports pull-to-refresh. Wrong OTP on **subscribe** keeps the OTP sheet open and shows the backend `message` under the pin field (does not open the generic failure dialog).
- Start Consultation CTAs include a phone icon. Provider cards and the OTP summary card show API `product.productTitle` under the provider name when present.
- Analytics: `instant_doctor_clicked` (`source` `banner` / `popup` / `navigation_tab`) and legacy `instant_doctor_module` (`source_screen` `banner` / `bottom_tab`) when entering the Instant Doctor tab; `instant_doc_subscribe_clicked` (`partner`) on Subscribe tap; `fb_mobile_subscribe` (`partner`, `msisdn`) on successful subscribe OTP; `start_consultation_clicked` (`partner`, `msisdn`) when consultation WebView opens.
- `InstantDoctorConsultationWebViewScreen` — requests OS camera + microphone **before** loading `redirectUrl`, then **immediately** `grant()`s WebView getUserMedia (waiting in that callback lets Android/iOS auto-deny). Android uses hybrid composition + a Chrome-like user agent. iOS: `PERMISSION_CAMERA` + `PERMISSION_MICROPHONE` in the Podfile, inline playback, PlayAndRecord audio session (`apna_clinic/media_session`), and `audio` background mode. Back (AppBar or system) shows exit confirm (`showInstantDoctorConsultationExitDialog`); Exit pops, Cancel stays.

## DI

- `instant_doctor_injection.dart` — data source, repository, use cases, cubit factory (`AppPref` + content/OTP use cases), `InstantDoctorBookingsCubit` factory.

## Mocks

- `InstantDoctorMockApi` mirrors live multi-provider + OTP responses when mocks enabled (verify accepts OTP `1234`). Bookings list mock returns one teleconsultation item matching the aggregator payload.
