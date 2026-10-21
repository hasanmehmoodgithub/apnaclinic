# Apna Clinic AI

## Purpose

Care Companion: guest health assistant with a home (greeting, concerns, capability tiles, SOS, composer) and chat (streamed reply, doctor/medicine cards, slot calendar, payment chips). Critical symptoms show Rescue 1122. Separate from consultation AI screening (`AppRoutes.aiScreening` WebView).

## UI

Care Companion flow from the demo, themed with Apna Clinic tokens via `ApnaClinicAiUiConfig`: calm mint page gradient, CTA `clr0FAA9A` / deep `clr00897B`, hairline borders, soft card shadows, clinical headers (teal avatar / health badge). White rounded panel (`AppScaffoldGradient` + `AppScaffoldGradientPanel`).

## Routes / entry

- `AppRoutes.apnaClinicAi` — home, then chat. Opened from the dashboard menu (**Apna Clinic AI**) and the home-screen floating **Apna Clinic Bot**. No login required.
- Concern chips, home tiles, doctor/medicine cards, slots, and payment taps send another chat message. They do not open native booking.

## Data & APIs

Dedicated `ApnaClinicAiSdkClient` (own Dio). Do not use `ApiService` (clinic JWT / HMAC).

**Session:** guest vs signed-in from `AuthGuard.isLoggedIn` — see `SESSION_INIT.md`. Tokens live in `AppPref` (`apnaClinicAi*`); cleared on logout. Signed-in clinic JWT is sent as `X-User-Token` on SDK calls. **`conversation_id`:** new window stashes the prior id — **Continue / Resume** restores it; any other first action (or New chat) starts a new id; then stable for that window.

**Temporary:** base URL + SDK key are hardcoded as `fromEnvironment` defaults in `ApnaClinicAiConfig` for local/dev. Move them out before production.

Optional override:

```bash
# copy apna_clinic_ai.keys.json.example → apna_clinic_ai.keys.json (gitignored)
flutter run --dart-define-from-file=apna_clinic_ai.keys.json
```

Keys:

- `APNA_CLINIC_AI_BASE_URL`
- `APNA_CLINIC_AI_SDK_KEY`

| Call | Path |
|---|---|
| Ping | `GET /api/v1/sdk/ping` with `X-SDK-Key` |
| Session | `POST /api/v1/sdk/session/init` guest `{ mode, device_id, name }`, then `{ msisdn, name }` |
| Token | `POST /api/v1/sdk/auth/token` `{ api_key }`, refreshed ~30s before expiry |
| Branding / home | `GET /api/v1/sdk/app`, `GET /api/v1/sdk/home` (welcome, suggestions, tiles, voice) |
| Text (speak off) | `POST /api/v1/sdk/assistant/turn/stream` SSE |
| Text (speak on) | `POST /api/v1/sdk/assistant/turn` JSON with `speak: true` |
| Audio playback | `audio.base64` from the JSON turn, played with `just_audio` (wav / mp3 / ogg / m4a from type or file header). Stops if the user talks or sends another message. |

SSE: `token` / `delta`, `stage`, `final` / `done`, `error`. Cards from `blocks` and reply text. Doctor/medicine cards use `image` / `imageUrl` / `photo` / `avatar` via `CachedNetworkImage`. Slot days group into a calendar UI from `blocks.chips` / `option_items` / reply bullets (`YYYY-MM-DD · time`); day chips show calendar day + month (e.g. `21` / `OCT`), not the year prefix. When a slot calendar is shown, doctor cards and ISO slot bullets in the reply are suppressed so the UI is not duplicated.

Device id and last complaint (continue card) are in `SharedPreferences`.

## State

`ApnaClinicAiCubit`: connect (welcome, tiles, voice, guest), send text, tap-to-talk via `SpeechToTextService` (dictation, EN / اردو). اردو forces `ur_PK` and rewrites Roman Urdu into native script before send. Live caption, pause auto-sends. Spoken questions request `speak: true` even when the speak-replies setting is off. Playback uses `just_audio` and stops when a new turn or the mic starts. Emits `doctors`, `slotDays` / `slots`, `payments`, `quickActions`. Emergency phrases use `ApnaClinicAiEmergency`.

## DI

`apna_clinic_ai_injection.dart` — `initApnaClinicAiInjector()` from `initDependencyInjection()`. Cubit is a factory; SDK client and repository are singletons.

## Mocks

None. Missing dart-defines surface `ApnaClinicAiFailureCodes.notConfigured`.
