import '../flavor/flavor_config.dart';

/// Centralized API endpoints for the application
/// Supports both full URLs (with baseUrl from flavor) and 3rd party full URLs
class AppUrls {
  AppUrls._();

  /// Get base URL from flavor configuration
  static String get baseUrl => FlavorConfig.apiBaseUrl;

  // ============================================
  // Auth endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Login endpoint - full URL using baseUrl from flavor
  static String get login => '$baseUrl/login';

  /// Request OTP endpoint
  static String get requestOtp => '$baseUrl/request-otp';

  /// Sign in endpoint - full URL with custom path
  static String get signIn => '$baseUrl/login_ww';

  /// Logout endpoint - full URL
  static String get logout => '$baseUrl/logout';

  /// Refresh token endpoint - full URL
  static String get refreshToken => '$baseUrl/refresh';

  /// Verify OTP endpoint - full URL
  static String get verifyOtp => '$baseUrl/verify-otp';

  // ============================================
  // Products endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Products list endpoint - full URL
  static String get products => 'https://dummyjson.com/products';

  /// Our services endpoint
  static String get ourServices => '$baseUrl/dashboard/services';

  /// Promotional banner endpoint
  static String get promotionalBanner => '$baseUrl/dashboard/promo-banner';

  /// Free doctor screen content endpoint
  static String get freeDoctor => '$baseUrl/dashboard/free-doctor';

  /// Customer support screen content endpoint
  static String get customerSupport => '$baseUrl/dashboard/customer-support';

  /// Profile setup details endpoint
  static String get profileSetup => '$baseUrl/profile/setup';

  /// Save profile setup endpoint
  static String get saveProfileSetup => '$baseUrl/profile/setup/save';

  /// Notifications endpoint
  static String get notifications => '$baseUrl/notifications';

  /// Pharmacy medicines endpoint
  static String get pharmacyMedicines => '$baseUrl/pharmacy/medicines';

  /// Search endpoint
  static String get search => '$baseUrl/search';

  /// Surgery procedures endpoint
  static String get surgeryProcedures => '$baseUrl/surgery/procedures';

  // ============================================
  // 3rd Party Integration Support (Full URLs)
  // ============================================

  /// Use full URL for 3rd party integrations
  /// Example: AppUrls.thirdPartyUrl('https://api.thirdparty.com/endpoint')
  /// This returns the URL as-is for complete 3rd party integration

  /// Google API endpoint - full 3rd party URL
  static String get googleApi => 'https://www.googleapis.com';

  /// Facebook API endpoint - full 3rd party URL
  static String get facebookApi => 'https://graph.facebook.com';




}
