# Instant Doctor feature

## Purpose

**Instant Doctor** — loads subscription/consultation info from the aggregator API and opens the consultation URL in an in-app web view.

## Routes / entry

- Bottom nav tab: `dashboardBottomInstantDoctor` → `InstantDoctorScreen` (via main navigation shell). **Login required** — guests are sent to `AppRoutes.authLogin` (bottom nav and home banner).

## Data & APIs

- `AppUrls.instantDoctorConsultation(msisdn)` — `GET /acs-aggregator/api/v1/mobile/doctor-consultation/instant?msisdn=...`
- Response `data`: `isSubscribed`, `bulletText[]`, `buttonText`, `redirectUrl`
- `msisdn` from logged-in user (`AppPref.getUserLocalModel().phone`, normalized via `PhoneFormatUtils.toMsisdn`)
- Mock when `MockConfig.enableMocks` is true (`InstantDoctorMockApi`).

## State

- `InstantDoctorCubit` — loads screen content; `openConsultationPage()` opens `redirectUrl` in `LaunchMode.inAppWebView`.
- `InstantDoctorScreen` — hero header, consultation info card, partner watermark (`Assets.imgPartner`) between card and CTA, subscribe button with shimmer while reloading.

## DI

- `instant_doctor_injection.dart` — data source, repository, use case, cubit factory (`AppPref` + `GetInstantDoctorContentUseCase`).

## Mocks

- `InstantDoctorMockApi` mirrors live instant consultation response shape when mocks enabled.
