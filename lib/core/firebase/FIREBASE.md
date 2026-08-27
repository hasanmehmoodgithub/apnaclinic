# Firebase bootstrap

## Purpose

Initialize Firebase once per isolate so FCM and Analytics can use `[DEFAULT]`.

## Init

`FirebaseBootstrap.initialize()` is called from `main.dart` (push) and again from the FCM background isolate. Native iOS/Android may already create `[DEFAULT]` from `GoogleService-Info.plist` / `google-services.json`; bootstrap reuses that app instead of calling `initializeApp` again.

## Config

- Android: `android/app/google-services.json` (`com.apna.clinic.android`)
- iOS: `ios/Runner/GoogleService-Info.plist` (`com.apna.clinic.ios`)
- Dart: `lib/firebase_options.dart` (project `apna-clinic-mobile-app`)

Re-run `flutterfire configure` if you add platforms or rotate keys, then replace the platform config files and regenerate `firebase_options.dart`.
