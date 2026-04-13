# 💉 Dependency Injection Guide

Complete guide for using GetIt dependency injection in your Flutter app.

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Initialization](#initialization)
4. [Registration Types](#registration-types)
5. [Adding a New Feature](#adding-a-new-feature)
6. [Using Dependencies](#using-dependencies)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This project uses **GetIt** for dependency injection. GetIt is a simple service locator that helps manage dependencies throughout your app.

### Benefits

- ✅ Centralized dependency management
- ✅ Easy testing (can mock dependencies)
- ✅ Lazy initialization (dependencies created only when needed)
- ✅ Type-safe dependency resolution
- ✅ Clean separation of concerns

### Service Locator

The service locator instance is available globally:

```dart
import 'core/di/dependency_injection.dart';

// Use 'sl' to access dependencies
final apiClient = sl<ApiClient>();
```

---

## 🚀 Quick Start

### 1. Initialize in main()

```dart
import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'core/flavor/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize flavor first
  FlavorConfig.initialize();
  
  // Initialize dependency injection
  await initDependencyInjection();
  
  runApp(MyApp());
}
```

### 2. Use Dependencies

```dart
import 'core/di/dependency_injection.dart';

// Get a dependency
final apiClient = sl<ApiClient>();
final appPref = sl<AppPref>();
```

---

## 📝 Initialization

### Current Core Dependencies

The following dependencies are registered in `_initCore()`:

| Dependency | Type | Description |
|------------|------|-------------|
| `EncryptionService` | LazySingleton | Encryption service for secure storage |
| `SharedPreferences` | LazySingleton | Local storage |
| `AppPref` | LazySingleton | App preferences (with encryption support) |
| `ApiClient` | LazySingleton | HTTP client for API calls |
| `AppDatabase` | LazySingleton | Local database (Drift) |
| `ConnectivityService` | LazySingleton | Network connectivity checker |

### Initialization Order

1. **FlavorConfig** - Initialize first (for configuration)
2. **Core Dependencies** - Register core services
3. **Feature Dependencies** - Register feature-specific dependencies

---

## 🔧 Registration Types

### `registerLazySingleton<T>`

Creates instance only when first accessed, then reuses it.

**Use for:**
- Repositories
- Data Sources
- Use Cases
- Services
- Singletons

**Example:**
```dart
sl.registerLazySingleton<ApiClient>(() => ApiClient());
sl.registerLazySingleton<AppPref>(
  () => AppPrefImpl(
    encryptionService: sl<EncryptionService>(),
    sharedPref: sl<SharedPreferences>(),
  ),
);
```

### `registerFactory<T>`

Creates new instance every time it's accessed.

**Use for:**
- Cubits
- BLoCs
- ViewModels
- Stateful widgets that need fresh instances

**Example:**
```dart
sl.registerFactory<LoginCubit>(
  () => LoginCubit(
    loginUseCase: sl<LoginUseCase>(),
  ),
);
```

### `registerSingleton<T>`

Creates instance immediately at registration time.

**Use for:**
- Services that need immediate initialization
- Services that must be available immediately

**Example:**
```dart
final database = AppDatabase();
sl.registerSingleton<AppDatabase>(database);
```

---

## ➕ Adding a New Feature

### Step 1: Create Feature Injection File

Create `lib/features/[feature_name]/[feature_name]_injection.dart`:

```dart
import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'data/data_sources/[feature]_remote_data_source.dart';
import 'data/data_sources/[feature]_remote_data_source_impl.dart';
import 'data/repositories/[feature]_repository_impl.dart';
import 'domain/repositories/[feature]_repository.dart';
import 'domain/use_cases/get_[feature].dart';
import 'domain/use_cases/create_[feature].dart';
import 'presentation/cubit/[feature]_cubit.dart';

void init[Feature]Injector() {
  // 1. Register Data Sources
  sl.registerLazySingleton<[Feature]RemoteDataSource>(
    () => [Feature]RemoteDataSourceImpl(
      apiClient: sl<ApiClient>(),
    ),
  );

  // 2. Register Repositories
  sl.registerLazySingleton<[Feature]Repository>(
    () => [Feature]RepositoryImpl(
      remoteDataSource: sl<[Feature]RemoteDataSource>(),
    ),
  );

  // 3. Register Use Cases
  sl.registerLazySingleton<Get[Feature]UseCase>(
    () => Get[Feature]UseCase(
      repository: sl<[Feature]Repository>(),
    ),
  );

  sl.registerLazySingleton<Create[Feature]UseCase>(
    () => Create[Feature]UseCase(
      repository: sl<[Feature]Repository>(),
    ),
  );

  // 4. Register Cubits/BLoCs (use registerFactory for fresh instances)
  sl.registerFactory<[Feature]Cubit>(
    () => [Feature]Cubit(
      get[Feature]UseCase: sl<Get[Feature]UseCase>(),
      create[Feature]UseCase: sl<Create[Feature]UseCase>(),
    ),
  );
}
```

### Step 2: Register in Main DI File

Add import and call the injector in `lib/core/di/dependency_injection.dart`:

```dart
import '../../features/[feature_name]/[feature_name]_injection.dart';

Future<void> initDependencyInjection() async {
  await _initCore();
  
  // Register feature dependencies
  init[Feature]Injector();
  
  // Add more feature injectors here
  // initAuthInjector();
  // initProductsInjector();
}
```

### Step 3: Use in UI

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/[feature]_cubit.dart';

// Option 1: Using BlocProvider
BlocProvider(
  create: (context) => sl<[Feature]Cubit>(),
  child: YourWidget(),
)

// Option 2: Using BlocProvider.value (if already created)
BlocProvider.value(
  value: sl<[Feature]Cubit>(),
  child: YourWidget(),
)
```

---

## 💻 Using Dependencies

### Resolving Dependencies

```dart
import 'core/di/dependency_injection.dart';

// Get a dependency
final apiClient = sl<ApiClient>();
final appPref = sl<AppPref>();
final database = sl<AppDatabase>();

// Get with type inference
final connectivityService = sl<ConnectivityService>();
```

### Using in Widgets

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get dependencies
    final appPref = sl<AppPref>();
    final apiClient = sl<ApiClient>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appPref.getAppName()),
      ),
      body: FutureBuilder(
        future: apiClient.get('/users'),
        builder: (context, snapshot) {
          // ...
        },
      ),
    );
  }
}
```

### Using in Cubits/BLoCs

```dart
class MyCubit extends Cubit<MyState> {
  final GetUsersUseCase _getUsersUseCase;
  
  MyCubit({
    required GetUsersUseCase getUsersUseCase,
  }) : _getUsersUseCase = getUsersUseCase,
       super(MyInitial());
  
  // Or inject directly
  MyCubit() : _getUsersUseCase = sl<GetUsersUseCase>(),
              super(MyInitial());
}
```

### Checking if Registered

```dart
if (sl.isRegistered<MyService>()) {
  final service = sl<MyService>();
}
```

### Resetting (for Testing)

```dart
// Reset all registrations
sl.reset();

// Reset lazy singletons only
sl.resetLazySingleton();
```

---

## ✅ Best Practices

### 1. Registration Order

Always register dependencies in this order:

1. **Data Sources** (RemoteDataSource, LocalDataSource)
2. **Repositories** (depends on Data Sources)
3. **Use Cases** (depends on Repositories)
4. **Cubits/BLoCs** (depends on Use Cases)

```dart
// ✅ Good - Correct order
sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());
sl.registerLazySingleton<Repository>(() => RepositoryImpl(sl<RemoteDataSource>()));
sl.registerLazySingleton<UseCase>(() => UseCase(sl<Repository>()));
sl.registerFactory<Cubit>(() => Cubit(sl<UseCase>()));

// ❌ Bad - Wrong order (will fail)
sl.registerFactory<Cubit>(() => Cubit(sl<UseCase>())); // UseCase not registered yet!
sl.registerLazySingleton<UseCase>(() => UseCase(sl<Repository>()));
```

### 2. Use LazySingleton for Services

```dart
// ✅ Good - Services should be singletons
sl.registerLazySingleton<ApiClient>(() => ApiClient());
sl.registerLazySingleton<AppPref>(() => AppPrefImpl());

// ❌ Bad - Don't use factory for services
sl.registerFactory<ApiClient>(() => ApiClient()); // Creates new instance each time!
```

### 3. Use Factory for Cubits/BLoCs

```dart
// ✅ Good - Cubits need fresh instances
sl.registerFactory<LoginCubit>(() => LoginCubit(useCase: sl<LoginUseCase>()));

// ❌ Bad - Don't use singleton for Cubits
sl.registerLazySingleton<LoginCubit>(() => LoginCubit(...)); // State persists!
```

### 4. Keep Feature Injectors Separate

```dart
// ✅ Good - Separate injector per feature
void initAuthInjector() { /* ... */ }
void initProductsInjector() { /* ... */ }

// ❌ Bad - Don't put everything in one file
// Keep it organized!
```

### 5. Initialize in Correct Order

```dart
// ✅ Good - Correct initialization order
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize();  // First
  await initDependencyInjection();  // Second
  runApp(MyApp());
}

// ❌ Bad - Wrong order
void main() async {
  await initDependencyInjection();  // Too early!
  FlavorConfig.initialize();
  runApp(MyApp());
}
```

### 6. Use Type-Safe Resolution

```dart
// ✅ Good - Type-safe
final apiClient = sl<ApiClient>();

// ❌ Bad - Not type-safe
final apiClient = sl(); // What type is this?
```

---

## 🔧 Common Patterns

### Adding a Service

```dart
// In _initCore() or feature injector
sl.registerLazySingleton<MyService>(() => MyService());
```

### Adding a Repository with Multiple Data Sources

```dart
sl.registerLazySingleton<RemoteDataSource>(
  () => RemoteDataSourceImpl(sl<ApiClient>()),
);

sl.registerLazySingleton<LocalDataSource>(
  () => LocalDataSourceImpl(sl<AppDatabase>()),
);

sl.registerLazySingleton<Repository>(
  () => RepositoryImpl(
    remoteDataSource: sl<RemoteDataSource>(),
    localDataSource: sl<LocalDataSource>(),
  ),
);
```

### Conditional Registration

```dart
if (!sl.isRegistered<MyService>()) {
  sl.registerLazySingleton<MyService>(() => MyService());
}
```

### Registering with Parameters

```dart
sl.registerLazySingleton<ApiClient>(
  () => ApiClient(
    baseUrl: FlavorConfig.apiBaseUrl,
  ),
);
```

---

## 🐛 Troubleshooting

### Error: "Object/factory with type X is not registered"

**Problem:** Trying to resolve a dependency that hasn't been registered.

**Solutions:**
1. Make sure you registered the dependency before using it
2. Check that you called the injector function in `initDependencyInjection()`
3. Verify the registration order (dependencies must be registered before dependents)
4. Check if you're using the correct type

```dart
// Check if registered
if (sl.isRegistered<MyService>()) {
  final service = sl<MyService>();
} else {
  print('MyService is not registered!');
}
```

### Error: "Circular dependency detected"

**Problem:** Two or more dependencies depend on each other.

**Solutions:**
1. Review your dependency graph
2. Consider using lazy initialization
3. Restructure dependencies to break the cycle
4. Use `registerLazySingleton` instead of `registerSingleton`

### Multiple Instances Created

**Problem:** Getting different instances when you expect the same one.

**Solutions:**
1. Use `registerLazySingleton` instead of `registerFactory` for services
2. Use `registerFactory` only for Cubits/BLoCs that need fresh instances
3. Check if you're registering the same type multiple times

```dart
// ✅ Good - Same instance
sl.registerLazySingleton<ApiClient>(() => ApiClient());
final client1 = sl<ApiClient>();
final client2 = sl<ApiClient>();
// client1 == client2 (same instance)

// ❌ Bad - Different instances
sl.registerFactory<ApiClient>(() => ApiClient());
final client1 = sl<ApiClient>();
final client2 = sl<ApiClient>();
// client1 != client2 (different instances)
```

### Dependency Not Available

**Problem:** Dependency is null or not initialized.

**Solutions:**
1. Make sure `initDependencyInjection()` was called in `main()`
2. Check that the dependency is registered in the correct injector
3. Verify initialization order

### Testing Issues

**Problem:** Dependencies not available in tests.

**Solutions:**
1. Call `initDependencyInjection()` in test setup
2. Use `sl.reset()` to clear registrations between tests
3. Register mock dependencies for testing

```dart
void main() {
  setUp(() {
    sl.reset();
    // Register test dependencies
    sl.registerLazySingleton<ApiClient>(() => MockApiClient());
  });

  tearDown(() {
    sl.reset();
  });
}
```

---

## 📋 Quick Reference

### Registration Methods

```dart
// Lazy Singleton (created on first access, reused)
sl.registerLazySingleton<T>(() => Implementation());

// Factory (new instance each time)
sl.registerFactory<T>(() => Implementation());

// Singleton (created immediately)
sl.registerSingleton<T>(Implementation());
```

### Resolution

```dart
// Get dependency
final service = sl<Service>();

// Check if registered
if (sl.isRegistered<Service>()) { }

// Reset
sl.reset();
sl.resetLazySingleton();
```

### File Structure

```
lib/
├── core/
│   └── di/
│       ├── dependency_injection.dart  # Main DI file
│       └── DI_GUIDE.md                # This file
└── features/
    └── [feature]/
        └── [feature]_injection.dart   # Feature injector
```

---

## 🎯 Summary

1. ✅ **Initialize**: Call `await initDependencyInjection()` in `main()`
2. ✅ **Register**: Use `registerLazySingleton` for services, `registerFactory` for Cubits
3. ✅ **Resolve**: Use `sl<T>()` to get dependencies
4. ✅ **Order**: Register in dependency order (Data Sources → Repositories → Use Cases → Cubits)
5. ✅ **Organize**: Keep feature injectors separate

---

**Need Help?** Check the [GetIt Documentation](https://pub.dev/packages/get_it)
