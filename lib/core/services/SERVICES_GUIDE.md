# 🔧 Services Guide

Simple guide for creating and using services in your Flutter app.

---

## 📖 What are Services?

Services are reusable classes that provide specific functionality across your app:
- **ConnectivityService** - Check network connectivity
- **EncryptionService** - Handle encryption/decryption
- **AnalyticsService** - Track events
- **LocationService** - Get device location
- **NotificationService** - Send notifications

---

## ➕ Adding a New Service

### Step 1: Create Service File

Create: `lib/core/services/[service_name]_service.dart`

**Example: LocationService**

```dart
import 'package:geolocator/geolocator.dart';

/// Service to get device location
class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      // Get location
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  /// Get location stream
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream();
  }
}
```

### Step 2: Register in Dependency Injection

Edit: `lib/core/di/dependency_injection.dart`

```dart
import '../services/location_service.dart';

Future<void> _initCore() async {
  // ... existing services ...
  
  // Register new service
  sl.registerLazySingleton<LocationService>(() => LocationService());
}
```

### Step 3: Use in Code

```dart
import 'core/di/dependency_injection.dart';
import 'core/services/location_service.dart';

// Get service
final locationService = sl<LocationService>();

// Use service
final location = await locationService.getCurrentLocation();
```

---

## 🎯 When to Use Services

### ✅ Use Services For:

1. **Platform-Specific Functionality**
   - Network connectivity
   - Device location
   - Camera access
   - File system operations

2. **Reusable Business Logic**
   - Data validation
   - Formatting
   - Calculations
   - Transformations

3. **External Integrations**
   - Analytics (Firebase, etc.)
   - Push notifications
   - Payment processing
   - Social media APIs

4. **Cross-Feature Functionality**
   - Logging
   - Error reporting
   - Caching
   - Authentication

### ❌ Don't Use Services For:

1. **UI-Specific Logic** - Use widgets or state management
2. **Feature-Specific Logic** - Use repositories or use cases
3. **Simple Utilities** - Use helper functions or extensions
4. **One-Time Operations** - Use functions directly

---

## 📁 Service Structure

### Basic Service Template

```dart
/// Service description
class MyService {
  /// Method description
  Future<ReturnType> doSomething() async {
    try {
      // Implementation
      return result;
    } catch (e) {
      // Error handling
      throw Exception('Error: $e');
    }
  }

  /// Synchronous method
  String getSomething() {
    return 'value';
  }

  /// Stream method
  Stream<DataType> watchSomething() {
    return stream;
  }
}
```

### Service with Dependencies

```dart
class MyService {
  final ApiClient _apiClient;
  final AppPref _appPref;

  MyService({
    required ApiClient apiClient,
    required AppPref appPref,
  }) : _apiClient = apiClient,
       _appPref = appPref;

  Future<void> doSomething() async {
    final token = _appPref.getToken();
    final response = await _apiClient.get('/endpoint');
    // ...
  }
}
```

---

## 💻 Using Services

### Method 1: Dependency Injection (Recommended)

```dart
import 'core/di/dependency_injection.dart';
import 'core/services/connectivity_service.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get service
    final connectivityService = sl<ConnectivityService>();
    
    return FutureBuilder<bool>(
      future: connectivityService.hasInternetConnection(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Text('Connected');
        }
        return Text('No Connection');
      },
    );
  }
}
```

### Method 2: Constructor Injection

```dart
class MyRepository {
  final ConnectivityService _connectivityService;

  MyRepository(this._connectivityService);

  Future<void> fetchData() async {
    final hasConnection = await _connectivityService.hasInternetConnection();
    if (!hasConnection) {
      throw Exception('No internet connection');
    }
    // Fetch data...
  }
}
```

### Method 3: Using Streams

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void initState() {
    super.initState();
    final connectivityService = sl<ConnectivityService>();
    
    _subscription = connectivityService.connectivityStream.listen((results) {
      setState(() {
        // Update UI based on connectivity
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## ✅ Best Practices

### 1. Keep Services Focused

```dart
// ✅ Good - Single responsibility
class ConnectivityService {
  Future<bool> hasInternetConnection() { }
}

// ❌ Bad - Multiple responsibilities
class NetworkService {
  Future<bool> hasInternetConnection() { }
  Future<Location> getLocation() { }
  void sendNotification() { }
}
```

### 2. Use Dependency Injection

```dart
// ✅ Good - Registered in DI
sl.registerLazySingleton<MyService>(() => MyService());
final service = sl<MyService>();

// ❌ Bad - Direct instantiation
final service = MyService();
```

### 3. Handle Errors Properly

```dart
// ✅ Good - Error handling
Future<Result?> getData() async {
  try {
    return await fetchData();
  } catch (e) {
    // Log error
    return null;
  }
}

// ❌ Bad - No error handling
Future<Result> getData() async {
  return await fetchData(); // Can throw
}
```

### 4. Make Services Testable

```dart
// ✅ Good - Can be mocked
class MyService {
  final ApiClient _apiClient;
  
  MyService(this._apiClient);
  
  Future<Data> fetch() => _apiClient.get('/data');
}

// ❌ Bad - Hard to test
class MyService {
  Future<Data> fetch() {
    final client = ApiClient(); // Hard-coded dependency
    return client.get('/data');
  }
}
```

---

## 📋 Quick Reference

### Create Service
1. Create file: `lib/core/services/[name]_service.dart`
2. Implement service class
3. Register in DI: `sl.registerLazySingleton<Service>(() => Service());`
4. Use: `final service = sl<Service>();`

### Service Template
```dart
class MyService {
  Future<ReturnType> method() async {
    try {
      // Implementation
      return result;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

### Files
- **Services**: `lib/core/services/`
- **DI Registration**: `lib/core/di/dependency_injection.dart`

---

## 🎯 Summary

1. ✅ **Create** service in `lib/core/services/`
2. ✅ **Register** in dependency injection
3. ✅ **Use** via `sl<Service>()`
4. ✅ **Keep** services focused and testable
5. ✅ **Use** for reusable, cross-feature functionality

---

That's it! Simple and easy. 🔧
