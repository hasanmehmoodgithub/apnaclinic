# Search feature

## Purpose

Global search for doctors, pharmacy, lab tests, surgery, and more. Supports text input and **voice search** via the microphone on the home header and search screen.

## Routes / entry

- `AppRoutes.search` — `SearchScreen` with optional `SearchLaunchArgs` (`initialQuery`, `startVoiceSearch`).

## Data & APIs

- Search content via `SearchRemoteDataSourceImpl` / `SearchMockApi` when mocks enabled.

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
