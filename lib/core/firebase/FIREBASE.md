# Firebase bootstrap

## Purpose

Initialize Firebase once per isolate so FCM, Analytics, and Crashlytics can use `[DEFAULT]`.

## Init

`FirebaseBootstrap.initialize()` is called from `main.dart` before `runApp` (Crashlytics needs this early) and again from the FCM background isolate. Native iOS/Android may already create `[DEFAULT]` from `GoogleService-Info.plist` / `google-services.json`; bootstrap reuses that app instead of calling `initializeApp` again.

FCM setup still runs after the first frame so a slow/failing push init cannot block launch.

## Crashlytics

`CrashlyticsService.configure()` runs right after bootstrap. It:

- Enables collection in **release/profile** (`!kDebugMode`); debug builds stay local-only
- Tags reports with the current `FlavorConfig` name
- Forwards Flutter framework fatals (`FlutterError.onError`) and uncaught async errors (`PlatformDispatcher.onError`)
- Zone errors in `main.dart` call `CrashlyticsService.recordError`

User identifier is set from `AppPref.getUserId()` after DI, updated on login, and cleared on logout.

Android: `com.google.firebase.crashlytics` Gradle plugin (applied when `google-services.json` exists).

If a release build uses `--split-debug-info` / `--obfuscate`, upload Android symbols with:

`firebase crashlytics:symbols:upload --app=<ANDROID_APP_ID> <symbols-dir>`

iOS dSYMs are uploaded by the Crashlytics Flutter plugin on supported Flutter versions.

## Config

- Android: `android/app/google-services.json` (`com.apna.clinic.android`)
- iOS: `ios/Runner/GoogleService-Info.plist` (`com.apna.clinic.ios`)
- Dart: `lib/firebase_options.dart` (project `apna-clinic-mobile-app`)

Re-run `flutterfire configure` if you add platforms or rotate keys, then replace the platform config files and regenerate `firebase_options.dart`.

## Production API base URL (planned)

Remote Config should override the API host **only in the production flavor**. Open [REMOTE_CONFIG_FLOW.html](REMOTE_CONFIG_FLOW.html) in a browser for the flow, fail-defaults, and free-quota notes.
