# Flavor Commands Quick Reference

## 🚀 Run Commands

### Development (Default)
```bash
# No dart-define needed - defaults to development
flutter run

# Or explicitly
flutter run --dart-define=APP_FLAVOR=development
```

### HMAC secrets (android / ios)

Never commit real secrets. Copy `hmac.keys.json.example` → `hmac.keys.json` (gitignored). Details: [HMAC.md](../../network/HMAC.md).

```bash
flutter run --dart-define-from-file=hmac.keys.json

flutter run \
  --dart-define=APP_FLAVOR=development \
  --dart-define-from-file=hmac.keys.json
```

### Staging
```bash
flutter run --dart-define=APP_FLAVOR=staging
```

### Production
```bash
flutter run --dart-define=APP_FLAVOR=production
```

---

## 📦 Build Commands

### Android APK
```bash
# Production
flutter build apk --dart-define=APP_FLAVOR=production

# Staging
flutter build apk --dart-define=APP_FLAVOR=staging

# Development
flutter build apk --dart-define=APP_FLAVOR=development
```

Copy-ready matrix (staging / production × Chucker on / off, plus split, proxy, JazzCash): open [APK_BUILD.html](APK_BUILD.html) in a browser.

### Chucker (release APKs)

`CHUCKER_ACTIVE` defaults to **true** in release. Debug always has Chucker. Opt out with `false`.

```bash
# Staging + Chucker (explicit; same as default)
flutter build apk --dart-define=APP_FLAVOR=staging --dart-define=CHUCKER_ACTIVE=true

# Staging without Chucker
flutter build apk --dart-define=APP_FLAVOR=staging --dart-define=CHUCKER_ACTIVE=false

# Production + Chucker (explicit; same as default)
flutter build apk --dart-define=APP_FLAVOR=production --dart-define=CHUCKER_ACTIVE=true

# Production without Chucker (store / real users)
flutter build apk --dart-define=APP_FLAVOR=production --dart-define=CHUCKER_ACTIVE=false
```

### Date / time on version + APK file

`--build-name` is Android `versionName` (Settings). `--build-number` is `versionCode` (integer, unique per minute, under Play’s 2.1B cap). Flutter always writes `app-release.apk`; `mv` stamps the file you share.

```bash
STAMP=$(date +%Y%m%d-%H%M)
CODE=$(date +%y%j%H%M)

# Staging + Chucker
flutter build apk \
  --build-name="1.0.0-$STAMP" \
  --build-number=$CODE \
  --dart-define=APP_FLAVOR=staging \
  --dart-define=CHUCKER_ACTIVE=true
mv build/app/outputs/flutter-apk/app-release.apk \
  "build/app/outputs/flutter-apk/apnaclinic-staging-chucker-${STAMP}.apk"

# Staging without Chucker
flutter build apk \
  --build-name="1.0.0-$STAMP" \
  --build-number=$CODE \
  --dart-define=APP_FLAVOR=staging \
  --dart-define=CHUCKER_ACTIVE=false
mv build/app/outputs/flutter-apk/app-release.apk \
  "build/app/outputs/flutter-apk/apnaclinic-staging-nochucker-${STAMP}.apk"

# Production + Chucker
flutter build apk \
  --build-name="1.0.0-$STAMP" \
  --build-number=$CODE \
  --dart-define=APP_FLAVOR=production \
  --dart-define=CHUCKER_ACTIVE=true
mv build/app/outputs/flutter-apk/app-release.apk \
  "build/app/outputs/flutter-apk/apnaclinic-production-chucker-${STAMP}.apk"

# Production without Chucker (store: skip datetime stamp; keep 1.x.y + increasing code)
flutter build apk \
  --build-name="1.0.0-$STAMP" \
  --build-number=$CODE \
  --dart-define=APP_FLAVOR=production \
  --dart-define=CHUCKER_ACTIVE=false
mv build/app/outputs/flutter-apk/app-release.apk \
  "build/app/outputs/flutter-apk/apnaclinic-production-nochucker-${STAMP}.apk"
```

Example file: `apnaclinic-staging-chucker-20260823-2309.apk`. Copy-ready builder: [APK_BUILD.html](APK_BUILD.html).

### Android App Bundle
```bash
# Production
flutter build appbundle --dart-define=APP_FLAVOR=production

# Staging
flutter build appbundle --dart-define=APP_FLAVOR=staging
```

### iOS
```bash
# Production
flutter build ios --dart-define=APP_FLAVOR=production

# Staging
flutter build ios --dart-define=APP_FLAVOR=staging
```

---

## 🔧 Override API URL

Override the API URL for any flavor:

```bash
# Development with custom API
flutter run --dart-define=APP_FLAVOR=development --dart-define=API_BASE_URL=https://custom-api.com

# Staging with custom API
flutter run --dart-define=APP_FLAVOR=staging --dart-define=API_BASE_URL=https://custom-staging.com
```

---

## 🔌 HTTP proxy (mitm)

Comma-separated `host:port` list. First reachable candidate is used; omit `HTTP_PROXIES` for DIRECT.

```bash
# Staging run
flutter run --release --dart-define=APP_FLAVOR=staging --dart-define="HTTP_PROXIES=192.168.100.77:8080,10.124.74.71:8080,192.168.13.1:8080,192.168.19.1:9000"

# Staging APK
flutter build apk --dart-define=APP_FLAVOR=staging --dart-define="HTTP_PROXIES=192.168.100.77:8080,10.124.74.71:8080,192.168.13.1:8080,192.168.19.1:9000"
```

---

## JazzCash sandbox account

Requires both defines. Number is **not** hardcoded — pass it as `ACCOUNT_TEST_PHONE`. Appends that row to Account Details (Profile list + JazzCash picker). Not sent to the API.

```bash
# Staging APK + sandbox number + proxy
flutter build apk --dart-define=APP_FLAVOR=staging --dart-define=JAZZCASH_SANDBOX=true --dart-define=ACCOUNT_TEST_PHONE=03123456789 --dart-define="HTTP_PROXIES=192.168.100.77:8080,10.124.74.71:8080,192.168.13.1:8080,192.168.19.1:9000"
```

---

## 💻 Code Usage

### Import
```dart
import 'core/flavor/flavor_config.dart';
```

### Get API URL
```dart
final url = FlavorConfig.apiBaseUrl;
```

### Check Flavor
```dart
if (FlavorConfig.isDevelopment) {
  // Development code
}

if (FlavorConfig.isProduction) {
  // Production code
}
```

### Logging
```dart
// Only logs if logging is enabled for current flavor
FlavorConfig.log('Message');
FlavorConfig.logError('Error', exception, stackTrace);
```

### Get App Name
```dart
final appName = FlavorConfig.appName;
```

### Initialize
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize();  // Call this first!
  runApp(MyApp());
}
```

---

## 📝 Important Notes

- **Default**: If `--dart-define=APP_FLAVOR` is not specified, it defaults to **development**
- **Hot Restart**: Flavor changes require a full app restart (not hot restart)
- **Clean Build**: If flavor not changing, try: `flutter clean && flutter pub get`

---

For detailed setup instructions, see [FLAVOR_GUIDE.md](FLAVOR_GUIDE.md)
