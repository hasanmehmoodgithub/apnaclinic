# AppsFlyer — re-integration prompt

**Status (Aug 2026):** `appsflyer_sdk` and all Dart wiring were removed. Product analytics stay on Firebase via `AnalyticsService`. Use this file to put AppsFlyer back.

---

## Prompt (paste to an agent)

Re-integrate **AppsFlyer** into this Flutter app for mobile attribution and in-app events. Match the previous scaffold; do not invent extra native config unless the SDK requires it.

### Package

- Add `appsflyer_sdk: ^6.18.1` to `pubspec.yaml` dependencies.
- Run `flutter pub get`. On iOS, CocoaPods will pull `AppsFlyerFramework` 6.18.1.

### Flavor credentials (`lib/core/flavor/`)

Add to every `AppFlavor` value (`development`, `staging`, `production`):

- `appsFlyerDevKey` — AppsFlyer Dev Key (Android + iOS). Empty string = skip SDK start.
- `appsFlyerIosAppId` — numeric Apple App Store id. Required on iOS together with Dev Key.

Expose on `FlavorConfig`:

- `appsFlyerDevKey`
- `appsFlyerIosAppId`
- `isAppsFlyerConfigured` → Dev Key non-empty (service still requires iOS App ID on iOS before start).

Leave keys `''` until business provides them. Init must be a **no-op** when missing; log which fields are missing.

Enable later:

1. AppsFlyer dashboard → App Settings → **Dev Key**
2. App Store Connect → Apple ID (numeric) for iOS
3. Set values on `AppFlavor.development` / `staging` / `production`
4. Full app restart (not hot reload)

iOS: Dev Key alone is not enough — fill `appsFlyerIosAppId`.

### Wrapper — `lib/core/services/appsflyer_service.dart`

Create `AppsFlyerService` wrapping `appsflyer_sdk`. Safe without credentials.

```dart
import 'dart:developer' as developer;
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

import '../flavor/flavor_config.dart';

/// AppsFlyer attribution / analytics wrapper.
///
/// Safe without credentials: [initialize] is a no-op until
/// [FlavorConfig.appsFlyerDevKey] is set (iOS also needs [FlavorConfig.appsFlyerIosAppId]).
class AppsFlyerService {
  AppsflyerSdk? _sdk;
  bool _initialized = false;

  bool get isConfigured {
    if (FlavorConfig.appsFlyerDevKey.trim().isEmpty) return false;
    if (Platform.isIOS && FlavorConfig.appsFlyerIosAppId.trim().isEmpty) {
      return false;
    }
    return true;
  }

  bool get isInitialized => _initialized;

  /// Starts the SDK when Dev Key (and iOS App ID on iOS) are present.
  Future<void> initialize() async {
    if (_initialized) return;

    if (!isConfigured) {
      final missing = <String>[
        if (FlavorConfig.appsFlyerDevKey.trim().isEmpty) 'appsFlyerDevKey',
        if (Platform.isIOS && FlavorConfig.appsFlyerIosAppId.trim().isEmpty)
          'appsFlyerIosAppId',
      ];
      developer.log(
        'AppsFlyer skipped: fill ${missing.join(' + ')} in AppFlavor '
        'when business provides credentials. See APPSFLYER.md.',
        name: 'AppsFlyerService',
      );
      return;
    }

    try {
      final options = AppsFlyerOptions(
        afDevKey: FlavorConfig.appsFlyerDevKey.trim(),
        appId: FlavorConfig.appsFlyerIosAppId.trim(),
        showDebug: FlavorConfig.enableDebugFeatures || kDebugMode,
        timeToWaitForATTUserAuthorization: Platform.isIOS ? 15 : null,
        manualStart: true,
      );

      _sdk = AppsflyerSdk(options);
      await _sdk!.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );
      _sdk!.startSDK(
        onSuccess: () {
          developer.log('AppsFlyer SDK started', name: 'AppsFlyerService');
        },
        onError: (int code, String message) {
          developer.log(
            'AppsFlyer start error: $code $message',
            name: 'AppsFlyerService',
          );
        },
      );
      _initialized = true;
      developer.log('AppsFlyer initialized', name: 'AppsFlyerService');
    } catch (e, st) {
      developer.log(
        'AppsFlyer init failed: $e',
        name: 'AppsFlyerService',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Binds the logged-in user for attribution. No-op if SDK not started.
  void setCustomerUserId(String userId) {
    final id = userId.trim();
    if (!_initialized || _sdk == null || id.isEmpty) return;
    _sdk!.setCustomerUserId(id);
    developer.log('AppsFlyer customerUserId set', name: 'AppsFlyerService');
  }

  /// Clears customer user id on logout (empty id).
  void clearCustomerUserId() {
    if (!_initialized || _sdk == null) return;
    _sdk!.setCustomerUserId('');
  }

  /// Logs a custom in-app event. No-op if SDK not started.
  Future<void> logEvent(
    String eventName, [
    Map<String, dynamic>? eventValues,
  ]) async {
    if (!_initialized || _sdk == null) return;
    final name = eventName.trim();
    if (name.isEmpty) return;
    try {
      await _sdk!.logEvent(name, eventValues);
    } catch (e, st) {
      developer.log(
        'AppsFlyer logEvent failed: $e',
        name: 'AppsFlyerService',
        error: e,
        stackTrace: st,
      );
    }
  }
}
```

### AppsFlyer UID → API header

After init, call `getAppsFlyerUID()` and cache on `AppsFlyerService.appsFlyerUid`.
`DeviceHeadersProvider` merges `x-appsflyer-id` on every request once the UID is non-empty
(see `DEVICE_HEADERS_CONTRACT.md`). Early requests before SDK start omit the header.

### DI

In `lib/core/di/dependency_injection.dart` `_initCore`:

```dart
sl.registerLazySingleton<AppsFlyerService>(() => AppsFlyerService());
sl.registerLazySingleton<DeviceHeadersProvider>(
  () => DeviceHeadersProvider(
    appsFlyerUidProvider: () => sl<AppsFlyerService>().appsFlyerUid,
  ),
);
```

Do **not** add AppsFlyer to `AnalyticsServiceImpl` providers unless product asks to fan out Firebase events to AppsFlyer. Previous setup: Firebase only.

```dart
sl.registerLazySingleton<AnalyticsService>(
  () => AnalyticsServiceImpl([FirebaseAnalyticsProvider()]),
);
```

### Startup (`lib/main.dart`)

After `runApp`, initialize **non-blocking** (SDK can hang; must not block first frame), same pattern as FCM:

```dart
unawaited(_initializePushNotifications());
unawaited(_initializeAppsFlyer());
```

```dart
Future<void> _initializeAppsFlyer() async {
  try {
    await sl<AppsFlyerService>().initialize();
  } catch (e, stackTrace) {
    developer.log(
      'AppsFlyer init failed: $e',
      name: 'main',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
```

### Login

In `AuthCubit._saveUserSession` (after OTP, when persisting user id):

```dart
if (sl.isRegistered<AppsFlyerService>()) {
  sl<AppsFlyerService>().setCustomerUserId(resolvedUserId);
}
```

`resolvedUserId` is JWT `sub`, else `entity.userId`, else phone.

### Logout

In `LocalLogoutService.clearAll`:

```dart
if (sl.isRegistered<AppsFlyerService>()) {
  sl<AppsFlyerService>().clearCustomerUserId();
}
```

### Docs to update when restoring

- `lib/features/auth/FEATURE.md` — mention `setCustomerUserId` after OTP.
- `lib/core/analytics/ANALYTICS_EVENTS.html` — AppsFlyer registered but **not** in analytics fan-out (unless you wire it).
- This file — change status from removed to scaffolded.

### Optional follow-ups (not in original scaffold)

- Call `AppsFlyerService.logEvent` for product events (`af_login` is covered via customer id; consultation / lab / surgery / pharmacy as needed).
- Optionally add an `AppsFlyerAnalyticsProvider` to `AnalyticsServiceImpl` so existing `AnalyticsEventKeys` also go to AppsFlyer.
- OneLink / deferred deep links into `go_router` (callbacks were registered, but nothing routed).
- ATT prompt UX on iOS 14.5+ (SDK already waits up to 15s when configured).
//
### Constraints

- Keep business logic out of widgets; service in `lib/core/services/`.
- Do not hardcode user-facing strings.
- Do not block `runApp` on AppsFlyer init.
- Empty credentials must skip start without crashing.
- Use `go_router` only if adding deep-link navigation.

---

## Previous wiring map

| Piece | Location |
|-------|----------|
| Package | `pubspec.yaml` → `appsflyer_sdk: ^6.18.1` |
| Wrapper | `lib/core/services/appsflyer_service.dart` |
| Flavor keys | `lib/core/flavor/app_flavor.dart`, `flavor_config.dart` |
| DI | `_initCore` in `dependency_injection.dart` |
| Start | `main.dart` `unawaited(_initializeAppsFlyer())` after `runApp` |
| Login | `AuthCubit._saveUserSession` → `setCustomerUserId` |
| Logout | `LocalLogoutService.clearAll` → `clearCustomerUserId` |
| Custom events | `logEvent` existed; **no call sites** — Firebase owns product events |
