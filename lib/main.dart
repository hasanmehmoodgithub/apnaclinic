import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apnaclinic/core/constants/app_system_ui.dart';
import 'package:apnaclinic/core/flavor/flavor_config.dart';

import 'core/di/dependency_injection.dart';
import 'core/security/security_widget.dart';
import 'features/app/presentation/screens/apna_clinic_app.dart';

void main() {
  // Run app in a zone with error handling
  runZonedGuarded(
    () async {
      // Guard: Ensure Flutter binding is initialized first
      WidgetsFlutterBinding.ensureInitialized();
      AppSystemUi.apply();

      try {
        // Initialize flavor-specific configurations
        FlavorConfig.initialize();

        // Initialize dependency injection (includes AppPref initialization)
        // Encryption can be enabled/configured through AppPref methods after initialization
        await _initializeDependencyInjection();

        // Initialize Firebase (required for notifications)
        // TODO: Add your firebase_options.dart file after running:
        // flutter pub add firebase_core
        // flutterfire configure
        // Then uncomment:
        // await _initializeFirebase();

        // Initialize notification service
        // TODO: Uncomment after Firebase is initialized
        // await _initializeNotificationService();

        // Run app with security guard in release mode
        runApp(
          kDebugMode
              ? const ApnaClinicApp()
              : SecurityGate(child: const ApnaClinicApp()),
        );
      } catch (e, stackTrace) {
        // Guard: Handle initialization errors gracefully
        developer.log(
          'Fatal error during app initialization: $e',
          name: 'main',
          error: e,
          stackTrace: stackTrace,
        );

        // Show error screen in debug mode
        if (kDebugMode) {
          runApp(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Initialization Error',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // In release mode, try to run app anyway (may work with fallbacks)
          runApp(const ApnaClinicApp());
        }
      }
    },
    // Error handler for unhandled errors in the zone
    (error, stackTrace) {
      developer.log(
        'Unhandled error in zone: $error',
        name: 'main',
        error: error,
        stackTrace: stackTrace,
      );

      // In debug mode, show error screen
      if (kDebugMode) {
        runApp(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Unhandled Error',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      // In release mode, errors are logged but app continues
    },
  );
}

/// Initialize dependency injection with error handling
Future<void> _initializeDependencyInjection() async {
  try {
    developer.log('Initializing dependency injection...', name: 'main');
    await initDependencyInjection();
    developer.log('Dependency injection initialized successfully', name: 'main');
  } catch (e, stackTrace) {
    developer.log(
      'Error initializing dependency injection: $e',
      name: 'main',
      error: e,
      stackTrace: stackTrace,
    );
    // Re-throw to be caught by main guard
    rethrow;
  }
}

// TODO: Uncomment and use after running flutterfire configure
// /// Initialize Firebase with error handling
// Future<void> _initializeFirebase() async {
//   try {
//     developer.log('Initializing Firebase...', name: 'main');
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     developer.log('Firebase initialized successfully', name: 'main');
//   } catch (e, stackTrace) {
//     developer.log(
//       'Error initializing Firebase: $e',
//       name: 'main',
//       error: e,
//       stackTrace: stackTrace,
//     );
//     // Don't rethrow - Firebase is optional for basic app functionality
//   }
// }

// TODO: Uncomment and use after Firebase is initialized
// /// Initialize notification service with error handling
// Future<void> _initializeNotificationService() async {
//   try {
//     developer.log('Initializing notification service...', name: 'main');
//     final notificationService = NotificationService();
//     await notificationService.initialize();
//     notificationService.setupBackgroundMessageHandler();
//     developer.log('Notification service initialized successfully', name: 'main');
//   } catch (e, stackTrace) {
//     developer.log(
//       'Error initializing notification service: $e',
//       name: 'main',
//       error: e,
//       stackTrace: stackTrace,
//     );
//     // Don't rethrow - Notifications are optional
//   }
// }
