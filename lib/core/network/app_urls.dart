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
        'apk_934ed1e09a11c361c786fb685fa21af3930e9805d9de44aaa078ea9db73da464',
  );

  static String get _normalizedApiBaseUrl => baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;

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

  /// Update FCM device token after login (token rotation only).
  static String get updateFcmDeviceToken =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/notifications/device-token';

  // ============================================
  // Products endpoints (full URLs - baseUrl from flavor)
  // ============================================

  /// Products list endpoint - full URL
  static String get products => 'https://dummyjson.com/products';

  /// Home panel: service tiles and the Pro promo banner (CMS mobile API).
  static String get home =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/home';


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
      '$_normalizedApiBaseUrl/acs-aggregator/api/v2/mobile/doctor-consultation/book-consultation';

  /// Abandon an unpaid doctor consultation booking (aggregator mobile API).
  static String get doctorConsultationBookingAbandon =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/book-consultation/abandon';

  /// Paginated list of subscriber's booked doctor consultations (aggregator mobile API).
  static String doctorConsultationBookings({int page = 1, int limit = 20}) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation?page=$page&limit=$limit';

  /// Single booked doctor consultation by `orderId` (aggregator mobile API).
  static String doctorConsultationBookingDetail(int appointmentId) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/$appointmentId';

  /// Submit patient feedback for a doctor consultation booking (aggregator mobile API).
  static String get doctorConsultationFeedback =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/feedback';

  /// Record an AI assistant screening conversation (aggregator mobile API).
  static String get aiAssistantInteractions =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/ai-assistant/interactions';

  /// Payment providers for checkout (aggregator mobile API).
  /// [module] is one of: `consultation` | `pharmacy` | `lab-testing` | `surgery`.
  static String paymentProviders({required String module}) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v2/mobile/payment-provider'
      '?module=${Uri.encodeComponent(module)}';

  /// Supported cities (aggregator mobile API) — shared Select City dialog.
  static String get cities =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/cities';

  /// Home promotional banner(s) — CMS mobile API (first active item by displayOrder).
  static String get promotionalBanner =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/banners';

  /// App version / force-update check — CMS mobile API (`platform=ios|android`).
  static String appVersion({required String platform}) =>
      '$_normalizedApiBaseUrl/acs-cmsbe/api/v1/mobile/app-version'
      '?platform=${Uri.encodeComponent(platform)}';

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

  /// Instant doctor consultation WebView session log.
  /// Body: `start_time`, `end_time`, `instant_doc_log` (page JSON, or `""`), `providerName`.
  static String get instantDoctorSessionLog =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/doctor-consultation/instant/session-log';

  /// ApnaClinic Pro plan details (aggregator mobile API).
  static String get proDetails =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/pro/details';

  /// ApnaClinic Pro subscribe.
  /// Body: `planCode`, `planPriceCode`, `msisdn`, `channel`.
  static String get proSubscribe =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/pro/subscribe';

  /// ApnaClinic Pro unsubscribe.
  /// Body: `planCode`.
  static String get proUnsubscribe =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/pro/unsubscribe';

  /// Promo code validate (aggregator mobile API).
  /// Body: `{ code, service, amount }` where `service` is CONSULTATION | LAB | PHARMACY.
  static String get promoCodeValidate =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v2/mobile/promo-code/validate';

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
  /// In-app notification inbox (notification service).
  static String notifications({int page = 1, int limit = 20}) =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/notifications'
      '?page=$page&limit=$limit';

  /// Mark a notification as read by `publicId`.
  static String notificationMarkRead(String publicId) =>
      '$_normalizedApiBaseUrl/acs-auth/api/v1/notifications/'
      '${Uri.encodeComponent(publicId)}/read';

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
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/cart/details';

  /// Pharmacy add-to-cart (POST).
  static String get pharmacyAddToCart =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/cart/add';

  /// Pharmacy prescription upload (POST multipart).
  static String get pharmacyPrescriptionUpload =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/prescription/upload/cart';

  /// Pharmacy cart quantity update (POST).
  static String get pharmacyUpdateCartQuantity =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/cart/quantity/update';

  /// Pharmacy order checkout (POST).
  static String get pharmacyOrderCheckout =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v2/mobile/partner/pharmacy/order/checkout';

  /// Pharmacy order abandon (POST) — unlock cart after unpaid card checkout.
  static String get pharmacyOrderAbandon =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/order/abandon';

  /// Pharmacy profile address create (POST).
  static String get pharmacyProfileAddress =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/profile/address';

  /// Pharmacy saved addresses list (POST).
  static String get pharmacyProfileAddressesList =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/partner/pharmacy/profile/addresses/list';

  /// Aggregator mobile bookings list (GET).
  /// Example: `…/mobile/bookings?type=pharmacy&page=1&limit=20`
  static String mobileBookings({
    required String type,
    int page = 1,
    int limit = 20,
  }) {
    final query = <String, String>{
      'type': type.trim(),
      'page': '$page',
      'limit': '$limit',
    };
    final encoded = query.entries
        .map(
          (e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
        )
        .join('&');
    return '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/bookings?$encoded';
  }

  /// Pharmacy bookings list convenience wrapper.
  static String pharmacyBookings({int page = 1, int limit = 20}) =>
      mobileBookings(type: 'pharmacy', page: page, limit: limit);

  /// Instant Doctor (teleconsultation) bookings list.
  static String instantDoctorBookings({int page = 1, int limit = 20}) =>
      mobileBookings(type: 'teleconsultation', page: page, limit: limit);

  /// Single mobile booking detail by id (GET).
  /// Example: `…/mobile/bookings/{orderId}`
  static String mobileBookingDetail(String orderId) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/bookings/'
      '${Uri.encodeComponent(orderId.trim())}';

  /// Pharmacy booking detail convenience wrapper.
  static String pharmacyBookingDetail(String orderId) =>
      mobileBookingDetail(orderId);

  /// Global mobile search (GET). Query: `text`, `limit`.
  static String mobileSearch({required String text, int limit = 10}) {
    final q = <String>[
      'text=${Uri.encodeComponent(text.trim())}',
      'limit=$limit',
    ];
    return '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/search?${q.join('&')}';
  }

  /// Popular mobile searches (GET).
  static String get mobileSearchPopular =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/search/popular';

  /// Legacy alias — prefer [mobileSearch].
  static String get search =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/search';

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

  /// Surgery lead submit (POST) and list (GET) — aggregator mobile API.
  /// POST body: `doctorId`, `surgeryId` (procedure), `packageId`, `cityId`, `patient{...}`.
  static String get surgeryBooking =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/surgery/lead';

  /// Paginated surgery leads / bookings list (GET same lead resource).
  static String surgeryLeads({int page = 1, int limit = 20}) =>
      '$surgeryBooking?page=$page&limit=$limit';

  /// Single surgery lead / booking detail by id.
  static String surgeryLeadDetail(int leadId) => '$surgeryBooking/$leadId';

  /// Confirm / pay a surgery lead (aggregator mobile API).
  /// Body: `{ leadId, paymentMethod, msisdn }`.
  static String get surgeryBookSurgery =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/surgery/book-surgery';

  static String get labTestCatalog => '$_normalizedApiBaseUrl/lab/test';

  /// Labs available in a city (pick a lab before tests).
  static String labs({required String cityId}) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/labs?cityId=${Uri.encodeComponent(cityId)}';

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
        .map(
          (e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
        )
        .join('&');
    return '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/lab/tests?$encoded';
  }

  /// Lab test detail with per-partner labs and pricing for a city.
  static String labTestDetail({required int testId, required String cityId}) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/lab/tests/$testId?cityId=${Uri.encodeComponent(cityId)}';

  /// Paginated lab orders / bookings list.
  static String labOrders({int page = 1, int limit = 20}) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/lab-orders?page=$page&limit=$limit';

  /// Single lab order detail by id.
  static String labOrderById(String orderId) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/lab-orders/${Uri.encodeComponent(orderId)}';

  /// Book one or more lab tests (aggregator mobile API).
  /// Body: `{ partnerId, labId, cityId, homeSample, paymentMethod, msisdn,
  /// patient: { name, age, gender, phoneNumber }, tests: [ { testId } ] }`.
  static String get labBookTest =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v2/mobile/lab/book-test';

  /// Abandon an unpaid lab booking (aggregator mobile API).
  static String get labBookTestAbandon =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/lab/book-test/abandon';

  /// Booking invoice PDF (raw `application/pdf` body, not JSON).
  /// [moduleType] is `CONSULTATION` | `LAB` | `SURGERY` | `PHARMACY`.
  /// [orderId] is the same id as that vertical's detail GET.
  static String mobileInvoice({
    required String moduleType,
    required String orderId,
  }) =>
      '$_normalizedApiBaseUrl/acs-aggregator/api/v1/mobile/invoice/'
      '${Uri.encodeComponent(moduleType.trim())}/'
      '${Uri.encodeComponent(orderId.trim())}';

  // ============================================
  // 3rd Party Integration Support (Full URLs)
  // ============================================

  /// Use full URL for 3rd party integrations
  /// Example: AppUrls.thirdPartyUrl('https://api.thirdparty.com/endpoint')
  /// This returns the URL as-is for complete 3rd party integration

  // ============================================
  // Legal / policy pages (full URLs)
  // ============================================

  static const String website = 'https://apnaclinic.ecnstg.com/';

  /// FikrFree Android application id (Play Store / PackageManager).
  static const String fikrFreeAndroidPackage = 'com.fikrfree.android';

  /// FikrFree iOS custom URL schemes. Tried in order when the app is installed.
  static const List<String> fikrFreeIosUrlSchemes = [
    'fikrfree://',
    'com.fikrfree.ios://',
  ];

  /// FikrFree on the App Store (iOS).
  static const String fikrFreeAppStoreIos =
      'https://apps.apple.com/us/app/fikrfree/id6739287582';

  /// FikrFree on Google Play (Android).
  static const String fikrFreePlayStoreAndroid =
      'https://play.google.com/store/apps/details?id=com.fikrfree.android';

  /// Apna Clinic on Google Play (Android). Used when CMS omits storeUrl.
  static const String apnaClinicPlayStoreAndroid =
      'https://play.google.com/store/apps/details?id=com.apna.clinic.android';

  /// Apna Clinic App Store listing (iOS). Override when the live App Store id is known.
  static const String apnaClinicAppStoreIos =
      'https://apps.apple.com/pk/search?term=Apna%20Clinic';

  /// Apna Doctor AI screening (MedIQ Huda).
  static const String apnaDoctorAi = 'https://medai.mediq.com.pk/hudav2/';
}
