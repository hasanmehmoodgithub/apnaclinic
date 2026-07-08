# Instant Doctor feature

## Purpose

**Instant Doctor** — loads multiple provider subscription plans from the aggregator API. Unsubscribed plans use OTP send/verify before opening consultation; subscribed plans open `redirectUrl` directly.

## Routes / entry

- Bottom nav tab: `dashboardBottomInstantDoctor` → `InstantDoctorScreen` (via main navigation shell). **Login required** — guests are sent to `AppRoutes.authLogin` (bottom nav and home banner).

## Data & APIs

- `AppUrls.instantDoctorConsultation(msisdn)` — `GET /acs-aggregator/api/v1/mobile/doctor-consultation/instant?msisdn=...`
- `AppUrls.instantDoctorSendOtp` — `POST …/doctor-consultation/instant/send-otp` — body: `msisdn`, `productId`, `uuid`
- `AppUrls.instantDoctorVerifyOtp` — `POST …/doctor-consultation/instant/verify-otp` — body: `msisdn`, `productId`, `otp`, `uuid`
- `AppUrls.instantDoctorCancelSubscription` — `POST …/doctor-consultation/instant/cancel-subscription` — body: `msisdn`, `productId`
- Response `data[]`: `providerId`, `providerName`, `logoUrl`, `isSubscribed`, `product` (`productId`, `productCode`, `productType`, `productTitle`, `priceDisplay`, `benefits[]`, `redirectUrl`)
- `msisdn` from logged-in user (`AppPref.getUserLocalModel().phone`, normalized via `PhoneFormatUtils.toMsisdn`)
- `uuid` generated per subscription attempt via `SubscriptionUuidUtils.generate()`
- Mock when `MockConfig.enableInstantDoctorMocks` is true (`InstantDoctorMockApi`).

## State

- `InstantDoctorCubit` — loads providers; subscription OTP flow; `cancelSubscription(provider)`; `openProviderPage` opens `product.redirectUrl` in `LaunchMode.inAppWebView`.
- `InstantDoctorScreen` — hero header, consultation title block, provider cards (subscribed ⋮ menu → cancel subscription), OTP bottom sheet, success/failure dialogs.

## DI

- `instant_doctor_injection.dart` — data source, repository, use cases, cubit factory (`AppPref` + content/OTP use cases).

## Mocks

- `InstantDoctorMockApi` mirrors live multi-provider + OTP responses when mocks enabled (verify accepts OTP `1234`).
