# Your Feature - Example Template

This is an example feature template following Clean Architecture principles.

## 📁 Structure

```
your_feature/
├── data/
│   ├── data_sources/      # Remote & Local data sources
│   ├── mappers/           # Model ↔ Entity converters
│   ├── models/            # Data models (JSON serialization)
│   └── repositories/      # Repository implementation
├── domain/
│   ├── entities/          # Domain entities (pure Dart)
│   ├── repositories/      # Repository interfaces
│   └── use_cases/         # Business logic
├── presentation/
│   ├── cubit/            # State management
│   ├── pages/            # UI pages
│   └── widgets/          # Feature widgets
└── your_feature_injection.dart  # Dependency injection
```

## 🚀 Quick Start

1. **Copy this folder** and rename to your feature name (e.g., `products`, `users`)

2. **Rename all files:**
   - `your_feature_*` → `your_new_feature_*`
   - `YourFeature*` → `YourNewFeature*`

3. **Update code:**
   - Update entity fields
   - Update model JSON methods
   - Update API endpoints
   - Update params

4. **Register dependencies:**
   - Add `initYourNewFeatureInjector()` to `lib/core/di/dependency_injection.dart`

5. **Generate freezed files:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## 📚 Full Guide

See [FEATURE_CREATION_GUIDE.md](../FEATURE_CREATION_GUIDE.md) for complete instructions.

## ✅ Features Included

- ✅ GET API call example
- ✅ POST API call example
- ✅ Local data fallback (SharedPreferences)
- ✅ Clean Architecture structure
- ✅ Dependency Injection setup
- ✅ State management with Cubit
- ✅ Error handling

---

**Note:** This is a template. Copy and modify for your actual features.
