# Device security checks

## Purpose

Block the app on compromised devices (root / jailbreak, emulator / simulator, Frida, Xposed, etc.) and on **repackaged / cloned Android APKs**.

## Dart

- `AppIntegrity.verify()` — public API for APK package + signing-cert check (no hashes in Dart). **Currently not blocking:** `AppIntegrity.enforceBlock` is `false`; set it to `true` to restore tamper/unavailable blocks.
- `SecurityService.securityChecksEnabled` via `--dart-define=SECURITY_CHECKS` (default **true**; `false` skips root / jailbreak / Frida / emulator / APK tamper)
- `SecurityGate` wraps the app in `main.dart`. While the check runs, splash is shown (no separate checking screen). Compromised devices get the blocked UI + countdown + exit. When the flag is off, the child is shown immediately.
- `SecurityService.ensureChecked()` is a single-flight check shared by the gate and splash so splash does not navigate until the result is known.
- Blocked UI uses the Apna Clinic logo and app colors (teal / navy)
- MethodChannels: `security_channel` (`checkAppIntegrity`), advanced `qwe_rty_123` / `f1`
- `NativeSecurity.getSecretKey()` uses MethodChannel `native/keys` / `getSecretKey` so `EncryptionService` can combine a native key with the FlutterSecureStorage secret. Missing native registration previously threw `MissingPluginException` and fell back to a persisted Dart-generated key.

## Native

- **Android:** `MainActivity` + `DeviceSecurityChecker.kt` + `NativeKeyProvider.kt`
  - Expected package: `com.apna.clinic.android`
  - SHA-256 of installed signing cert vs Gradle `BuildConfig.EXPECTED_CERT_SHA256` (this variant’s keystore) plus optional `CERT_SHA256_PLAY` / `CERT_SHA256_RELEASE` / `CERT_SHA256_EXTRA`
  - Release uses `android/app/econceptions.jks` via gitignored `android/key.properties` (or `UPLOAD_STORE_PASSWORD` / `UPLOAD_KEY_PASSWORD` / `UPLOAD_KEY_ALIAS` / `UPLOAD_STORE_FILE`). Falls back to debug signing if the upload keystore is missing.
  - Release builds also reject `FLAG_DEBUGGABLE`
  - Release uses R8 minify + resource shrinking (`proguard-rules.pro`); DexGuard is not enabled
  - `native/keys` wraps a one-time random 32-byte secret with an AndroidKeyStore AES-GCM key (keystore keys are not exportable)
- **iOS:** `AppDelegate` + `DeviceSecurityChecker.swift` + `NativeKeyProvider.swift` (no APK signature check)
  - `native/keys` stores the same 32-byte secret in Keychain (`AfterFirstUnlockThisDeviceOnly`)

## Android application ID

Play / installed package is `com.apna.clinic.android`. Kotlin `namespace` remains `com.apna.clinic.apnaclinic`. After changing the id, register that package in Firebase and replace `android/app/google-services.json`.

## iOS bundle ID

App Store / installed bundle is `com.apna.clinic.ios`. After changing the id, register that bundle in Apple Developer and Firebase, then replace `ios/Runner/GoogleService-Info.plist`.

## Notes

- Production flavor also enforces developer-mode (Android) and emulator/simulator blocks when `SECURITY_CHECKS` is true.
- Non-production / debug flavors still check root, jailbreak, Frida, and Xposed, but allow emulators/simulators for local testing. APK tamper blocking is off until `AppIntegrity.enforceBlock` is set back to `true`.
- Opt out for run/APK: `--dart-define=SECURITY_CHECKS=false` (see [COMMANDS.md](../flavor/guide/COMMANDS.md)). Do not use this on store builds.
- Trust-all HTTP / mitm proxy (`AppHttpOverrides`) is separate from these device checks.
- Client-side cert pinning is bypassable (patch native). Play Integrity verified on a backend is the stronger Play-store control.
