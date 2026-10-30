# Apna Clinic AI

**Full HTML guide (screens, API flow, SSE, voice):** open [`APNA_CLINIC_AI_GUIDE.html`](APNA_CLINIC_AI_GUIDE.html) in a browser.

**Integrate into another app:** copy the prompt in [`INTEGRATION_PROMPT.md`](INTEGRATION_PROMPT.md) (init / home / SDK / APIs / text+voice flow).

## Purpose

Care Companion chat (no separate AI home). The chat header title is **Noor (Apna Clinic AI)** (`apnaClinicAiTitle`). `apnaClinicAiBrandName` rewrites API names like “ApnaClinic Assistant” and “Noor” to **Apna Clinic Ai Noor** in other copy. On first connect, the session/init `greeting` is the first assistant bubble (SDK text, not rewritten) and its `audio.base64` plays once. Header and assistant bubbles use the teal-circle chatbot badge (`ApnaClinicAiBotLottie`, `AppColors.clr00A08F`; pale sparkle on the home size). Header status is **Online** when idle, **Getting ready…** while connecting or waiting on a reply, **Listening…** while recording, and the live stage label when one is known. First connect shows a compact greeting shimmer (height 120) in the chat area only; the composer pill is visible but disabled until connect finishes. the info button opens a cream medical-disclaimer card (gold border, warning icon, no alert button); refresh starts a new chat. Starter chips **Find a doctor...** (stethoscope) and **Find medicines...** (capsule) sit left-aligned above the composer until the user sends a message, followed by any extra `/sdk/app` suggestions. Composer hint is “Ask me anything...”. Connect failure on an empty thread shows **Retry** (`connect(forceRefresh: true)`). Critical symptoms still surface Rescue 1122 in chat. Separate from consultation AI screening (`AppRoutes.aiScreening` WebView). The app still opens on the dashboard.

## UI

Care Companion flow from the demo, themed with Apna Clinic tokens via `ApnaClinicAiUiConfig`: calm mint page gradient, CTA `clr0FAA9A` / deep `clr00897B`, hairline borders, soft card shadows, clinical headers (teal avatar / health badge). White panel (`AppScaffoldGradient` + `AppScaffoldGradientPanel` with square top corners). Chat composer is a teal pill (`apnaClinicAiChatComposerHint`: “Ask me anything...”) with a pale mic circle and a solid send circle. Tapping the chat composer scrolls the thread to the latest message (again after the keyboard opens).

**Presentation layout:** thin screen (`ApnaClinicAiScreen`) + feature widgets under `presentation/widgets/` (`home_hero_card`, `home_disclaimer`, `home_error_body`, `concern_chip`, `chat_header`, composer docks). Views read `ApnaClinicAiCubit` via `BlocBuilder` / `BlocSelector` (scoped rebuilds). Slot day selection is cubit state (`selectedSlotDayIndex` / `selectSlotDay`). Local `StatefulWidget` only for text/scroll/focus controllers and animation tickers — not business state.

## Routes / entry

- `AppRoutes.apnaClinicAi` — chat only. Opened from the home-screen floating **Apna Clinic Bot** and consultation **Start now!** when home `data.aiEnabled` is true. No login required. Back returns to the dashboard. Refresh starts a new chat and shows the SDK greeting again (audio stays once per open).
- Concern chips, home tiles, doctor/medicine cards, slots, and payment taps send another chat message. They do not open native booking. Exceptions: pharmacy `payment_handoff` (`apnaclinic://pharmacy/cart?step=checkout…`) → `pharmacyOpenCart`; consultation `payment_handoff` (`apnaclinic://doctor/{id}?step=checkout&date=&start=&end=`, `BOOK_CONSULTATION`) → doctor book screen with slot prefill via `consultationOpenBookFromDeepLink`, then hydrates missing doctor fields from **`GET …/web/doctor-consultation/doctor/{id}`** (AI-only; browse does not call it). **View cart** after `ADD_TO_CART` stays a chat chip.

## Data & APIs

Dedicated `ApnaClinicAiSdkClient` (own Dio). Do not use `ApiService` (clinic JWT / HMAC). Adds `ChuckerDioInterceptor` when `ChuckerGuard.isEnabled`.

**Session:** guest vs signed-in from `AuthGuard.isLoggedIn` — see `SESSION_INIT.md`. Tokens live in `AppPref` (`apnaClinicAi*`); cleared on logout. Signed-in clinic JWT is sent as `X-User-Token` on SDK calls. **`POST /sdk/session/init`:** once per cold app start, after logout, or on login/mode change — not every time Care Companion opens (then only token refresh). **`conversation_id`:** Every home start (common concerns, home text, **home voice**) clears the prior chat UI and mints a new id when the turn starts. Cancelled home voice / back from chat → AI home with an empty detached thread. Close / back from AI home leaves the feature. In-chat turns keep the bound id. Continue / resume last complaint uses `AppPref.apnaClinicAiHistoryConversationId` (written after a turn is sent). Composer hint comes from `/sdk/app` theme placeholder.

**Config:** `ApnaClinicAiConfig.fromEnvironment()` reads (in order) `AI_BASE_URL` / `AI_SDK_KEY` / `AI_TENANT` (`apnaclinic`), then `APNA_CLINIC_AI_*`. Temporary defaults exist for local/dev — move them out before production. Non-production / debug builds show a **tune** control on the chat header that opens a testing dialog to override base URL + SDK key at runtime (persisted in SharedPreferences; Apply clears the SDK session and reconnects; Reset restores dart-define defaults).

Optional override:

```bash
# copy apna_clinic_ai.keys.json.example → apna_clinic_ai.keys.json (gitignored)
flutter run --dart-define-from-file=apna_clinic_ai.keys.json
# or:
flutter run --dart-define=AI_BASE_URL=https://jazzred-msa-stg.jazz.com.pk/ai-services/jimi --dart-define=AI_SDK_KEY=sdk_…
```

| Call | Path |
|---|---|
| Session | `POST /api/v1/sdk/session/init` guest `{ mode, device_id }`, signed_in `{ msisdn, name, email }`. Response may include `greeting` + `audio.base64` → first chat bubble + auto-play **once** per screen open (not again on new chat or reconnect). Full init JSON kept in app-support file (not cleared with session); the chat reads greeting/audio from that cache when present |
| Token | `POST /api/v1/sdk/auth/token` `{ api_key }`, refreshed ~30s before expiry |
| Branding | `GET /api/v1/sdk/app` (assistant name, welcome, theme subtitle / placeholder, suggestions, voice flags) |
| Text | `POST /api/v1/sdk/assistant/turn/stream` SSE. `speak: true` when `voice.output.enabled`. The stream stays open after `final` so delayed `type: audio` attaches the same way as a voice turn. |
| **Audio stream** | `POST /api/v1/sdk/assistant/turn/audio/stream` multipart + SSE (`channel=voice`, `speak=true`) |
| Speak / STT status | `GET /api/v1/sdk/voice/speak/status`, `GET /api/v1/sdk/voice/transcribe/status` |
| Audio playback | `audio.base64` from session/init greeting and from turns, played with `ApnaClinicAiAudioPlayerService` (`just_audio`). **Home:** centered speaking-wave panel + typewriter greeting; dismisses when the clip completes. **Chat:** compact speaking bar — also **hides when playback completes** (completed / near-end / end latched if the player seeks to 0). Stops if the user talks or sends another message. |

### Voice / audio stream

1. Mic tap starts `ApnaClinicAiAudioRecorderService` (WAV 16 kHz mono preferred, else AAC/M4A). Local speech-to-text stays off during capture. Voice notes auto-send at **30s** max.
2. On stop: ignore clips under **1s** or **8 KB**. Local speech-to-text does not run during capture (it steals the mic and the WAV stays a few KB). Detect RIFF → `speech.wav` / else `speech.m4a`.
3. Multipart fields: `api_key`, `session_id`, `conversation_id`, `channel=voice`, `language`, `speak`, `client_turn_id`, `audio`.
4. Headers: `Accept: text/event-stream`, `X-SDK-Key`, optional `Authorization` / `X-User-Token` (no manual multipart Content-Type).
5. SSE: `stage`, `chunk`/`token`/`delta`, `final` (may include `audio_pending: true` + reply/chips with `audio: null` + `turn_id`), then delayed `type: audio` with matching `turn_id` + `audio.base64`; `error`. Transcription updates the user bubble. Only `type: final` / `type: done` finalize the turn — raw `done: true` on audio events must not clear the reply. Cubit also refuses to overwrite a non-empty reply/chips/clip with a later empty final or stream failure after delayed audio. On `final`, show reply/chips immediately (no local TTS, no autoplay); if `audio_pending` on a text or voice turn, show a 3-dot wave loader on the audio control until delayed audio arrives. When delayed audio arrives, attach by `turn_id` and swap loading → Play. Text streaming shows a shimmer in the waiting bubble, with **Getting ready…** (or the live stage) in the header.
6. **Fallbacks:** 403 → retry up to 2× (600ms); 400 / no-speech → graceful reply; 502 / timeout → text stream with local STT `fallbackMessage` when available.

SSE: `token` / `delta` / `chunk`, `stage`, `final` / `done`, delayed `audio` (matched by `turn_id`), `error`. Cards from `blocks` and reply text. Section headings come from each block's `title` (`kind: cards` → payment/doctor/medicine, `kind: chips` → chip row or slot calendar). Non-slot chips such as Cancel stay under that title. When `audio_pending` is true, cubit keeps reply/chips and shows Play only after `StreamAudio` attaches the clip for that `turn_id` (no autoplay, no on-device TTS for text or voice turns). Doctor/medicine cards use `image` / `imageUrl` / `photo` / `avatar` via `CachedNetworkImage`. The card footer shows experience and price once each (`3 yrs • PKR 1000`). Payment methods from `blocks.cards` (`kind: payment`) render once as a vertical list (cover image, badge, subtitle), not again as a second Payment list. A `payment_handoff` with an HTTP `paymentLink` / `payment_url` / `url` adds **Pay now**, which opens that URL in the card payment web view (`allowClose`). An `apnaclinic://pharmacy/cart?step=checkout…` handoff (e.g. `intent: PHARMACY_CHECKOUT`) shows **Pharmacy checkout** and opens `AppRoutes.pharmacyCart`. An `apnaclinic://doctor/{id}?step=checkout&date=&start=&end=` handoff (`BOOK_CONSULTATION`) opens `AppRoutes.consultationBookDoctor` with that doctor + slot prefill. The same HTTP link in the reply (`[Pay now](url)`) is tappable and does not show the raw URL. Other card images use `BoxFit.cover`. Slot days group into a calendar UI from `blocks.chips` / `option_items` / reply bullets (`YYYY-MM-DD · time`); day chips show calendar day + month (e.g. `21` / `OCT`), not the year prefix. When a slot calendar is shown, doctor cards and ISO slot bullets in the reply are suppressed so the UI is not duplicated.

Device id and last complaint (continue card) are in `SharedPreferences`.

## Analytics

Separate keys: `lib/core/analytics/apna_clinic_ai_analytics_event_keys.dart` (not `ai_chat_*` screening). Helper: `ApnaClinicAiAnalytics`. Events: `apna_clinic_ai_opened` / `_closed` (param `source`: `home_fab` / …, `guest`), `apna_clinic_ai_message_sent` / `_received` (`channel` text|voice, optional `intent` / `turn_id` / `conversation_id`), `apna_clinic_ai_voice_started` / `_sent` / `_cancelled`.

## State

`ApnaClinicAiCubit`: connect (welcome, tiles, voice, guest), send text, tap-to-talk via **audio stream** (local STT is not started during capture, so the mic stays with the recorder), `selectSlotDay` for calendar UI. While a reply is loading, the header shows **Getting ready…** (or the live stage), and the waiting bubble shows a shimmer. The composer field does not. Reply text then **types out slowly** (ChatGPT-style character reveal); chips/cards land when the typewriter catches the final. While the mic is open, the composer becomes a recording bar: delete, a teal sound wave, an elapsed timer, and send. User voice bubbles keep the recorded clip for play / pause, show **Transcribing…** until the audio-stream transcript (`transcription.text`) arrives, then the transcript. Each message shows the time it was sent. Assistant replies sit beside the clinic mark, with copy and a speaker control: a 3-dot loader while `audio_pending`, then Play once the turn stream attaches `audio.base64` (no on-device TTS for text or voice). Voice notes show a wave, the transcript, and the time. اردو forces `ur` on the audio turn. Tap the mic again to send. `GET /sdk/app` `voice.output.enabled` gates server speak. Text and voice both use an SSE turn (`speak: true`) and keep listening until delayed `type: audio` arrives for that `turn_id`. A second voice note does not cancel the previous turn: each bubble keeps its own stream so the earlier clip can still attach. The mic stays available while a reply is in flight. Neither text nor voice turns auto-play; user taps Play. Session/init greeting audio plays once when entering from the app. Playback uses `ApnaClinicAiAudioPlayerService`. Emits `doctors`, `slotDays` / `slots`, `payments`, `quickActions`. Emergency phrases use `ApnaClinicAiEmergency`.

## DI

`apna_clinic_ai_injection.dart` — `initApnaClinicAiInjector()` from `initDependencyInjection()`. Cubit is a factory; SDK client, `ApnaClinicAiSdkAuthResolver`, `ApnaClinicAiSdkInitializer`, and repository are singletons. Also registers `SendApnaClinicAiAudioUseCase`, `ApnaClinicAiAudioRecorderService`, `ApnaClinicAiAudioPlayerService`. Session boot is split under `data/sdk_init/` — how to call + steps in `SESSION_INIT.md`.

## Mocks

None. Missing dart-defines surface `ApnaClinicAiFailureCodes.notConfigured`.
