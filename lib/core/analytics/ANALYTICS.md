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
