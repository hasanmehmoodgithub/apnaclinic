# Device security checks

## Purpose

Block the app on compromised devices (root / jailbreak, emulator / simulator, Frida, Xposed, etc.) and on **repackaged / cloned Android APKs**.

## Dart

- `AppIntegrity.verify()` — public API for APK package + signing-cert check (no hashes in Dart)
- `SecurityService.securityChecksEnabled = false` (root / Frida / emulator gate still off)
- **APK tamper is always evaluated on Android** via `AppIntegrity`, even when the master switch is off
- `SecurityGate` wraps the app in `main.dart` (blocks + countdown + exit on tamper)
- MethodChannels: `security_channel` (`checkAppIntegrity`), advanced `qwe_rty_123` / `f1`

## Native

- **Android:** `MainActivity` + `DeviceSecurityChecker.kt`
  - Expected package: `com.apna.clinic.android`
  - SHA-256 of installed signing cert vs Gradle `BuildConfig.EXPECTED_CERT_SHA256` (this variant’s keystore) plus optional `CERT_SHA256_PLAY` / `CERT_SHA256_RELEASE` / `CERT_SHA256_EXTRA`
  - Release builds also reject `FLAG_DEBUGGABLE`
- **iOS:** `AppDelegate` + `DeviceSecurityChecker.swift` (no APK signature check)

## Android application ID

Play / installed package is `com.apna.clinic.android`. Kotlin `namespace` remains `com.apna.clinic.apnaclinic`. After changing the id, register that package in Firebase and replace `android/app/google-services.json`.

## Notes

- Production flavor also enforces developer-mode (Android) and emulator/simulator blocks when `securityChecksEnabled` is true.
- Non-production / debug flavors still check root, jailbreak, Frida, Xposed, and tamper, but allow emulators/simulators for local testing.
- Trust-all HTTP / mitm proxy (`AppHttpOverrides`) is separate from these device checks.
- Client-side cert pinning is bypassable (patch native). Play Integrity verified on a backend is the stronger Play-store control.
