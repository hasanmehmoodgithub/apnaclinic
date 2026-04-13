# Your MVVM Feature - Example Template

This is an example feature template following MVVM (Model-View-ViewModel) architecture.

## 📁 Structure

```
your_mvvm_feature/
├── model/
│   └── your_mvvm_model.dart          # Data model (JSON serialization)
├── data/
│   ├── data_sources/                  # Remote & Local data sources
│   │   ├── your_mvvm_remote_data_source.dart
│   │   ├── your_mvvm_remote_data_source_impl.dart
│   │   ├── your_mvvm_local_data_source.dart
│   │   └── your_mvvm_local_data_source_impl.dart
│   └── repositories/
│       └── your_mvvm_repository.dart  # Repository (combines remote & local)
├── viewmodel/
│   ├── your_mvvm_cubit.dart          # ViewModel (state management)
│   ├── your_mvvm_state.dart          # State class
│   └── your_mvvm_state.freezed.dart  # Generated (run build_runner)
├── view/
│   ├── pages/                         # UI pages
│   └── widgets/                       # Feature widgets
└── your_mvvm_injection.dart          # Dependency injection
```

## 🚀 Quick Start

1. **Copy this folder** and rename to your feature name (e.g., `products`, `users`)

2. **Rename all files:**
   - `your_mvvm_*` → `your_new_feature_*`
   - `YourMvvm*` → `YourNewFeature*`

3. **Update code:**
   - Update model fields
   - Update API endpoints
   - Update repository methods

4. **Register dependencies:**
   - Add `initYourNewFeatureInjector()` to `lib/core/di/dependency_injection.dart`

5. **Generate freezed files:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## ✅ Features Included

- ✅ GET API call example
- ✅ POST API call example
- ✅ Local data fallback (SharedPreferences)
- ✅ MVVM architecture structure
- ✅ Dependency Injection setup
- ✅ State management with Cubit
- ✅ Error handling

## 🎯 MVVM vs Clean Architecture

**MVVM (Simpler):**
- Model: Data models
- View: UI (pages, widgets)
- ViewModel: State management (Cubit)

**Clean Architecture (More structured):**
- Domain: Entities, Use Cases, Repository interfaces
- Data: Models, Data Sources, Repository implementations
- Presentation: Pages, Widgets, Cubit/State

---

**Note:** This is a template. Copy and modify for your actual features.
