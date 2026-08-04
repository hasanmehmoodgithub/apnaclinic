import '../../../../core/config/mock_config.dart';

import '../../domain/models/profile_setup_data.dart';

class ProfileSetupMockApi {
  static bool useMockResponses = MockConfig.enableProfileMocks;

  Future<Map<String, dynamic>> getProfileSetupSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'User fetched successfully.',
      'data': {
        'id': 3,
        'publicId': '6eb5e735d13e1fc3f6c8630b26',
        'phones': [
          {
            'id': 1,
            'msisdn': '923012123411',
            'jazzCashVerified': false,
            'primary': true,
          },
          {
            'id': 2,
            'msisdn': '923012123412',
            'jazzCashVerified': false,
            'primary': false,
          },
        ],
        'email': 'bilal@gmail.com',
        'firstName': 'bilal',
        'lastName': 'ahmad',
        'dob': '11-06-2006 00:00:00',
        'gender': 'Male',
        'address': 'raw',
        'image': null,
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
