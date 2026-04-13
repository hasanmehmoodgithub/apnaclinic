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
