# Analytics

Use `AnalyticsService.logEvent` for every event. Do not add feature-specific
methods on the service. Firebase is the first backend; add more in DI later.

## Layout
- `analytics_event_keys.dart` — event and parameter names
- `analytics_service.dart` — `logEvent` / screen / user id, fans out to providers
- `providers/firebase_analytics_provider.dart` — Firebase (no-op until `FirebaseBootstrap`)

## DI
```dart
sl.registerLazySingleton<AnalyticsService>(
  () => AnalyticsServiceImpl([
    FirebaseAnalyticsProvider(),
  ]),
);
```

## Usage
```dart
unawaited(
  sl<AnalyticsService>().logEvent(
    AnalyticsEventKeys.onboardingStep(2),
    {AnalyticsParamKeys.stepNumber: 2},
  ),
);
```

Add new names in `AnalyticsEventKeys` / `AnalyticsParamKeys`, then call `logEvent`.
Each `logEvent` writes a `developer.log` (`AnalyticsService`) before fan-out.
Events before Firebase init are dropped. Do not put PII in parameters.

## Consultation AI chat
| Event | When | Param |
|---|---|---|
| `ai_chat_started` | AI screening WebView opens | — |
## Search
| Event | When | Params |
|---|---|---|
| `search_screen` | Search screen opens | — |
| `search_performed` | Submit | `keyword`, `medium` (`Type` / `Voice` / `Recent` / `Popular`) |
| `search_result_clicked` | Result tap | `type` (`medicine_name` / `doctor` / `lab` / `surgery_doctor`) |

## Instant Doctor
| Event | When | Params |
|---|---|---|
| `instant_doctor_module` | Instant Doctor tab opens | `source_screen` (`banner` / `bottom_tab`) |
| `instant_doc_subscribe_clicked` | Subscribe tap | `partner` |
| `fb_mobile_subscribe` | Subscribe OTP succeeds | `partner`, `msisdn` |
| `start_consultation_clicked` | Consultation WebView opens | `partner`, `msisdn` |
