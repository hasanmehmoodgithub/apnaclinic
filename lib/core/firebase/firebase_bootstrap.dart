import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// Initializes Firebase once per process. Returns false when config is missing.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<bool> initialize() async {
    if (_initialized) return true;
    if (!DefaultFirebaseOptions.isConfigured) {
      developer.log(
        'Firebase skipped: run flutterfire configure and add platform config files.',
        name: 'FirebaseBootstrap',
      );
      return false;
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      developer.log('Firebase initialized', name: 'FirebaseBootstrap');
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Firebase initialization skipped: $e',
        name: 'FirebaseBootstrap',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
