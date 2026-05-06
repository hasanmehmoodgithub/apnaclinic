import '../../../../core/config/mock_config.dart';

class AuthMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> requestOtpSuccessResponse({
    required String phoneNumber,
  }) async {
    return <String, dynamic>{
      'success': true,
      'message': 'OTP sent successfully.',
      'data': <String, dynamic>{
        'phoneNumber': phoneNumber,
      },
    };
  }

  Future<Map<String, dynamic>> verifyOtpSuccessResponse({
    required String phoneNumber,
    required String otp,
  }) async {
    if (otp != '1234') {
      return <String, dynamic>{
        'success': false,
        'message': 'Invalid OTP code.',
      };
    }

    final isOnboardingCompleted = !phoneNumber.endsWith('0');
    return <String, dynamic>{
      'success': true,
      'message': 'Login successful.',
      'data': <String, dynamic>{
        'token': 'mock-token',
        'userId': phoneNumber,
        'isOnboardingCompleted': true,
        'user': <String, dynamic>{
          'firstName': isOnboardingCompleted ? 'Hasan' : '',
          'lastName': isOnboardingCompleted ? 'Ali' : '',
          'gender': isOnboardingCompleted ? 'male' : '',
          'email': isOnboardingCompleted ? 'hasan@example.com' : '',
          'address': isOnboardingCompleted ? 'Lahore' : '',
          'dateOfBirth': isOnboardingCompleted ? '1998-05-12' : '',
        },
      },
    };
  }
}
