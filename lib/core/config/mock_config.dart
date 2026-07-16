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

  static bool get enableLabTestMocks {
    return false;
    return _isTruthy(_mockTrueValue) || kDebugMode;
  }
  static bool get enableAuthMocks {
    return false;
    return _isTruthy(_mockTrueValue)  || kDebugMode;
  }
  static bool get enableProfileMocks {
    return false;
    return _isTruthy(_mockTrueValue)  || kDebugMode;
  }

  static bool get enableDashboardMocks => false;

  static bool get enableConsultationMocks {
    return false;
    return _isTruthy(_mockTrueValue) || kDebugMode;
  }

  static bool get enableSurgeryMocks {
    return false;
    return _isTruthy(_mockTrueValue) || kDebugMode;
  }

  static bool get enableAccountMocks {
    return false;
    return _isTruthy(_mockTrueValue) || kDebugMode;
  }

  static bool get enableInstantDoctorMocks {
    return false;
    return _isTruthy(_mockTrueValue) || kDebugMode;
  }
  static bool get enablePharmacyMocks {
    return false;
    return _isTruthy(_mockTrueValue) || kDebugMode;
  }
  static bool _isTruthy(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'on' ||
        normalized == 'mocktrue';
  }
}
