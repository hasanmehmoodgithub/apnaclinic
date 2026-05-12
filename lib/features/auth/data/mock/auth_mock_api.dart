import '../../../../core/config/mock_config.dart';

class AuthMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> requestOtpSuccessResponse({
    required String phoneNumber,
    required String channel,
  }) async {
    return <String, dynamic>{
      'success': true,
      'message': 'OTP sent successfully.',
      'data': <String, dynamic>{
        'msisdn': phoneNumber,
        'channel': channel,
        'expiresIn': 5,
        'generationAttemptCount': 1,
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
        'tokenType': 'Bearer',
        'accessToken': <String, dynamic>{
          'token': 'mock-token',
          'expiresIn': 900000,
        },
        'refreshToken': <String, dynamic>{
          'token': 'mock-refresh-token',
          'expiresIn': 604800000,
        },
        'userId': phoneNumber,
        'isOnboardingCompleted': isOnboardingCompleted,
        'userOnboarding': !isOnboardingCompleted,
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
