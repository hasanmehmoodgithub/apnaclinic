import '../flavor/flavor_config.dart';

/// Centralized API endpoints for the application
/// Supports both full URLs (with baseUrl from flavor) and 3rd party full URLs
class AppUrls {
  AppUrls._();

  /// Get base URL from flavor configuration
  static String get baseUrl => FlavorConfig.apiBaseUrl;

  /// CMS backend. Override: `--dart-define=CMS_BASE_URL=...`
  static const String cmsBaseUrl = String.fromEnvironment(
    'CMS_BASE_URL',
    defaultValue: 'https://apnaclinic-cmsbackend.apps.jpocp.jazz.com.pk',
  );

  /// Aggregator backend. Override: `--dart-define=AGGREGATOR_BASE_URL=...`
  static const String aggregatorBaseUrl = String.fromEnvironment(
    'AGGREGATOR_BASE_URL',
    defaultValue: 'https://apnaclinic-aggregator.apps.jpocp.jazz.com.pk',
  );

  /// Mobile API key for CMS/aggregator guest access. Override: `--dart-define=MOBILE_API_KEY=...`
  static const String mobileApiKey = String.fromEnvironment(
    'MOBILE_API_KEY',
    defaultValue:
        'apk_426baebf7f6eeb2962d120583b66827f354da3f09c86ac27c4d673e5823dd772',
  );

  static String get _normalizedCmsBaseUrl => cmsBaseUrl.endsWith('/')
      ? cmsBaseUrl.substring(0, cmsBaseUrl.length - 1)
      : cmsBaseUrl;

  static String get _normalizedAggregatorBaseUrl =>
      aggregatorBaseUrl.endsWith('/')
          ? aggregatorBaseUrl.substring(0, aggregatorBaseUrl.length - 1)
          : aggregatorBaseUrl;

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

  /// Home services (CMS mobile API).
  static String get ourServices =>
      '$_normalizedCmsBaseUrl/api/v1/mobile/services';

  /// Doctor consultation categories (aggregator mobile API).
  static String get doctorCategories =>
      '$_normalizedAggregatorBaseUrl/api/v1/mobile/doctor-categories';

  /// Doctor consultation doctors for a main category (aggregator mobile API).
  static String doctorConsultationDoctors(String mainCategoryId) =>
      '$_normalizedAggregatorBaseUrl/api/v1/mobile/doctor-consultation/doctors?mainCategoryId=${Uri.encodeComponent(mainCategoryId)}';

  /// Home promotional banner(s) — CMS mobile API (first active item by displayOrder).
  static String get promotionalBanner =>
      '$_normalizedCmsBaseUrl/api/v1/mobile/banners';

  /// Customer support settings — CMS mobile API.
  static String get mobileSupport =>
      '$_normalizedCmsBaseUrl/api/v1/mobile/support';

  /// Free doctor screen content endpoint
  static String get freeDoctor => '$baseUrl/dashboard/free-doctor';

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

  /// Surgery procedures list (aggregator mobile API).
  static String get surgeryProcedures =>
      '$_normalizedAggregatorBaseUrl/api/v1/mobile/surgery/list';

  /// Surgery providers for a procedure (aggregator mobile API).
  static String surgeryProviders(String surgeryId) =>
      '$_normalizedAggregatorBaseUrl/api/v1/mobile/surgery/providers?surgeryId=${Uri.encodeComponent(surgeryId)}';
  static String surgeryPatientForm(String doctorId) =>
      '$baseUrl/surgery/patient-form/$doctorId';
  static String get surgeryBooking => '$baseUrl/surgery/booking';
  static String get labTestCatalog => '$baseUrl/lab/test';

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
