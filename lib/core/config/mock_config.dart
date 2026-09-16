class MockConfig {
  MockConfig._();

  static bool get enableMocks => false;

  static bool get enableLabTestMocks => false;

  static bool get enableAuthMocks => false;

  static bool get enableProfileMocks => false;

  static bool get enableDashboardMocks => false;

  static bool get enableConsultationMocks => false;

  static bool get enableSurgeryMocks => false;

  static bool get enableAccountMocks => false;

  static bool get enableInstantDoctorMocks => false;

  static bool get enablePharmacyMocks => false;

  static bool get enableNotificationMocks => false;

  /// ApnaClinic Pro catalog mocks (keep true until live membership API is ready).
  static bool get enableProMocks => true;

  static bool get enablePromoCodeMocks => false;

  /// Payment method sheet / checkout providers for every module
  /// (consultation, pharmacy, lab-testing, surgery).
  static bool get enablePaymentProviderMocks => false;
}
