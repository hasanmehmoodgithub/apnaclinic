/// Event and parameter names. snake_case, ≤40 chars, no `firebase_`/`google_`/`ga_` prefix.
class AnalyticsEventKeys {
  AnalyticsEventKeys._();

  static String onboardingStep(int step) => 'onboarding_step_$step';
  static const onboardingSkipped = 'onboarding_skipped';
  static const firstInstall = 'first_install';

  static const aiChatStarted = 'ai_chat_started';
  static const aiChatEnded = 'ai_chat_ended';

  static const searchScreen = 'search_screen';
  static const searchPerformed = 'search_performed';
  static const searchResultClicked = 'search_result_clicked';

  static const instantDocSubscribeClicked = 'instant_doc_subscribe_clicked';
  static const fbMobileSubscribe = 'fb_mobile_subscribe';
  static const startConsultationClicked = 'start_consultation_clicked';
  static const instantDoctorModule = 'instant_doctor_module';

  static const pharmacyModule = 'pharmacy_module';
  static const pharmacySearchClicked = 'pharmacy_search_clicked';
  static const pharmacySearchPerformed = 'pharmacy_search_performed';
  static const medicineItemClicked = 'medicine_item_clicked';
  static const pharmacyItemDescription = 'pharmacy_item_description';
  static const pharmacyAddToCart = 'pharmacy_add_to_cart';
  static const pharmacyCartViewed = 'pharmacy_cart_Viewed';
  static const pharmacyCheckout = 'pharmacy_checkout';
  static const pharmacyConfirmPayment = 'pharmacy_confirm_payment';
  static const pharmacyOrderConfirmed = 'pharmacy_order_confirmed';

  static const authenticationScreenViewed = 'authentication_screen_viewed';
  static const otpSent = 'otp_sent';
  static const otpVerified = 'otp_verified';
  static const profileCreationScreen = 'profile_creation_screen';
  static const profileCreated = 'profile_created';

  static const consultancyModule = 'consultancy_module';
  static const consultancySearchClicked = 'consultancy_search_clicked';
  static const doctorCategoryClicked = 'doctor_category_clicked';
  static const doctorListingScreen = 'doctor_listing_screen';
  static const doctorSearchClicked = 'doctor_search_clicked';
  static const doctorSearchPerformed = 'doctor_search_performed';
  static const doctorFilterApplied = 'doctor_filter_applied';
  static const doctorProfileClicked = 'doctor_profile_clicked';
  static const doctorProfileScreen = 'doctor_profile_screen';
  static const doctorDocumentUploaded = 'doctor_document_uploaded';
  static const doctorConsultationConfirm = 'doctor_consultation_confirm';
  static const doctorConsultationBooked = 'doctor_consultation_booked';

  static const labModule = 'lab_module';
  /// BRD Lab Journey: module open with `source`.
  static const labModuleOpened = 'lab_module_opened';
  static const labCityChange = 'lab_city_change';
  static const labSearchClicked = 'lab_search_clicked';
  static const labSearchPerformed = 'lab_search_performed';
  /// BRD Lab Journey: user selects a lab.
  static const labSelected = 'lab_selected';
  static const labItemSelect = 'lab_item_select';
  /// BRD Lab Journey: user selects a test.
  static const labTestSelected = 'lab_test_selected';
  static const labAddToCart = 'lab_add_to_cart';
  static const labCartViewed = 'lab_cart_viewed';
  static const labCheckout = 'lab_checkout';
  static const labPatientDetailsEdit = 'lab_patient_details_edit';
  static const labBookingConfirmed = 'lab_booking_confirmed';
  /// BRD Lab Journey: successful/failed book (Purchase funnel).
  static const labTestBooked = 'lab_test_booked';

  static const promoCodeEntered = 'promo_code_entered';
  static const promoCodeApplied = 'promo_code_applied';
  static const promoCodeRejected = 'promo_code_rejected';

  static const surgeryModule = 'surgery_module';
  static const surgeryCityChange = 'surgery_city_change';
  static const surgerySearchClicked = 'surgery_search_clicked';
  static const surgerySelectItem = 'surgery_select_item';
  static const surgeryDoctorSelect = 'surgery_doctor_select';
  static const surgeryCheckout = 'surgery_checkout';
  static const surgeryBooked = 'surgery_booked';

  static const myBookingsTab = 'my_bookings_tab';
  static const myBookingInstantDoc = 'my_booking_instant_doc';
  static const myBookingConsultation = 'my_booking_consultation';
  static const myBookingPharmacy = 'my_booking_pharmacy';
  static const myBookingLab = 'my_booking_lab';
  static const myBookingSurgery = 'my_booking_surgery';
  static const bookingViewed = 'booking_viewed';
  static const prescriptionAvailable = 'prescription_available';
  static const prescriptionDownloaded = 'prescription_downloaded';
  static const pharmacyStatusChanged = 'pharmacy_status_changed';
  static const instantDoctorClicked = 'instant_doctor_clicked';

  static const homeScreen = 'home_screen';
  static const pharmacyTileClicked = 'pharmacy_tile_clicked';
  static const consultationTileClicked = 'consultation_tile_clicked';
  static const labTileClicked = 'lab_tile_clicked';
  static const surgeryTileClicked = 'surgery_tile_clicked';
  static const searchClicked = 'search_clicked';
  static const notificationsScreenOpen = 'notifications_screen_open';
  static const notificationsClicked = 'notifications_clicked';
  static const myBookingsClicked = 'my_bookings_clicked';
  static const bannerClicked = 'banner_clicked';
  static const supportClicked = 'support_clicked';
}

class AnalyticsParamKeys {
  AnalyticsParamKeys._();

  static const stepNumber = 'step_number';
  static const device = 'device';
  static const platform = 'platform';
  static const callDuration = 'call_duration';
  static const keyword = 'keyword';
  static const medium = 'medium';
  static const type = 'type';
  static const partner = 'partner';
  static const msisdn = 'msisdn';
  static const sourceScreen = 'source_screen';
  static const source = 'source';
  static const resultItems = 'result_items';
  static const productId = 'product_id';
  static const productName = 'product_name';
  static const prescriptionRequired = 'prescription_required';
  static const afContentType = 'af_content_type';
  static const numberOfProducts = 'number_of_products';
  static const paymentMethod = 'payment_method';
  static const orderId = 'order_id';
  static const userName = 'user_name';
  static const cartItems = 'cart_items';
  static const subTotal = 'sub_total';
  static const orderValue = 'order_value';
  static const promoApplied = 'promo_applied';
  static const promo = 'promo';
  static const promoCodeUsed = 'promo_code_used';
  static const promoCode = 'promo_code';
  static const code = 'code';
  static const discountType = 'discount_type';
  static const discountValue = 'discount_value';
  static const userType = 'user_type';
  static const reason = 'reason';
  static const timestamp = 'timestamp';
  static const deliveryCharges = 'delivery_charges';
  static const paymentStatus = 'payment_status';
  static const categoryName = 'category_name';
  static const category = 'category';
  static const doctorId = 'doctor_id';
  static const doctorName = 'doctor_name';
  static const timeslot = 'timeslot';
  static const bookingId = 'booking_id';
  static const consultationTimeslot = 'consultation_timeslot';
  static const bookingTimestamp = 'booking_timestamp';
  static const selectedCity = 'selected_city';
  static const testName = 'test_name';
  static const testId = 'test_id';
  static const labName = 'lab_name';
  static const sampleType = 'sample_type';
  static const partnerName = 'partner_name';
  static const samplingMode = 'sampling_mode';
  static const numberOfTests = 'number_of_tests';
  static const totalAmount = 'total_amount';
  static const discount = 'discount';
  static const transactionId = 'transaction_id';
  static const authCode = 'auth_code';
  static const surgeryName = 'surgery_name';
  static const amount = 'amount';
  static const service = 'service';
  static const status = 'status';
  static const changedBy = 'changed_by';
  static const notificationId = 'notification_id';
  static const contentUrl = 'content_url';
}

class AnalyticsSearchMediumKeys {
  AnalyticsSearchMediumKeys._();

  static const type = 'Type';
  static const voice = 'Voice';
  static const recent = 'Recent';
  static const popular = 'Popular';
}

class AnalyticsInstantDoctorSourceKeys {
  AnalyticsInstantDoctorSourceKeys._();

  static const banner = 'banner';
  static const popup = 'popup';
  static const navigationTab = 'navigation_tab';

  /// Legacy value for [AnalyticsEventKeys.instantDoctorModule].
  static const bottomTab = 'bottom_tab';
}

class AnalyticsHomeSourceKeys {
  AnalyticsHomeSourceKeys._();

  static const homeScreen = 'home screen';
}

class AnalyticsSearchResultTypeKeys {
  AnalyticsSearchResultTypeKeys._();

  static const medicineName = 'medicine_name';
  static const doctor = 'doctor';
  static const lab = 'lab';
  static const surgeryDoctor = 'surgery_doctor';
}

class AnalyticsPharmacySourceKeys {
  AnalyticsPharmacySourceKeys._();

  static const search = 'search';
  static const home = 'home';
  static const banner = 'banner';
}

class AnalyticsPharmacyPaymentMethodKeys {
  AnalyticsPharmacyPaymentMethodKeys._();

  static const cod = 'COD';
  static const jazzCash = 'JC';
  static const card = 'Card';
}

class AnalyticsYesNoKeys {
  AnalyticsYesNoKeys._();

  static const yes = 'Yes';
  static const no = 'No';
}

class AnalyticsUserTypeKeys {
  AnalyticsUserTypeKeys._();

  static const pro = 'pro';
  static const standard = 'standard';
}

class AnalyticsPromoRejectReasonKeys {
  AnalyticsPromoRejectReasonKeys._();

  static const expired = 'expired';
  static const notStarted = 'not_started';
  static const ineligibleService = 'ineligible_service';
  static const ineligibleUserType = 'ineligible_user_type';
  static const invalidCode = 'invalid_code';
}

class AnalyticsPaymentStatusKeys {
  AnalyticsPaymentStatusKeys._();

  static const successful = 'Successful';
  static const failed = 'Failed';
}

class AnalyticsContentTypeKeys {
  AnalyticsContentTypeKeys._();

  static const pharmacy = 'Pharmacy';
  static const pharmacyCart = 'Pharmacy Cart';
  static const consultancy = 'Consultancy';
  static const lab = 'Lab';
  static const labCart = 'Lab Cart';
  static const labCheckout = 'Lab Checkout';
  static const surgery = 'Surgery';
}

class AnalyticsAuthSourceKeys {
  AnalyticsAuthSourceKeys._();

  static const login = 'login';
  static const pharmacy = 'pharmacy';
  static const instantDoctor = 'instant_doctor';
  static const consultancy = 'consultancy';
  static const lab = 'lab';
  static const surgery = 'surgery';
}

class AnalyticsProfileCreationSourceKeys {
  AnalyticsProfileCreationSourceKeys._();

  static const authenticationScreen = 'authentication_screen';
  static const profile = 'profile';
}

class AnalyticsConsultancySourceKeys {
  AnalyticsConsultancySourceKeys._();

  static const search = 'search';
  static const home = 'home';
  static const banner = 'banner';
}

class AnalyticsConsultationPaymentMethodKeys {
  AnalyticsConsultationPaymentMethodKeys._();

  static const jazzCash = 'JC';
  static const card = 'Card';
}

class AnalyticsConsultationPaymentStatusKeys {
  AnalyticsConsultationPaymentStatusKeys._();

  static const successful = 'successful';
  static const failed = 'failed';
}

class AnalyticsLabSourceKeys {
  AnalyticsLabSourceKeys._();

  static const home = 'home';
  static const search = 'search';
  static const bookings = 'bookings';
}

class AnalyticsLabPaymentMethodKeys {
  AnalyticsLabPaymentMethodKeys._();

  static const jazzCash = 'JazzCash';
  static const card = 'Card';
  static const cod = 'COD';
}

class AnalyticsLabSamplingModeKeys {
  AnalyticsLabSamplingModeKeys._();

  static const homeSample = 'Home Sample';
  static const walkIn = 'Walk In';
}

class AnalyticsSurgerySourceKeys {
  AnalyticsSurgerySourceKeys._();

  static const home = 'Home';
  static const search = 'Search';
  static const banner = 'Banner';
}

class AnalyticsBookingTypeKeys {
  AnalyticsBookingTypeKeys._();

  static const instantDoctor = 'instant_doctor';
  static const consultancy = 'consultancy';
  static const pharmacy = 'pharmacy';
  static const lab = 'lab';
  static const surgery = 'surgery';
}
