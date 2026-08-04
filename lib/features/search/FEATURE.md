# Search feature

## Purpose

Global search for doctors, pharmacy, lab tests, surgery, and more. Supports text input and **voice search** via the microphone on the home header and search screen.

## UI

- Results show `Search for "{query}"` then section pills (Doctor Consultation / Laboratory Tests / Surgery Booking / Pharmacy).
- Doctor cards: avatar, credentials/experience/hospital, partner logo (top-right), strikethrough `oldFee` + fee, teal Book Now.
- Lab cards: title, lab location, sample type, strikethrough + teal price pill.
- Surgery cards: doctor image, name, hospital, package, partner logo + “Starting from” fee, full-width Book Now.
- Pharmacy cards: product image, name, price.

## Routes / entry

- `AppRoutes.search` — `SearchScreen` with optional `SearchLaunchArgs` (`initialQuery`, `startVoiceSearch`).
- Result taps: pharmacy → `AppRoutes.pharmacy`; doctor → `AppRoutes.consultationBookDoctor` (login); lab → `AppRoutes.labTestBooking` (login + saved city, else lab hub); surgery offer → `AppRoutes.surgeryPatientDetails` (login).

## Data & APIs

- **GET** `AppUrls.mobileSearchPopular` → `/acs-aggregator/api/v1/mobile/search/popular`. Called on initial / cleared state to populate popular chips (`data[]` string list).
- **GET** `AppUrls.mobileSearch(text:, limit:)` → `/acs-aggregator/api/v1/mobile/search?text=&limit=` (default `limit=5`). Called **only on submit** (search icon / keyboard submit / recent·popular·suggestion tap / voice final). Typing does not hit the network.
- Response `data`: `doctorConsultation[]` (fee applies `discountPercent`), `labTests[]` (first `labs[]` entry only), `surgeryBooking[]` (doctor/package offers with `surgeryId` / `doctorId` / `cityId` / prices / hospital / partner), `pharmacy[]` (Partner product fields). Mapped into search sections.

## State

- `SearchCubit` — query, suggestions, results, `isListening` for voice input.
- `RecentSearchesStore` — local recent terms (`SharedPreferences`).

## Voice search

- `SpeechToTextService` wraps `speech_to_text` (mic permission is requested by the plugin on initialize).
- Mic tap on home opens search with `startVoiceSearch: true`; search screen mic toggles listen/stop.
- Final transcript auto-submits search; errors surface as snackbars (`searchVoice*` l10n keys).

## DI

- `search_injection.dart` — `SearchCubit` + `SpeechToTextService` from core DI.

## Mocks

- `SearchMockApi.useMockResponses` follows `MockConfig.enableMocks`.
