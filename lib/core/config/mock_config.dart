import 'package:flutter/foundation.dart';

class MockConfig {
  MockConfig._();

  static const String _mockTrueValue = String.fromEnvironment(
    'MOCKTRUE',
    defaultValue: 'true',
  );

  static bool get enableMocks {
    return _isTruthy(_mockTrueValue) || kDebugMode;
  }

  static bool get enableLabTestMocks => enableMocks;

  static bool get enableAuthMocks => enableMocks;

  static bool get enableProfileMocks => enableMocks;

  static bool get enableDashboardMocks => enableMocks;

  static bool get enableConsultationMocks => enableMocks;

  static bool get enableSurgeryMocks => enableMocks;

  static bool get enableAccountMocks => enableMocks;

  static bool get enableInstantDoctorMocks => enableMocks;

  static bool _isTruthy(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'on' ||
        normalized == 'mocktrue';
  }
}
