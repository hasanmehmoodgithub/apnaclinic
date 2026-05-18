# Device Headers Contract

This document defines the request headers automatically added by the app for API calls.

## Purpose

- Give backend services consistent client/device context.
- Support analytics, debugging, and platform-specific handling.
- Keep header naming stable across all endpoints.

## Header Keys

### Always sent

- `x-app-version` - App semantic version (example: `1.0.0`)
- `x-app-build-number` - Build number (example: `1`)
- `x-app-package` - Application package/bundle id (example: `com.mobileapp.simhealth`)
- `x-device-platform` - Client platform (`android`, `ios`, `macos`, `web`, etc.)

### Platform-specific (when available)

- `x-device-id` - Device identifier from platform APIs
- `x-device-model` - Device model (example: `SM-A546E`, `iPhone15,2`)
- `x-device-manufacturer` - OEM/manufacturer (example: `samsung`, `Apple`)
- `x-os-version` - OS version string (example: `14`, `17.6.1`)
- `x-os-sdk` - Android SDK level as string (example: `34`) - Android only

## Notes for Backend

- Some keys can be absent on specific platforms if the OS does not expose them.
- Empty values are filtered out by the app before sending.
- Header keys are case-insensitive by HTTP spec; backend should treat them case-insensitively.
- Client-provided headers should be treated as contextual metadata, not as trusted identity.

## Example Request Headers

```txt
x-app-version: 1.0.0
x-app-build-number: 1
x-app-package: com.mobileapp.simhealth
x-device-platform: android
x-device-id: abcdef123456
x-device-model: SM-A546E
x-device-manufacturer: samsung
x-os-version: 14
x-os-sdk: 34
```

## Implementation Location

- Provider: `lib/core/network/device_headers_provider.dart`
- Global interceptor: `lib/core/network/header_interceptor.dart`
- Registered in DI: `lib/core/di/dependency_injection.dart`
- Extra paths covered:
  - `lib/core/network/auth_interceptor.dart` (refresh-token request)
  - `lib/core/services/encrypted_isolate_api_service.dart`
