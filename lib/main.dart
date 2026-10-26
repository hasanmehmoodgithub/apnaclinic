import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apnaclinic/core/constants/app_system_ui.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/core/flavor/flavor_config.dart';
import 'package:flutter/rendering.dart';

import 'core/debug/device_preview_support.dart';
import 'core/di/dependency_injection.dart';
import 'core/analytics/first_install_analytics.dart';
import 'core/firebase/crashlytics_service.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/network/app_http_overrides.dart';
import 'core/preference/app_pref.dart';
import 'core/services/notification_service.dart';
import 'core/services/appsflyer_service.dart';
import 'core/utils/chucker_guard.dart';
import 'core/security/security_widget.dart';
import 'features/app/presentation/screens/apna_clinic_app.dart';

void main() {
  // Run app in a zone with error handling
  runZonedGuarded(
    () async {
      // Guard: Ensure Flutter binding is initialized first
      WidgetsFlutterBinding.ensureInitialized();
      debugRepaintRainbowEnabled = false;
      debugPaintSizeEnabled = false;
      debugPaintBaselinesEnabled = false;
      debugPaintPointersEnabled = false;
      debugPaintLayerBordersEnabled = false;
      ChuckerGuard.configureIfEnabled();
      FlavorConfig.initialize();
      HttpOverrides.global = AppHttpOverrides();
      await AppHttpOverrides.detectActiveProxy();
      AppSystemUi.apply();

      try {
        // Flavor already initialized above (needed before DI / Dio network config).
        await FirebaseBootstrap.initialize();
        await CrashlyticsService.configure();

        // Initialize dependency injection (includes AppPref initialization)
        // Encryption can be enabled/configured through AppPref methods after initialization
        await _initializeDependencyInjection();
        final savedUserId = sl<AppPref>().getUserId();
        if (savedUserId.isNotEmpty) {
          unawaited(CrashlyticsService.setUserId(savedUserId));
        }
        unawaited(FirstInstallAnalytics.logIfFirstTime());

        runApp(const SecurityGate(child: ApnaClinicApp()),
        );

        // FCM / AppsFlyer can hang or fail on some devices — never block first frame.
        unawaited(_initializePushNotifications());
        unawaited(_initializeAppsFlyer());
      } catch (e, stackTrace) {
        // Guard: Handle initialization errors gracefully
        developer.log(
          'Fatal error during app initialization: $e',
          name: 'main',
          error: e,
          stackTrace: stackTrace,
        );
        unawaited(
          CrashlyticsService.recordError(
            e,
            stackTrace,
            fatal: true,
            reason: 'app initialization',
          ),
        );

        // Show error screen in debug mode
        if (kDebugMode) {
          runApp(
            SecurityGate(
              child: MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.r,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Initialization Error',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.all(16.r),
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
            ),
          );
        } else {
          // In release mode, try to run app anyway (may work with fallbacks)
          runApp(const SecurityGate(child: ApnaClinicApp()));
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
      unawaited(
        CrashlyticsService.recordError(error, stackTrace, fatal: true),
      );
      // Avoid calling runApp here to prevent zone mismatch errors.
    },
  );
}

/// Initialize dependency injection with error handling
Future<void> _initializeDependencyInjection() async {
  try {
    developer.log('Initializing dependency injection...', name: 'main');
    await initDependencyInjection();
    developer.log(
      'Dependency injection initialized successfully',
      name: 'main',
    );
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

Future<void> _initializePushNotifications() async {
  final firebaseReady = await FirebaseBootstrap.initialize();
  if (!firebaseReady) {
    developer.log(
      'FCM disabled until Firebase is configured. Local permission runs on first frame.',
      name: 'main',
    );
    return;
  }

  try {
    developer.log('Initializing FCM...', name: 'main');
    final notificationService = sl<NotificationService>();
    await notificationService.initializeFcm();
    notificationService.setupBackgroundMessageHandler();
    developer.log('FCM initialized', name: 'main');
  } catch (e, stackTrace) {
    developer.log(
      'FCM init failed: $e',
      name: 'main',
      error: e,
      stackTrace: stackTrace,
    );
  }
}

Future<void> _initializeAppsFlyer() async {
  try {
    await sl<AppsFlyerService>().initialize();
    final savedUserId = sl<AppPref>().getUserId();
    if (savedUserId.isNotEmpty) {
      sl<AppsFlyerService>().setCustomerUserId(savedUserId);
    }
  } catch (e, stackTrace) {
    developer.log(
      'AppsFlyer init failed: $e',
      name: 'main',
      error: e,
      stackTrace: stackTrace,
    );
  }
}

