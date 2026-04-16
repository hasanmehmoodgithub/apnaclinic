import 'package:flutter/foundation.dart';

class AuthMockApi {
  static bool useMockResponses = kDebugMode & true;

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

    return <String, dynamic>{
      'success': true,
      'message': 'Login successful.',
      'data': <String, dynamic>{
        'token': 'mock-token',
        'userId': phoneNumber,
      },
    };
  }
}
