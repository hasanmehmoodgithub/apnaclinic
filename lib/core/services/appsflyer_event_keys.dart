/// AppsFlyer-only event and parameter names (not Firebase).
///
/// Product owns this list separately from [AnalyticsEventKeys]. Call via
/// [AppsFlyerService.logEvent].
class AppsFlyerEventKeys {
  AppsFlyerEventKeys._();

  /// Instant Doctor tab / entry opens.
  static const String instantDoctorModule = 'instant_doctor_module';

  /// Purchase / order confirmed (Instant Doctor subscribe or Pharmacy order).
  static const String purchase = 'af_purchase';

  /// Pharmacy: add to cart succeeds.
  static const String addToCart = 'af_add_to_cart';

  /// Pharmacy: product detail viewed.
  static const String contentView = 'af_content_view';

  /// Pharmacy: checkout screen opens.
  static const String initiatedCheckout = 'af_initiated_checkout';

  /// Consultation AI screening WebView opens / exits.
  static const String aiChatStarted = 'ai_chat_started';
  static const String aiChatEnded = 'ai_chat_ended';

  /// Consultation hub / related discovery.
  static const String consultancyModule = 'consultancy_module';

  /// Doctor profile tap, screen open, or confirm with timeslot.
  static const String doctorProfile = 'doctor_profile';

  /// Surgery hub / city change.
  static const String surgeryModule = 'surgery_module';
}

class AppsFlyerParamKeys {
  AppsFlyerParamKeys._();

  static const String sourceScreen = 'source_screen';
  static const String source = 'source';
  static const String partner = 'partner';
  static const String callDuration = 'call_duration';
  static const String categoryName = 'category_name';
  static const String keyword = 'keyword';
  static const String doctorId = 'doctor_id';
  static const String doctorName = 'doctor_name';
  static const String category = 'category';
  static const String timeslot = 'timeslot';
  static const String bookingId = 'booking_id';
  static const String consultationTimeslot = 'consultation_timeslot';
  static const String bookingTimestamp = 'booking_timestamp';

  static const String afContentType = 'af_content_type';
  static const String contentType = 'content_type';
  static const String productId = 'product_id';
  static const String productName = 'product_name';
  static const String prescriptionRequired = 'prescription_required';

  static const String orderId = 'order_id';
  static const String userName = 'user_name';
  static const String userType = 'user_type';
  static const String msisdn = 'msisdn';
  static const String cartItems = 'cart_items';
  static const String subTotal = 'sub_total';
  static const String orderValue = 'order_value';
  static const String promoApplied = 'promo_applied';
  static const String timestamp = 'timestamp';
  static const String wellnessOrder = 'wellness_order';
  static const String promo = 'promo';
  static const String deliveryCharges = 'delivery_charges';
  static const String paymentMethod = 'payment_method';
  static const String paymentStatus = 'payment_status';

  /// Product sheet label (exact).
  static const String jazzCashAuthCode = 'JazzCash Auth Code';
  static const String transactionId = 'transaction_id';

  static const String testName = 'test_name';
  static const String labName = 'lab_name';
  static const String partnerName = 'partner_name';
  static const String sampleType = 'sample_type';
  static const String samplingMode = 'sampling_mode';
  static const String numberOfTests = 'number_of_tests';
  static const String address = 'address';
  static const String surgeryName = 'surgery_name';
  static const String amount = 'amount';
  static const String selectedCity = 'selected_city';
  static const String promoCode = 'promo_code';
}

class AppsFlyerContentTypeKeys {
  AppsFlyerContentTypeKeys._();

  static const String pharmacy = 'Pharmacy';
  static const String consultancy = 'Consultancy';
  static const String lab = 'Lab';
  static const String labCheckout = 'Lab Checkout';
  static const String surgery = 'Surgery';
}
