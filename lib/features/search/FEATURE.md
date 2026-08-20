# Search feature

## Purpose

Global search for doctors, pharmacy, lab tests, surgery, and more. Supports text input and **voice search** via the microphone on the home header and search screen.

## UI

- Results show `Search for "{query}"` then section pills (Doctor Consultation / Laboratory Tests / Surgery Booking / Pharmacy). If every section is empty after submit, shows `SearchEmptyResultsWidget` (“No result found for "{query}"”).
- Doctor cards: match consultation list — avatar, name + rating badge, specialty/experience/education, partner logo, Fee + strikethrough, Book Now; soft shadow.
- Lab cards: same catalog tile as lab test browse (`LabTestBrowseItemTileWidget`) — grey title header, labs summary, Sample Type pill + price pill.
- Surgery cards: doctor header + specialty/credentials + partner logo; hospital/procedure + “Starting from”/old fee; shorter full-width Book Now.
- Pharmacy cards: product image, name, price (no card border).
- Search field: mic/clear + search icon inside the input (no separate search button).

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
- Listening uses `ListenMode.search`, up to **60s**, with **3s** pause before auto-stop. `error_no_match` / speech timeout restarts instead of ending the session. The first `finalResult` does not stop listening.
- While listening, the static mic is replaced by `voice_search_record.json` Lottie (field + centered listening view). Tap the animation to stop. Voice errors do not show a snackbar.

## DI

- `search_injection.dart` — `SearchCubit` + `SpeechToTextService` from core DI.

## Mocks

- `SearchMockApi.useMockResponses` follows `MockConfig.enableMocks`.
