# Device security checks

## Purpose

Block the app on compromised devices (root / jailbreak, emulator / simulator, Frida, Xposed, etc.) via `SecurityGate` + `SecurityService`.

## Dart

- `SecurityService.securityChecksEnabled = true`
- App wrapped in `SecurityGate` from `main.dart`
- MethodChannels: `security_channel`, advanced `qwe_rty_123` (Android)

## Native

- **Android:** `MainActivity` + `DeviceSecurityChecker.kt`
- **iOS:** `AppDelegate` + `DeviceSecurityChecker.swift`

## Notes

- Production flavor also enforces developer-mode (Android) and emulator/simulator blocks.
- Non-production / debug flavors still check root, jailbreak, Frida, Xposed, and tamper, but allow emulators/simulators for local testing.
- Trust-all HTTP / mitm proxy (`AppHttpOverrides`) is separate from these device checks.
