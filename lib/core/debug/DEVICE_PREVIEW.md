# Device Preview (testing only)

[`device_preview`](https://pub.dev/packages/device_preview) wraps the app in debug so you can test layouts on different phones, orientations, locales, and text scale without physical devices.

**Not used in release builds** — release/profile compiles the stub (`device_preview_stub.dart`) and never imports the package.

---

## When it runs

| Mode | Device preview |
|------|----------------|
| `flutter run` (debug) | On by default |
| `flutter run --dart-define=ENABLE_DEVICE_PREVIEW=false` | Off |
| `flutter build apk --release` / App Store / Play release | Off (stub only) |

---

## How to use

1. Run the app in debug:
   ```bash
   flutter run
   ```
2. Use the **Device Preview** toolbar (device frame around the app):
   - Switch device / screen size
   - Rotate
   - Change locale (includes app locales + preview locales)
   - Toggle dark mode, text scale, etc.

3. To run **without** the frame (normal full-screen debug):
   ```bash
   flutter run --dart-define=ENABLE_DEVICE_PREVIEW=false
   ```

---

## Integration (where it lives)

| File | Role |
|------|------|
| `pubspec.yaml` | `device_preview: ^1.3.1` under **dev_dependencies** |
| `lib/core/debug/device_preview_support.dart` | Conditional export (impl vs stub) |
| `lib/core/debug/device_preview_impl.dart` | `DevicePreview` wrapper (debug only) |
| `lib/core/debug/device_preview_stub.dart` | No-op for release |
| `lib/main.dart` | `wrapWithDevicePreview(child: …)` |
| `lib/features/app/presentation/screens/apna_clinic_app.dart` | `locale`, `DevicePreview.appBuilder`, merged `supportedLocales` |

All app code should import **`device_preview_support.dart`**, not `package:device_preview/...` directly.

---

## Remove Device Preview completely

Follow these steps if you no longer want the integration in the repo.

### 1. Remove the dependency

In `pubspec.yaml`, delete from `dev_dependencies`:

```yaml
device_preview: ^1.3.1
```

Then:

```bash
flutter pub get
```

### 2. Delete debug helper files

```bash
rm lib/core/debug/device_preview_support.dart
rm lib/core/debug/device_preview_impl.dart
rm lib/core/debug/device_preview_stub.dart
rm lib/core/debug/DEVICE_PREVIEW.md
```

### 3. Revert `lib/main.dart`

Remove:

```dart
import 'core/debug/device_preview_support.dart';
```

Replace:

```dart
runApp(
  wrapWithDevicePreview(child: const ApnaClinicApp()),
);
```

with:

```dart
runApp(const ApnaClinicApp());
```

Do the same for the error `MaterialApp` path: remove `wrapWithDevicePreview(` / extra closing `)`.

### 4. Revert `lib/features/app/presentation/screens/apna_clinic_app.dart`

Remove:

```dart
import '../../../../core/debug/device_preview_support.dart';
```

In `MaterialApp.router`, remove:

- `locale: devicePreviewLocale(context),`
- `applyDevicePreviewBuilder` usage in `builder` (use `child` directly again)
- `mergeSupportedLocales(...)` — set `supportedLocales: AppLocalizations.supportedLocales` only

Example `builder` start (after revert):

```dart
builder: (context, child) {
  final mediaQueryData = MediaQuery.of(context);
  final clampedScale = ScreenUtilX.clampedTextScale(mediaQueryData);
  // ...
  final appChild = child ?? const SizedBox.shrink();
```

### 5. Verify

```bash
dart analyze
flutter run
flutter build apk --release
```

---

## Troubleshooting

- **Preview frame missing** — Confirm debug mode and `ENABLE_DEVICE_PREVIEW` is not `false`.
- **Locale / layout looks wrong in preview** — Preview overrides `MediaQuery`; compare with `--dart-define=ENABLE_DEVICE_PREVIEW=false`.
- **Analyzer: depend_on_referenced_packages** on `device_preview_impl.dart` — Expected; impl is dev-only. Do not import `device_preview` from production feature code.

---

## Re-enable later

1. Add `device_preview: ^1.3.1` to `dev_dependencies`.
2. Restore the four files under `lib/core/debug/` (from git history or this guide).
3. Re-apply `main.dart` and `apna_clinic_app.dart` wiring as in the table above.
