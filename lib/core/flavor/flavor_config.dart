import 'dart:developer' as dev;
import 'app_flavor.dart';

/// Flavor configuration - manages app flavors (development, staging, production)
/// 
/// Usage:
/// ```dart
/// // Initialize in main()
/// FlavorConfig.initialize();
/// 
/// // Get current flavor
/// final flavor = FlavorConfig.currentFlavor;
/// 
/// // Get API URL
/// final url = FlavorConfig.apiBaseUrl;
/// 
/// // Check flavor
/// if (FlavorConfig.isDevelopment) { }
/// ```
class FlavorConfig {
  FlavorConfig._(); // Private constructor to prevent instantiation

  /// Get current flavor from environment variable
  /// Defaults to 'development' if not specified
  static AppFlavor get currentFlavor {
    const flavorString = String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'Production',
    );

    return switch (flavorString.toLowerCase()) {
      'production' => AppFlavor.production,
      'staging' => AppFlavor.staging,
      _ => AppFlavor.development,
    };
  }

  /// Get API base URL (can be overridden via API_BASE_URL env var)
  static String get apiBaseUrl {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    return envBaseUrl.isNotEmpty ? envBaseUrl : currentFlavor.apiBaseUrl;
  }

  static const String _accountTestPhoneRaw = String.fromEnvironment(
    'ACCOUNT_TEST_PHONE',
    defaultValue: '',
  );

  static const String _sandboxPhoneRaw = String.fromEnvironment(
    'JAZZCASH_SANDBOX_PHONE',
    defaultValue: '',
  );

  /// JazzCash sandbox list number from dart-define. Used only when
  /// [isJazzCashSandbox] is true. Prefer `ACCOUNT_TEST_PHONE`, else
  /// `JAZZCASH_SANDBOX_PHONE`. Empty → do not inject a row.
  static String get jazzCashSandboxPhone {
    if (!isJazzCashSandbox) return '';
    final phone = _accountTestPhoneRaw.trim().isNotEmpty
        ? _accountTestPhoneRaw.trim()
        : _sandboxPhoneRaw.trim();
    return phone;
  }

  /// `--dart-define=JAZZCASH_SANDBOX=true` (alias: `jazzcashsandbox=true`).
  static bool get isJazzCashSandbox =>
      const bool.fromEnvironment('JAZZCASH_SANDBOX') ||
      const bool.fromEnvironment('jazzcashsandbox');

  /// Get app name for current flavor
  static String get appName => currentFlavor.appName;

  /// Check if logging is enabled
  static bool get enableLogging => currentFlavor.enableLogging;

  /// Check if debug features are enabled
  static bool get enableDebugFeatures => currentFlavor.enableDebugFeatures;

  /// AppsFlyer Dev Key for current flavor (empty until business fills it).
  static String get appsFlyerDevKey => currentFlavor.appsFlyerDevKey;

  /// AppsFlyer iOS App Store numeric id for current flavor.
  static String get appsFlyerIosAppId => currentFlavor.appsFlyerIosAppId;

  /// True when Dev Key is non-empty (iOS still needs [appsFlyerIosAppId] to start).
  static bool get isAppsFlyerConfigured => appsFlyerDevKey.trim().isNotEmpty;

  /// Check if current flavor is development
  static bool get isDevelopment => currentFlavor == AppFlavor.development;

  /// Check if current flavor is staging
  static bool get isStaging => currentFlavor == AppFlavor.staging;

  /// Check if current flavor is production
  static bool get isProduction => currentFlavor == AppFlavor.production;

  /// Log message (only if logging is enabled)
  static void log(String message) {
    if (enableLogging) {
      dev.log(message, name: currentFlavor.name);
    }
  }

  /// Log error (only if logging is enabled)
  static void logError(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (enableLogging) {
      dev.log(
        'ERROR: $message${error != null ? '\nError: $error' : ''}',
        name: currentFlavor.name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Initialize and print flavor info (call in main())
  static void initialize() {
    if (enableLogging) {
      log('App initialized with flavor: ${currentFlavor.name}');
      log('API Base URL: $apiBaseUrl');
      log('Debug features: $enableDebugFeatures');
    }
  }
}
