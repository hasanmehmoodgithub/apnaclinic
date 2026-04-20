import 'package:flutter/foundation.dart';

import '../../domain/models/profile_setup_data.dart';

class ProfileSetupMockApi {
  static bool useMockResponses = kDebugMode & true;

  Future<Map<String, dynamic>> getProfileSetupSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'Profile setup fetched successfully',
      'data': {
        'firstName': 'Siddeeq',
        'lastName': 'Khan',
        'gender': 'male',
        'email': 'siddeeqkhan@example.com',
        'address': 'Islamabad, Pakistan',
        'dateOfBirth': '2001-01-01',
      },
    };
  }

  Future<Map<String, dynamic>> saveProfileSuccessResponse(
    ProfileSetupData data,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'Profile saved successfully',
      'data': {
        'firstName': data.firstName,
        'lastName': data.lastName,
        'gender': data.gender,
        'email': data.email,
        'address': data.address,
        'dateOfBirth': data.dateOfBirth.toIso8601String(),
      },
    };
  }
}
