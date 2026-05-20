import '../flavor/flavor_config.dart';

/// Centralized API endpoints for the application
/// Supports both full URLs (with baseUrl from flavor) and 3rd party full URLs
class AppUrls {
  AppUrls._();

  /// Get base URL from flavor configuration
  static String get baseUrl => FlavorConfig.apiBaseUrl;

  static String get _normalizedApiBaseUrl =>
      baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

  // ============================================
  // Auth endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Login endpoint - full URL using baseUrl from flavor
  static String get login => '$baseUrl/login';

  /// Request OTP endpoint
  static String get requestOtp =>
      '$_normalizedApiBaseUrl/api/v1.0/user-auth/auth/otp/generate';

  /// Sign in endpoint - full URL with custom path
  static String get signIn => '$baseUrl/login_ww';

  /// Logout endpoint — `{userId}` is the authenticated user id from prefs/JWT.
  static String logout(String userId) =>
      '$_normalizedApiBaseUrl/api/v1.0/user-auth/auth/logout/$userId';

  /// Refresh token endpoint - full URL
  static String get refreshToken =>
      '$_normalizedApiBaseUrl/api/v1.0/user-auth/auth/token/refresh';

  /// Verify OTP endpoint
  static String get verifyOtp =>
      '$_normalizedApiBaseUrl/api/v1.0/user-auth/auth/otp/verify';

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
  static String userProfileById(String userId) =>
      '$_normalizedApiBaseUrl/api/v1.0/user-auth/users/$userId';

  /// Save profile setup endpoint
  static String get saveProfileSetup =>
      '$_normalizedApiBaseUrl/api/v1.0/user-auth/users/';

  /// Notifications endpoint
  static String get notifications => '$baseUrl/notifications';

  /// Pharmacy medicines endpoint
  static String get pharmacyMedicines => '$baseUrl/pharmacy/medicines';

  /// Pharmacy cart endpoint
  static String get pharmacyCart => '$baseUrl/pharmacy/cart';

  /// Pharmacy add-to-cart endpoint
  static String get pharmacyAddToCart => '$baseUrl/pharmacy/cart/add';

  /// Search endpoint
  static String get search => '$baseUrl/search';

  /// Surgery procedures endpoint
  static String get surgeryProcedures => '$baseUrl/surgery/procedures';
  static String get surgeryBooking => '$baseUrl/surgery/booking';
  static String get labTestCatalog => '$baseUrl/lab/test';

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

  // ============================================
  // Legal / policy pages (full URLs)
  // ============================================

  static const String termsAndConditions =
      'https://apnaclinic.ecnstg.com/terms';

  static const String privacyPolicy =
      'https://apnaclinic.ecnstg.com/privacy-policy';
}
