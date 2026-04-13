# ⚙️ Flavor Configuration Guide

Complete guide for using flavors (development, staging, production) in your Flutter app.

---

## 📖 Table of Contents

1. [What are Flavors?](#what-are-flavors)
2. [Quick Start](#quick-start)
3. [Initialization Guide](#initialization-guide)
4. [Running with Flavors](#running-with-flavors)
5. [IDE Setup](#ide-setup)
6. [Using in Code](#using-in-code)
7. [Configuration](#configuration)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## 🎯 What are Flavors?

Flavors let you run different versions of your app with different configurations:
- **Development** - For local development and testing
- **Staging** - For testing before production release
- **Production** - For end users

Each flavor can have different:
- API URLs
- App names
- Logging settings
- Debug features

### Default Behavior

**Important:** If you don't specify `--dart-define=APP_FLAVOR`, it defaults to **development**.

```dart
// Defaults to development if not specified
flutter run  // Uses development flavor
```

---

## 🚀 Quick Start

### 1. Initialize in main()

First, add initialization in your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/flavor/flavor_config.dart';
import 'core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize flavor configuration (call this first!)
  FlavorConfig.initialize();
  
  // Initialize dependency injection
  await initDependencyInjection();
  
  runApp(MyApp());
}
```

### 2. Run with Different Flavors

```bash
# Development (default - no need to specify)
flutter run

# Staging
flutter run --dart-define=APP_FLAVOR=staging

# Production
flutter run --dart-define=APP_FLAVOR=production
```

### 3. Build for Production

```bash
# Android APK
flutter build apk --dart-define=APP_FLAVOR=production

# Android App Bundle
flutter build appbundle --dart-define=APP_FLAVOR=production

# iOS
flutter build ios --dart-define=APP_FLAVOR=production
```

---

## 📝 Initialization Guide

### Step 1: Import FlavorConfig

```dart
import 'core/flavor/flavor_config.dart';
```

### Step 2: Initialize in main()

Add `FlavorConfig.initialize()` at the start of your `main()` function:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize flavor (prints flavor info if logging enabled)
  FlavorConfig.initialize();
  
  // Rest of your initialization
  await initDependencyInjection();
  
  runApp(MyApp());
}
```

### What initialize() Does

- Reads the `APP_FLAVOR` environment variable
- Sets up the current flavor (defaults to development if not specified)
- Prints flavor information if logging is enabled:
  - Current flavor name
  - API Base URL
  - Debug features status

### Example Output

When running in development mode:
```
[DEVELOPMENT] App initialized with flavor: Development
[DEVELOPMENT] API Base URL: https://dev-api.example.com/api
[DEVELOPMENT] Debug features: true
```

---

## 🏃 Running with Flavors

### Command Line

#### Development (Default)

```bash
# No dart-define needed - defaults to development
flutter run

# Or explicitly
flutter run --dart-define=APP_FLAVOR=development
```

#### Staging

```bash
flutter run --dart-define=APP_FLAVOR=staging
```

#### Production

```bash
flutter run --dart-define=APP_FLAVOR=production
```

### Override API URL

You can override the API URL for any flavor:

```bash
flutter run --dart-define=APP_FLAVOR=development --dart-define=API_BASE_URL=https://custom-api.com
```

### Build Commands

```bash
# Android APK - Production
flutter build apk --dart-define=APP_FLAVOR=production

# Android App Bundle - Production
flutter build appbundle --dart-define=APP_FLAVOR=production

# iOS - Production
flutter build ios --dart-define=APP_FLAVOR=production

# Android APK - Staging
flutter build apk --dart-define=APP_FLAVOR=staging
```

---

## 🛠️ IDE Setup

### VS Code Setup

#### Step 1: Create Launch Configuration

Create or edit `.vscode/launch.json` in your project root:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_FLAVOR=development"]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_FLAVOR=staging"]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_FLAVOR=production"]
    },
    {
      "name": "Development (Custom API)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=APP_FLAVOR=development",
        "--dart-define=API_BASE_URL=https://custom-api.com"
      ]
    }
  ]
}
```

#### Step 2: Use Launch Configuration

1. Open VS Code
2. Go to **Run and Debug** (Ctrl+Shift+D / Cmd+Shift+D)
3. Select configuration from dropdown (Development, Staging, or Production)
4. Click **Start Debugging** (F5)

### Android Studio Setup

#### Step 1: Create Run Configuration

1. Go to **Run → Edit Configurations...**
2. Click **+** (Plus icon) → Select **Flutter**
3. Configure each flavor:

**Development Configuration:**
- **Name**: `Development`
- **Dart entrypoint**: `lib/main.dart`
- **Additional run args**: `--dart-define=APP_FLAVOR=development`
- Click **Apply**

**Staging Configuration:**
- **Name**: `Staging`
- **Dart entrypoint**: `lib/main.dart`
- **Additional run args**: `--dart-define=APP_FLAVOR=staging`
- Click **Apply**

**Production Configuration:**
- **Name**: `Production`
- **Dart entrypoint**: `lib/main.dart`
- **Additional run args**: `--dart-define=APP_FLAVOR=production`
- Click **Apply**

#### Step 2: Use Run Configuration

1. Select configuration from dropdown (top toolbar)
2. Click **Run** (▶️) or press **Shift+F10**

#### Step 3: Create Build Configuration (Optional)

For building APKs/App Bundles:

1. Go to **Run → Edit Configurations...**
2. Click **+** → **Flutter**
3. **Name**: `Build Production APK`
4. **Dart entrypoint**: `lib/main.dart`
5. **Additional run args**: `build apk --dart-define=APP_FLAVOR=production`
6. Click **Apply**

---

## 💻 Using in Code

### Import

```dart
import 'core/flavor/flavor_config.dart';
```

### Get Current Flavor

```dart
// Get flavor enum
final flavor = FlavorConfig.currentFlavor;

// Get flavor name
final flavorName = FlavorConfig.currentFlavor.name; // "Development", "Staging", or "Production"
```

### Check Flavor Type

```dart
// Check if development
if (FlavorConfig.isDevelopment) {
  // Development-only code
  print('Running in development mode');
}

// Check if staging
if (FlavorConfig.isStaging) {
  // Staging-only code
}

// Check if production
if (FlavorConfig.isProduction) {
  // Production-only code
}
```

### Get API URL

```dart
// Get API base URL (from flavor or environment override)
final apiUrl = FlavorConfig.apiBaseUrl;

// Use in API calls
final response = await http.get(Uri.parse('${FlavorConfig.apiBaseUrl}/users'));
```

### Get App Name

```dart
final appName = FlavorConfig.appName;
// Development: "My App (Dev)"
// Staging: "My App (Staging)"
// Production: "My App"
```

### Conditional Logging

```dart
// Only logs if logging is enabled for current flavor
FlavorConfig.log('Debug message');
FlavorConfig.logError('Error occurred', exception, stackTrace);
```

### Check Debug Features

```dart
if (FlavorConfig.enableDebugFeatures) {
  // Show debug menu, enable developer options, etc.
  showDebugMenu();
}
```

### Check Logging Status

```dart
if (FlavorConfig.enableLogging) {
  // Logging is enabled for this flavor
}
```

### Complete Example

```dart
import 'core/flavor/flavor_config.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Show debug banner only in development
    if (FlavorConfig.isDevelopment) {
      return Banner(
        message: 'DEV',
        location: BannerLocation.topEnd,
        child: _buildContent(),
      );
    }
    
    return _buildContent();
  }
  
  Widget _buildContent() {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlavorConfig.appName),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Current Flavor: ${FlavorConfig.currentFlavor.name}'),
            Text('API URL: ${FlavorConfig.apiBaseUrl}'),
            if (FlavorConfig.enableDebugFeatures)
              ElevatedButton(
                onPressed: () => _showDebugMenu(),
                child: Text('Debug Menu'),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## ⚙️ Configuration

### Edit Flavor Settings

Edit `lib/core/flavor/app_flavor.dart` to customize each flavor:

```dart
enum AppFlavor {
  development(
    name: 'Development',
    apiBaseUrl: 'https://dev-api.example.com/api',  // Change this
    appName: 'My App (Dev)',  // Change this
    enableLogging: true,
    enableDebugFeatures: true,
  ),
  staging(
    name: 'Staging',
    apiBaseUrl: 'https://staging-api.example.com/api',  // Change this
    appName: 'My App (Staging)',  // Change this
    enableLogging: true,
    enableDebugFeatures: false,
  ),
  production(
    name: 'Production',
    apiBaseUrl: 'https://api.example.com/api',  // Change this
    appName: 'My App',  // Change this
    enableLogging: false,
    enableDebugFeatures: false,
  );

  final String name;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
  final bool enableDebugFeatures;

  const AppFlavor({
    required this.name,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
    required this.enableDebugFeatures,
  });
}
```

### Add New Flavor (Optional)

To add a new flavor (e.g., `qa`):

1. Add to enum in `app_flavor.dart`:
```dart
enum AppFlavor {
  development(...),
  staging(...),
  production(...),
  qa(  // New flavor
    name: 'QA',
    apiBaseUrl: 'https://qa-api.example.com/api',
    appName: 'My App (QA)',
    enableLogging: true,
    enableDebugFeatures: true,
  );
}
```

2. Add case in `flavor_config.dart`:
```dart
static AppFlavor get currentFlavor {
  return switch (flavorString.toLowerCase()) {
    'production' => AppFlavor.production,
    'staging' => AppFlavor.staging,
    'qa' => AppFlavor.qa,  // Add this
    _ => AppFlavor.development,
  };
}
```

3. Use it:
```bash
flutter run --dart-define=APP_FLAVOR=qa
```

---

## ✅ Best Practices

### 1. Always Use FlavorConfig

```dart
// ✅ Good - Uses flavor config
final url = FlavorConfig.apiBaseUrl;

// ❌ Bad - Hardcoded URL
final url = 'https://api.example.com';
```

### 2. Use Conditional Logging

```dart
// ✅ Good - Only logs if enabled
FlavorConfig.log('Debug message');

// ❌ Bad - Always logs
print('Debug message');
```

### 3. Initialize Early

```dart
// ✅ Good - Initialize first
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize();  // First!
  await initDependencyInjection();
  runApp(MyApp());
}

// ❌ Bad - Initialize after other things
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection();
  FlavorConfig.initialize();  // Too late!
  runApp(MyApp());
}
```

### 4. Test All Flavors

Always test your app in all flavors before releasing:
- ✅ Development
- ✅ Staging
- ✅ Production

### 5. Use Feature Flags

```dart
// ✅ Good - Feature flags based on flavor
if (FlavorConfig.enableDebugFeatures) {
  showDebugMenu();
}
```

### 6. Never Hardcode Environment-Specific Values

```dart
// ✅ Good
final apiUrl = FlavorConfig.apiBaseUrl;

// ❌ Bad
final apiUrl = kDebugMode 
  ? 'https://dev-api.com' 
  : 'https://api.com';
```

---

## 🔧 Troubleshooting

### Problem: Flavor Not Changing

**Symptoms:** App always runs in development mode

**Solutions:**
1. Check command syntax: `--dart-define=APP_FLAVOR=production` (no spaces around `=`)
2. Restart app completely (hot restart won't pick up flavor changes)
3. Clean build: `flutter clean && flutter pub get`
4. Verify in code: `print(FlavorConfig.currentFlavor.name)`

### Problem: Wrong API URL

**Symptoms:** App connects to wrong API

**Solutions:**
1. Check `app_flavor.dart` for correct URLs
2. Check if `API_BASE_URL` environment variable is overriding:
   ```bash
   # Remove this if you want to use flavor URL
   --dart-define=API_BASE_URL=...
   ```
3. Verify URL: `print(FlavorConfig.apiBaseUrl)`

### Problem: Logging Not Working

**Symptoms:** No logs appearing

**Solutions:**
1. Check `enableLogging` in `app_flavor.dart` for current flavor
2. Use `FlavorConfig.log()` not `print()`
3. Verify flavor: `print(FlavorConfig.currentFlavor.name)`
4. Check if logging is enabled: `print(FlavorConfig.enableLogging)`

### Problem: Debug Features Not Showing

**Symptoms:** Debug menu/features not appearing

**Solutions:**
1. Check `enableDebugFeatures` in `app_flavor.dart`
2. Verify flavor is development: `FlavorConfig.isDevelopment`
3. Check condition: `if (FlavorConfig.enableDebugFeatures) { ... }`

### Problem: App Name Not Changing

**Symptoms:** App name stays the same in all flavors

**Solutions:**
1. Check `appName` in `app_flavor.dart`
2. Restart app completely (not hot reload)
3. Check if app name is hardcoded in `AndroidManifest.xml` or `Info.plist`
4. Verify: `print(FlavorConfig.appName)`

### Problem: VS Code Launch Not Working

**Solutions:**
1. Check `.vscode/launch.json` syntax
2. Verify file is in project root
3. Restart VS Code
4. Check Flutter extension is installed

### Problem: Android Studio Configuration Not Working

**Solutions:**
1. Verify "Additional run args" field has correct syntax
2. Check for typos: `--dart-define=APP_FLAVOR=production`
3. Make sure configuration is saved (click Apply)
4. Restart Android Studio

---

## 📋 Quick Reference

### Commands

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=APP_FLAVOR=staging

# Production
flutter run --dart-define=APP_FLAVOR=production

# Build Production APK
flutter build apk --dart-define=APP_FLAVOR=production

# Build Production App Bundle
flutter build appbundle --dart-define=APP_FLAVOR=production

# Override API URL
flutter run --dart-define=APP_FLAVOR=development --dart-define=API_BASE_URL=https://custom.com
```

### Code Snippets

```dart
// Import
import 'core/flavor/flavor_config.dart';

// Get flavor
FlavorConfig.currentFlavor

// Get API URL
FlavorConfig.apiBaseUrl

// Check flavor
FlavorConfig.isDevelopment
FlavorConfig.isStaging
FlavorConfig.isProduction

// Logging
FlavorConfig.log('Message');
FlavorConfig.logError('Error', exception, stackTrace);

// Features
FlavorConfig.enableDebugFeatures
FlavorConfig.enableLogging
FlavorConfig.appName
```

### File Locations

- **Config Class**: `lib/core/flavor/flavor_config.dart`
- **Flavor Enum**: `lib/core/flavor/app_flavor.dart`

---

## 🎯 Summary

1. ✅ **Default**: If not specified, defaults to **development**
2. ✅ **Initialize**: Call `FlavorConfig.initialize()` in `main()`
3. ✅ **Use**: Access via `FlavorConfig.apiBaseUrl`, `FlavorConfig.isDevelopment`, etc.
4. ✅ **IDE Setup**: Configure VS Code or Android Studio for easy switching
5. ✅ **Test**: Always test all flavors before releasing

---

**Need Help?** Check the [Flutter Documentation on Build Modes](https://docs.flutter.dev/deployment/flavors)
