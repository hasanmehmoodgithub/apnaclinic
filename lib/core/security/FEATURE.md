# Device security checks

## Purpose

Block the app on compromised devices (root / jailbreak, emulator / simulator, Frida, Xposed, etc.) and on **repackaged / cloned Android APKs**.

## Dart

- `AppIntegrity.verify()` — public API for APK package + signing-cert check (no hashes in Dart)
- `SecurityService.securityChecksEnabled` via `--dart-define=SECURITY_CHECKS` (default **true**; `false` skips root / jailbreak / Frida / emulator / APK tamper)
- `SecurityGate` wraps the app in `main.dart` (blocks + countdown + exit when compromised). When the flag is off, the child is shown immediately.
- Checking / blocked UI uses the Apna Clinic logo, `FlavorConfig.appName`, and app colors (teal / navy)
- MethodChannels: `security_channel` (`checkAppIntegrity`), advanced `qwe_rty_123` / `f1`

## Native

- **Android:** `MainActivity` + `DeviceSecurityChecker.kt`
  - Expected package: `com.apna.clinic.android`
  - SHA-256 of installed signing cert vs Gradle `BuildConfig.EXPECTED_CERT_SHA256` (this variant’s keystore) plus optional `CERT_SHA256_PLAY` / `CERT_SHA256_RELEASE` / `CERT_SHA256_EXTRA`
  - Release builds also reject `FLAG_DEBUGGABLE`
- **iOS:** `AppDelegate` + `DeviceSecurityChecker.swift` (no APK signature check)

## Android application ID

Play / installed package is `com.apna.clinic.android`. Kotlin `namespace` remains `com.apna.clinic.apnaclinic`. After changing the id, register that package in Firebase and replace `android/app/google-services.json`.

## iOS bundle ID

App Store / installed bundle is `com.apna.clinic.ios`. After changing the id, register that bundle in Apple Developer and Firebase, then replace `ios/Runner/GoogleService-Info.plist`.

## Notes

- Production flavor also enforces developer-mode (Android) and emulator/simulator blocks when `SECURITY_CHECKS` is true.
- Non-production / debug flavors still check root, jailbreak, Frida, Xposed, and tamper, but allow emulators/simulators for local testing.
- Opt out for run/APK: `--dart-define=SECURITY_CHECKS=false` (see [COMMANDS.md](../flavor/guide/COMMANDS.md)). Do not use this on store builds.
- Trust-all HTTP / mitm proxy (`AppHttpOverrides`) is separate from these device checks.
- Client-side cert pinning is bypassable (patch native). Play Integrity verified on a backend is the stronger Play-store control.
