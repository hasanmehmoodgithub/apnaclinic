# 📊 Firebase Analytics Integration Guide

This document explains how to initialize and use **Firebase Analytics** in your Flutter app with a reusable service class and dependency injection via **GetIt**.

---

## 🧱 1. Dependencies

Add these packages to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.0.0
  firebase_analytics: ^11.0.0
  get_it: ^8.0.0
```

## ⚙️ 2. Initialize Firebase

In your `main.dart` file:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initDependencyInjection();
  runApp(MyApp());
}
```

## 🧩 3. Setup Service Locator

File: `lib/core/di/dependency_injection.dart`

Add Firebase Analytics registration in the `_initCore()` method:

```dart
import 'package:get_it/get_it.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../analytics/firebase_analytics_service.dart';

// Inside _initCore() method:
Future<void> _initCore() async {
  // ... existing code ...
  
  // Register Firebase Analytics
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  
  sl.registerLazySingleton<FirebaseAnalyticsService>(
    () => FirebaseAnalyticsService(sl<FirebaseAnalytics>()),
  );
  
  // ... rest of existing code ...
}
```

## 🧠 4. Create Analytics Service

File: `lib/core/analytics/firebase_analytics_service.dart`

Uncomment and configure the service:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:developer' as dev;

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService(this._analytics);

  /// Logs an event dynamically.
  ///
  /// [eventName] — The event key (e.g., "post_liked")
  /// [parameters] — Optional key-value pairs for event metadata.
  Future<void> logEvent({
    required String eventName,
    Map<String, Object?>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      dev.log('Firebase event logged: $eventName, params: $parameters');
    } catch (e) {
      dev.log('Error logging event [$eventName]: $e');
    }
  }

  /// Logs screen views (optional but common for analytics)
  Future<void> logScreen({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
    dev.log('Screen logged: $screenName');
  }

  /// Assigns a Firebase user ID
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
    dev.log('Firebase user ID set: $userId');
  }

  /// Assigns a custom user property
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
    dev.log('User property set: $name = $value');
  }
}
```

## 🚀 5. Usage Examples

### ✅ Log an event

```dart
import 'core/di/dependency_injection.dart';
import 'core/analytics/firebase_analytics_service.dart';

void onPostLiked(String postId, String userId) {
  sl<FirebaseAnalyticsService>().logEvent(
    eventName: 'post_liked',
    parameters: {
      'post_id': postId,
      'user_id': userId,
    },
  );
}
```

### ✅ Log screen view

```dart
sl<FirebaseAnalyticsService>().logScreen(
  screenName: 'MarketplaceScreen',
  screenClass: 'MarketplacePage',
);
```

### ✅ Set user ID

```dart
sl<FirebaseAnalyticsService>().setUserId('user_789');
```

### ✅ Set user property

```dart
sl<FirebaseAnalyticsService>().setUserProperty(
  name: 'membership',
  value: 'premium',
);
```

## 🧩 6. (Optional) Event Key Constants

Keep all your event names organized in one place:

File: `lib/core/analytics/firebase_event_keys.dart`

```dart
class FirebaseEventKeys {
  static const String postLiked = 'post_liked';
  static const String postCreated = 'post_created';
  static const String signup = 'signup';
  static const String login = 'login';
  static const String customEventKey = 'custom_event_key_1';
}
```

Usage:

```dart
sl<FirebaseAnalyticsService>().logEvent(
  eventName: FirebaseEventKeys.signup,
  parameters: {'method': 'email'},
);
```

## 🧾 Summary

✅ One-time setup for analytics  
✅ Centralized, reusable logging  
✅ Type-safe with event keys  
✅ Works across the app via GetIt  
✅ Supports screen tracking, user IDs, and custom properties

---

## 📝 Notes

- The `FirebaseAnalyticsService` is currently commented out in the codebase. Uncomment it when you're ready to use Firebase Analytics.
- Make sure to configure Firebase for your platform (iOS, Android, Web) before using this service.
- Event names should follow Firebase naming conventions (lowercase, underscores).
- User properties are limited to 25 per user.
