# Instant Doctor feature

## Purpose

**Instant Doctor** — loads multiple provider subscription plans from the aggregator API. Unsubscribed plans use OTP send/verify (`action: subscribe`) before opening consultation; subscribed plans open `redirectUrl` directly. Cancel subscription: confirm dialog → OTP sheet (`action: unsubscribe`, no provider card, **Unsubscribe** CTA) → verify → success snackbar.

## Routes / entry

- Bottom nav tab: `dashboardBottomInstantDoctor` → `InstantDoctorScreen` (via main navigation shell). **Login required** — guests are sent to `AppRoutes.authLogin` (bottom nav, home banner, and promo banner `bottomsheet/1` or `screen/instant-doctor`). The tab is not keep-alive; each visit remounts the screen and `InstantDoctorScreen` calls `loadContent(refresh: true)`.
- `AppRoutes.instantDoctorConsultation` — `InstantDoctorConsultationWebViewScreen`; extra: `InstantDoctorConsultationArgs` (`url`, `title`). Opens after OS camera + mic permission; WebView grants getUserMedia immediately (deny of OS permission → snackbar).

## Data & APIs

- `AppUrls.instantDoctorConsultation(msisdn)` — `GET /acs-aggregator/api/v1/mobile/doctor-consultation/instant?msisdn=...`
- Instant Doctor bookings list: **GET** `AppUrls.instantDoctorBookings(page, limit)` → `/acs-aggregator/api/v1/mobile/bookings?type=teleconsultation&page=1&limit=20` via `GetInstantDoctorBookingsUseCase`. Called when My Bookings is selected and the Instant Doctor inner tab becomes visible (including switching inner tabs or leaving/returning to Bookings). Response `data.data[]`: `orderId`, `status`, `createdAt`, `bookingAt`, `imageUrl`, `doctorName`, `specialty`, `fee`, `currency`, `partnerId`, `partnerName`, `partnerImageUrl`, `prescription` (newline-separated), optional `prescriptionUrl`. Pagination: `page`, `limit`, `total`. Aggregator may omit `success`/`code`; `data` present is treated as success. List card omits the Fee column when `fee` is 0. **View Details** shows prescription text; a PDF row opens the in-app viewer only when `prescriptionUrl` is a non-empty `http(s)` URL (null/empty/missing hides it).
- `AppUrls.instantDoctorSendOtp` — `POST …/doctor-consultation/instant/send-otp` — body: `msisdn`, `productId`, `uuid`, `action` (`subscribe` | `unsubscribe`). Android auto-fill SMS body/hash is the same as Auth (`lib/features/auth/FEATURE.md`).
- `AppUrls.instantDoctorVerifyOtp` — `POST …/doctor-consultation/instant/verify-otp` — body: `msisdn`, `productId`, `otp`, `uuid`, `action` (`subscribe` | `unsubscribe`); success `data`: `resultCode`, `status`, `transactionId`, `description`, `redirectUrl`
- `AppUrls.instantDoctorSessionLog` — `POST …/doctor-consultation/instant/session-log` — body: `start_time`, `end_time` (ISO-8601 local), `providerName`, `instant_doc_log` (decoded page JSON from the `instant_doc_log` channel, or `""` when the page sent nothing). Called once when the consultation WebView exits. Failure is logged and does not block leaving the screen. Example when the page posts JSON:

```json
{
  "start_time": "2026-09-25T23:28:00.000",
  "end_time": "2026-09-25T23:35:12.000",
  "providerName": "BIMA",
  "instant_doc_log": {
    "event": "consultation_ended",
    "doctor_name": "Dr. Sara Khan",
    "specialty": "General Practitioner",
    "status": "completed",
    "prescription": "Panadol\nAzomax"
  }
}
```
- Response `data[]`: `providerId`, `providerName`, `logoUrl`, `isSubscribed`, `product` (`productId`, `productCode`, `productType`, `productTitle`, `priceDisplay`, `benefits[]`, `redirectUrl`)
- `msisdn` from logged-in user (`AppPref.getUserLocalModel().phone`, normalized via `PhoneFormatUtils.toMsisdn`)
- `uuid` generated per OTP flow via `SubscriptionUuidUtils.generate()`
- Mock when `MockConfig.enableInstantDoctorMocks` is true (`InstantDoctorMockApi`).

## State

- `InstantDoctorCubit` — loads providers; `loadContent(refresh: true)` is pull-to-refresh / bottom-tab revisit and shows the provider-list shimmer; `loadContent(silent: true)` refreshes providers without shimmer; after subscribe OTP success, `refreshProvidersAfterSubscriptionChange` reloads providers immediately and retries until that provider's `isSubscribed` is true; after unsubscribe OTP success the list shimmer starts immediately, the providers request is sent after 3s, and retries continue until `isSubscribed` is false; `onProviderPrimaryTap` / `onCancelSubscriptionConfirmed` orchestrate subscribe/unsubscribe OTP; `consultationUrl` returns provider `redirectUrl`.
- `InstantDoctorScreen` — layout and UI reactions (OTP sheet is not swipe/tap-outside dismissible; close via X; dialogs, snackbars); **Subscribe** shows a non-dismissible heart loader overlay until send-OTP returns so other CTAs cannot be tapped; then OTP sheet or error snackbar. After successful subscribe OTP, shows the success dialog with **Start Consultation** / **Close** disabled until the provider refresh completes (shimmer behind the dialog). The providers API is called again, up to 3 times, until that plan's `isSubscribed` is true. After successful unsubscribe OTP, shows a success snackbar and the list shimmer immediately; the providers API is called after 3s and retried until `isSubscribed` is false. Opens consultation via `AppRoutes.instantDoctorConsultation` web view screen; reloads providers when the Instant Doctor bottom tab is selected and when the web view closes. Provider list supports pull-to-refresh. Wrong OTP on **subscribe** keeps the OTP sheet open and shows the backend `message` under the pin field (does not open the generic failure dialog).
- Start Consultation CTAs include a phone icon. Provider cards and the OTP summary card show API `product.productTitle` under the provider name when present. When `product.priceDisplay` is `Free with Pro`, the subscribed-card ⋮ cancel menu is hidden.
- Analytics: `instant_doctor_clicked` (`source` `banner` / `popup` / `navigation_tab`) and legacy `instant_doctor_module` (`source_screen` `banner` / `bottom_tab`) when entering the Instant Doctor tab; `instant_doc_subscribe_clicked` (`partner`) on Subscribe tap; `fb_mobile_subscribe` (`partner`, `msisdn`) on successful subscribe OTP; `start_consultation_clicked` (`partner`, `msisdn`) when consultation WebView opens. My Bookings Instant Doctor: `instant_doc_booking_opened` (`booking_id`) when View Details opens; `instant_doc_prescription_view` (`booking_id`) when prescription text/PDF is present; `instant_doc_prescription_download` (`booking_id`, `user_name`, `msisdn`) on PDF download.
- AppsFlyer (separate from Firebase): `instant_doctor_module` (`source_screen`, `partner`) on tab entry (`partner` empty until a provider is chosen); `af_purchase` (`source_screen`, `partner`) on successful subscribe OTP.
- `InstantDoctorConsultationWebViewScreen` — `tel:`, `mailto:`, and `sms:` links are opened with the system dialer/mail app (`NavigationDecision.prevent`) so the WebView does not navigate to them and show `ERR_UNKNOWN_URL_SCHEME`. Requests OS camera + microphone **before** loading `redirectUrl`, then **immediately** `grant()`s WebView getUserMedia (waiting in that callback lets Android/iOS auto-deny). Android uses hybrid composition + a Chrome-like user agent, and `setOnShowFileSelector` so Instant Doctor `<input type="file">` opens gallery/camera/file pickers (`image_picker` / `file_picker`, no broad storage permission). iOS WKWebView handles file inputs natively (`NSPhotoLibraryUsageDescription` + camera/mic strings). iOS: `PERMISSION_CAMERA` + `PERMISSION_MICROPHONE` in the Podfile, inline playback, PlayAndRecord audio session (`apna_clinic/media_session`), and `audio` background mode. Back (AppBar or system) shows exit confirm (`showInstantDoctorConsultationExitDialog`); Exit pops, Cancel stays. On open, records `start_time`. JavaScript channel `instant_doc_log` stores the latest page message. On confirmed exit, records `end_time` and posts `LogInstantDoctorSessionUseCase` once (`start_time`, `end_time`, `instant_doc_log` or `""`).

## DI

- `instant_doctor_injection.dart` — data source, repository, use cases (including `LogInstantDoctorSessionUseCase`), cubit factory (`AppPref` + content/OTP use cases), `InstantDoctorBookingsCubit` factory.

## Mocks

- `InstantDoctorMockApi` mirrors live multi-provider + OTP responses when mocks enabled (verify accepts OTP `1234`). Bookings list mock returns one teleconsultation item matching the aggregator payload. Session log mock returns success.
