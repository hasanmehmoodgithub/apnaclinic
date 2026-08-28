import '../../../../core/config/mock_config.dart';

class AuthMockApi {
  static bool useMockResponses = MockConfig.enableAuthMocks;

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
        'expiresIn': 300,
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
      'message': 'OTP verified and tokens issued successfully.',
      'data': <String, dynamic>{
        'tokenType': 'Bearer',
        'accessToken': <String, dynamic>{
          'token': 'mock-token',
          'expiresIn': 3600,
        },
        'refreshToken': <String, dynamic>{
          'token': 'mock-refresh-token',
          'expiresIn': 604800,
        },
        'userOnboarding': !isOnboardingCompleted,
        'user': <String, dynamic>{
          'id': 60623,
          'publicId': '20368c66-d8f6-4a37-b1cd-17d2d029ac6a',
          'phones': <dynamic>[],
          'email': 'hasanmehmood.email@gmail.com',
          'firstName': 'Hasan',
          'lastName': isOnboardingCompleted ? 'Ali' : null,
          'dob': isOnboardingCompleted
              ? '12-05-1998 00:00:00'
              : '21-05-1994 00:00:00',
          'gender': 'Male',
          'address': isOnboardingCompleted ? 'Lahore' : 'lahore',
          'image':
              'https://pharmacy.apnaclinic.com.pk/acs-media/apna-clinic/users/profile_images/01a047f9-045e-740e-9f7c-06f4b9ec2377.jpg',
        },
      },
    };
  }
}
