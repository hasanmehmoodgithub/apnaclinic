import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// Initializes Firebase once per isolate. Returns false when config is missing.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _initialized = false;
  static Future<bool>? _inFlight;

  static bool get isInitialized => _initialized;

  static Future<bool> initialize() {
    if (_initialized) return Future.value(true);
    return _inFlight ??= _initialize();
  }

  static Future<bool> _initialize() async {
    try {
      if (!DefaultFirebaseOptions.isConfigured) {
        developer.log(
          'Firebase skipped: run flutterfire configure and add platform config files.',
          name: 'FirebaseBootstrap',
        );
        return false;
      }

      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      _initialized = true;
      developer.log('Firebase initialized', name: 'FirebaseBootstrap');
      return true;
    } on FirebaseException catch (e, stackTrace) {
      if (e.code == 'duplicate-app') {
        _initialized = true;
        developer.log(
          'Firebase already initialized natively',
          name: 'FirebaseBootstrap',
        );
        return true;
      }
      developer.log(
        'Firebase initialization skipped: $e',
        name: 'FirebaseBootstrap',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    } catch (e, stackTrace) {
      developer.log(
        'Firebase initialization skipped: $e',
        name: 'FirebaseBootstrap',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    } finally {
      _inFlight = null;
    }
  }
}
