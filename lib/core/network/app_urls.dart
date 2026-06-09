import '../flavor/flavor_config.dart';

/// Centralized API endpoints for the application
/// Supports both full URLs (with baseUrl from flavor) and 3rd party full URLs
class AppUrls {
  AppUrls._();

  /// Get base URL from flavor configuration
  static String get baseUrl => FlavorConfig.apiBaseUrl;



  /// Mobile API key for CMS/aggregator guest access. Override: `--dart-define=MOBILE_API_KEY=...`
  static const String mobileApiKey = String.fromEnvironment(
    'MOBILE_API_KEY',
    defaultValue:
        'apk_426baebf7f6eeb2962d120583b66827f354da3f09c86ac27c4d673e5823dd772',
  );


  static String get _normalizedApiBaseUrl =>
      baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

  // ============================================
  // Auth endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Login endpoint - full URL using baseUrl from flavor
  static String get login => '$baseUrl/acs-auth/login';

  /// Request OTP endpoint
  static String get requestOtp =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/auth/otp/generate';

  /// Logout endpoint — `{userId}` is the authenticated user id from prefs/JWT.
  static String logout(String userId) =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/auth/logout/$userId';

  /// Refresh token endpoint - full URL
  static String get refreshToken =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/auth/token/refresh';

  /// Verify OTP endpoint
  static String get verifyOtp =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/auth/otp/verify';

  // ============================================
  // Products endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Products list endpoint - full URL
  static String get products => 'https://dummyjson.com/products';

  /// Home services (CMS mobile API).
  static String get ourServices =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/services';

  /// Doctor consultation categories (aggregator mobile API).
  static String get doctorCategories =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-categories';

  /// Doctor consultation doctors for a main category (aggregator mobile API).
  static String doctorConsultationDoctors(String mainCategoryId) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/doctors?mainCategoryId=${Uri.encodeComponent(mainCategoryId)}';

  /// Supported cities for lab and surgery (aggregator mobile API).
  static String get cities =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/cities';

  /// Home promotional banner(s) — CMS mobile API (first active item by displayOrder).
  static String get promotionalBanner =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/banners';

  /// Customer support settings — CMS mobile API.
  static String get mobileSupport =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/support';

  /// Free doctor screen content endpoint
  static String get freeDoctor => '$_normalizedApiBaseUrl/dashboard/free-doctor';

  /// Profile setup details endpoint
  static String userProfileById(String userId) =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/users/$userId';

  /// Save profile setup endpoint
  static String get saveProfileSetup =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/users/';

  /// Notifications endpoint
  static String get notifications => '$_normalizedApiBaseUrl/notifications';

  /// Pharmacy medicines endpoint
  static String get pharmacyMedicines => '$_normalizedApiBaseUrl/pharmacy/medicines';

  /// Pharmacy cart endpoint
  static String get pharmacyCart => '$_normalizedApiBaseUrl/pharmacy/cart';

  /// Pharmacy add-to-cart endpoint
  static String get pharmacyAddToCart => '$_normalizedApiBaseUrl/pharmacy/cart/add';

  /// Search endpoint
  static String get search => '$_normalizedApiBaseUrl/search';

  /// Surgery procedures list (aggregator mobile API).
  static String get surgeryProcedures =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/surgery/list';

  /// Surgery providers for a procedure (aggregator mobile API).
  static String surgeryProviders(String surgeryId) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/surgery/providers?surgeryId=${Uri.encodeComponent(surgeryId)}';
  static String surgeryPatientForm(String doctorId) =>
      '$_normalizedApiBaseUrl/surgery/patient-form/$doctorId';
  static String get surgeryBooking => '$_normalizedApiBaseUrl/surgery/booking';
  static String get labTestCatalog => '$_normalizedApiBaseUrl/lab/test';

  // ============================================
  // 3rd Party Integration Support (Full URLs)
  // ============================================

  /// Use full URL for 3rd party integrations
  /// Example: AppUrls.thirdPartyUrl('https://api.thirdparty.com/endpoint')
  /// This returns the URL as-is for complete 3rd party integration


  // ============================================
  // Legal / policy pages (full URLs)
  // ============================================

  static const String termsAndConditions =
      'https://apnaclinic.ecnstg.com/terms';

  static const String privacyPolicy =
      'https://apnaclinic.ecnstg.com/privacy-policy';
}
