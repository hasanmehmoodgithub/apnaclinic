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
