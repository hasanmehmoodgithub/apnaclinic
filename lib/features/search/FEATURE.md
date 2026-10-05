# Search feature

## Purpose

Global search for doctors, pharmacy, lab tests, surgery, and more. Supports text input and **voice search** via the microphone on the home header and search screen.

## UI

- Results show `Search for "{query}"` then section pills (Doctor Consultation / Laboratory Tests / Surgery Booking / Pharmacy). If every section is empty after submit, shows `SearchEmptyResultsWidget` (“No result found for "{query}"”).
- Doctor cards: match consultation list — avatar, name + rating badge, specialty/experience/education, partner logo, Fee + strikethrough, Book Now; soft shadow.
- Lab cards: same catalog tile as Select Test (`LabTestBrowseItemTileWidget`, no labs-summary line, compact text). Fasting shows the Requirement pill when `fastingRequired` is true.
- Surgery cards: doctor header + specialty/credentials + partner logo; hospital/procedure + “Starting from”/old fee; shorter full-width Book Now.
- Pharmacy cards: product image, name, price (no card border).
- Search field: mic/clear + search icon inside the input (no separate search button). Allows punctuation/symbols; emoji are still blocked. Max **100** characters (`SearchUiConfig.queryMaxLength`; counter hidden). Voice transcripts and submit are truncated to the same cap.

## Routes / entry

- `AppRoutes.search` — `SearchScreen` with optional `SearchLaunchArgs` (`initialQuery`, `startVoiceSearch`).
- Result taps: pharmacy → `AppRoutes.pharmacy`; doctor → `AppRoutes.consultationBookDoctor` (login); lab → `AppRoutes.labTestBooking` with `preferredLabId` from the first `labs[]` entry (login). City comes from that lab, else the saved lab city. If neither exists, the Select City dialog opens first and the chosen city is saved, then the specific test opens. Surgery offer → `AppRoutes.surgeryPatientDetails` (login).

## Data & APIs

- **GET** `AppUrls.mobileSearchPopular` → `/acs-aggregator/api/v1/mobile/search/popular`. Called on initial / cleared state to populate popular chips (`data[]` string list).
- **GET** `AppUrls.mobileSearch(text:, limit:)` → `/acs-aggregator/api/v1/mobile/search?text=&limit=` (default `limit=5`). Called **only on submit** (search icon / keyboard submit / recent·popular·suggestion tap / voice final). Typing does not hit the network.
- Response `data`: `doctorConsultation[]` (fee applies `discountPercent`; `yearsOfExperience` / `education` / `bio` mapped separately), `labTests[]` (first `labs[]` entry: `labId`, `labName`, `logoUrl`, city, price; `fastingRequired` maps to the Requirement pill), `surgeryBooking[]` (doctor/package offers with `surgeryId` / `doctorId` / `cityId` / prices / hospital / partner; experience and education mapped separately), `pharmacy[]` (Partner product fields). Mapped into search sections.
- Doctor Book Now → `ResultsDoctorItem` with `experience`, `qualification`, and `description` (bio). Surgery Book Now → `SurgeryPatientDetailsArgs` with `experience` and `qualifications`. Search cards show experience/education only (not bio).

## State

- `SearchCubit` — query, suggestions, results, `isListening` for voice input.
- Analytics: `search_screen` on open; `search_performed` (`keyword`, `medium` Type/Voice/Recent/Popular) on submit; `search_result_clicked` (`type` medicine_name/doctor/lab/surgery_doctor) on result tap.
- `RecentSearchesStore` — local recent terms (`SharedPreferences`), newest first, max **5**.

## Voice search

- `SpeechToTextService` wraps `speech_to_text` (mic permission is requested by the plugin on initialize).
- Mic tap on home opens search with `startVoiceSearch: true`; search screen mic toggles listen/stop.
- Listening uses `ListenMode.search`, up to **60s**, with **3s** pause before auto-stop. Silence (`error_no_match` / `error_speech_timeout`) **ends** the session; empty transcript does not submit a search. Do not call `listen()` again from those callbacks (Android SpeechRecognizer crash). `error_busy` is ignored. The first `finalResult` does not stop listening.
- While listening, the static mic is replaced by `voice_search_record.json` Lottie (field + centered listening view). Tap the animation to stop. Voice errors do not show a snackbar.

## DI

- `search_injection.dart` — `SearchCubit` + `SpeechToTextService` from core DI.

## Mocks

- `SearchMockApi.useMockResponses` follows `MockConfig.enableMocks`.
