# Free doctor (Instant Doctor) feature

## Purpose

Promotional screen for **Instant Doctor** — 24/7 M-Health doctor consultation. User taps **Subscribe Now!** to open the Jazz M-Health sign-in page in the browser.

## Routes / entry

- Bottom nav tab: `dashboardBottomFreeDoctor` → `FreeDoctorScreen` (via main navigation shell).

## Data & APIs

- `AppUrls.freeDoctor` — CMS content (title, bullet points); mock when `MockConfig.enableMocks` is true.
- Subscribe CTA URL (hardcoded): `FreeDoctorConstants.mHealthSubscribeUrl` → Jazz BIMAMHealth sign-in.

## State

- `FreeDoctorCubit` — loads screen content; `openSubscribePage()` opens Jazz subscribe URL in an in-app web view (`LaunchMode.inAppWebView`).

## DI

- `free_doctor_injection.dart` — data source, repository, use case, cubit factory.

## Mocks

- `FreeDoctorMockApi` when mocks enabled; copy matches Instant Doctor / M-Health messaging.
