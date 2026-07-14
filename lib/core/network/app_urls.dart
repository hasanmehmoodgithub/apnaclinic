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


  /// Request OTP endpoint
  static String get requestOtp =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/auth/otp/generate';

  /// Logout endpoint.
  static String get logout =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/auth/logout';

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
  static String doctorConsultationDoctors({
    required String mainCategoryId,
    String? partnerId,
    String? search,
    int page = 1,
    int limit = 20,
  }) {
    final query = <String>[
      'mainCategoryId=${Uri.encodeComponent(mainCategoryId)}',
      'page=${Uri.encodeComponent(page.toString())}',
      'limit=${Uri.encodeComponent(limit.toString())}',
    ];
    final trimmedPartnerId = partnerId?.trim();
    if (trimmedPartnerId != null && trimmedPartnerId.isNotEmpty) {
      query.add('partnerId=${Uri.encodeComponent(trimmedPartnerId)}');
    }
    final trimmedSearch = search?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      query.add('search=${Uri.encodeComponent(trimmedSearch)}');
    }
    return '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/doctors?${query.join('&')}';
  }

  /// Doctor consultation doctor details + availability (aggregator mobile API).
  /// `GET /acs-aggregator/api/v1/mobile/doctor-consultation/doctor/{doctorId}`
  static String doctorConsultationSlots({
    required String doctorId,
    String? hospitalId,
  }) {
    final base =
        '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/doctor/${Uri.encodeComponent(doctorId)}';
    if (hospitalId == null || hospitalId.trim().isEmpty) return base;
    return '$base?hospitalId=${Uri.encodeComponent(hospitalId.trim())}';
  }

  /// Doctor consultation booking (aggregator mobile API).
  static String get doctorConsultationBooking =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/book-consultation';

  /// Paginated list of subscriber's booked doctor consultations (aggregator mobile API).
  static String doctorConsultationBookings({
    int page = 1,
    int limit = 20,
  }) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation?page=$page&limit=$limit';

  /// Payment providers for consultation checkout (aggregator mobile API).
  static String get paymentProviders =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/payment-provider';

  /// Supported cities for lab and surgery (aggregator mobile API).
  static String get cities =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/cities';

  /// Home promotional banner(s) — CMS mobile API (first active item by displayOrder).
  static String get promotionalBanner =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/banners';

  /// Customer support settings — CMS mobile API.
  static String get mobileSupport =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/support';

  /// Instant doctor consultation info (aggregator mobile API).
  static String instantDoctorConsultation(String msisdn) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/instant?msisdn=${Uri.encodeComponent(msisdn)}';

  /// Instant doctor subscription OTP — send.
  static String get instantDoctorSendOtp =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/instant/send-otp';

  /// Instant doctor subscription OTP — verify.
  static String get instantDoctorVerifyOtp =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/instant/verify-otp';

  /// Instant doctor subscription — cancel.
  static String get instantDoctorCancelSubscription =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/instant/cancel-subscription';

  /// Profile setup details endpoint
  static String userProfileById(String userId) =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/users/$userId';

  /// Add a linked phone on the user profile.
  static String userPhone(String userId) =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/users/$userId/phone';

  /// Delete a linked phone by record id.
  static String deleteUserPhone(String userId, String phoneId) =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/users/$userId/phone/$phoneId';

  /// Save profile setup endpoint
  static String get saveProfileSetup =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/users/';

  /// Notifications endpoint
  static String get notifications => '$_normalizedApiBaseUrl/notifications';

  /// Pharmacy partner products list (POST, paginated).
  static String get pharmacyProducts =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/products';

  /// Pharmacy partner product detail (POST).
  static String get pharmacyProductDetail =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/product/details';

  /// Legacy placeholder — prefer [pharmacyProducts].
  static String get pharmacyMedicines => pharmacyProducts;

  /// Pharmacy active cart (POST).
  static String get pharmacyCart =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/cart/active';

  /// Pharmacy add-to-cart (POST).
  static String get pharmacyAddToCart =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/cart/add';

  /// Pharmacy cart quantity update (POST).
  static String get pharmacyUpdateCartQuantity =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/cart/quantity/update';

  /// Pharmacy order checkout (POST).
  static String get pharmacyOrderCheckout =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/order/checkout';

  /// Search endpoint
  static String get search => '$_normalizedApiBaseUrl/search';

  /// Surgery procedures list (aggregator mobile API).
  static String surgeryProcedures({String? cityId}) {
    final base =
        '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/surgery/list';
    if (cityId == null || cityId.isEmpty) return base;
    return '$base?cityId=${Uri.encodeComponent(cityId)}';
  }

  /// Surgery providers for a procedure (aggregator mobile API).
  static String surgeryProviders({
    required String surgeryId,
    required String cityId,
  }) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/surgery/providers?surgeryId=${Uri.encodeComponent(surgeryId)}&cityId=${Uri.encodeComponent(cityId)}';

  /// Surgery provider details with packages (aggregator mobile API).
  static String surgeryProviderDetails({
    required String surgeryId,
    required String cityId,
    required String doctorId,
  }) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/surgery/provider-details?surgeryId=${Uri.encodeComponent(surgeryId)}&cityId=${Uri.encodeComponent(cityId)}&doctorId=${Uri.encodeComponent(doctorId)}';

  static String surgeryPatientForm(String doctorId) =>
      '$_normalizedApiBaseUrl/surgery/patient-form/$doctorId';
  static String get surgeryBooking => '$_normalizedApiBaseUrl/surgery/booking';
  static String get labTestCatalog => '$_normalizedApiBaseUrl/lab/test';

  /// Paginated lab tests with available labs, sample type, and pricing.
  static String labTests({
    required String cityId,
    int page = 1,
    int limit = 20,
    String? search,
    String? labId,
  }) {
    final query = <String, String>{
      'cityId': cityId,
      'page': page.toString(),
      'limit': limit.clamp(1, 50).toString(),
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (labId != null && labId.trim().isNotEmpty) 'labId': labId.trim(),
    };
    final encoded = query.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/lab/tests?$encoded';
  }

  /// Lab test detail with per-partner labs and pricing for a city.
  static String labTestDetail({
    required int testId,
    required String cityId,
  }) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/lab/tests/$testId?cityId=${Uri.encodeComponent(cityId)}';

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

  static const String faq = 'https://apnaclinic.ecnstg.com/faq';

  static const String website = 'https://apnaclinic.ecnstg.com/';

  /// FikrFree on the App Store (iOS).
  static const String fikrFreeAppStoreIos =
      'https://apps.apple.com/pk/app/fikrfree/id6739287582';

  /// FikrFree on Google Play (Android).
  static const String fikrFreePlayStoreAndroid =
      'https://play.google.com/store/apps/details?id=com.fikrfree.android&hl=en';
}
