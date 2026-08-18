# Flavor Commands Quick Reference

## 🚀 Run Commands

### Development (Default)
```bash
# No dart-define needed - defaults to development
flutter run

# Or explicitly
flutter run --dart-define=APP_FLAVOR=development
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
