# Free doctor (Instant Doctor) feature

## Purpose

**Instant Doctor** — loads subscription/consultation info from the aggregator API and opens the consultation URL in an in-app web view.

## Routes / entry

- Bottom nav tab: `dashboardBottomFreeDoctor` → `FreeDoctorScreen` (via main navigation shell). **Login required** — guests are sent to `AppRoutes.authLogin` (bottom nav and home banner).

## Data & APIs

- `AppUrls.instantDoctorConsultation(msisdn)` — `GET /acs-aggregator/api/v1/mobile/doctor-consultation/instant?msisdn=...`
- Response `data`: `isSubscribed`, `bulletText[]`, `buttonText`, `redirectUrl`
- `msisdn` from logged-in user (`AppPref.getUserLocalModel().phone`, normalized via `PhoneFormatUtils.toMsisdn`)
- Mock when `MockConfig.enableMocks` is true (`FreeDoctorMockApi`).

## State

- `FreeDoctorCubit` — loads screen content; `openConsultationPage()` opens `redirectUrl` in `LaunchMode.inAppWebView`.

## DI

- `free_doctor_injection.dart` — data source, repository, use case, cubit factory (`AppPref` + `GetFreeDoctorContentUseCase`).

## Mocks

- `FreeDoctorMockApi` mirrors live instant consultation response shape when mocks enabled.
