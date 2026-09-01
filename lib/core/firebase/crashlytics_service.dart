import 'dart:developer' as developer;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../flavor/flavor_config.dart';
import 'firebase_bootstrap.dart';

/// Reports crashes to Firebase Crashlytics. No-op until [FirebaseBootstrap]
/// has initialized. Collection is disabled in debug so local runs stay quiet.
class CrashlyticsService {
  CrashlyticsService._();

  static FirebaseCrashlytics? get _ready {
    if (!FirebaseBootstrap.isInitialized) return null;
    return FirebaseCrashlytics.instance;
  }

  /// Enables collection (release/profile), tags flavor, and installs Flutter
  /// / platform error handlers.
  static Future<void> configure() async {
    final crashlytics = _ready;
    if (crashlytics == null) return;

    try {
      await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
      await crashlytics.setCustomKey(
        'flavor',
        FlavorConfig.currentFlavor.name,
      );

      FlutterError.onError = (details) {
        crashlytics.recordFlutterFatalError(details);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e, stackTrace) {
      developer.log(
        'Crashlytics configure failed',
        name: 'CrashlyticsService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    final crashlytics = _ready;
    if (crashlytics == null) return;
    try {
      await crashlytics.recordError(
        error,
        stackTrace,
        fatal: fatal,
        reason: reason,
      );
    } catch (e, st) {
      developer.log(
        'recordError failed',
        name: 'CrashlyticsService',
        error: e,
        stackTrace: st,
      );
    }
  }

  static Future<void> setUserId(String? userId) async {
    final crashlytics = _ready;
    if (crashlytics == null) return;
    try {
      final id = userId?.trim() ?? '';
      await crashlytics.setUserIdentifier(id);
    } catch (e, stackTrace) {
      developer.log(
        'setUserId failed',
        name: 'CrashlyticsService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
