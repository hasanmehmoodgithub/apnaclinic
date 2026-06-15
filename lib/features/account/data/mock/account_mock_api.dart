import '../../../../core/config/mock_config.dart';

class AccountMockApi {
  static bool useMockResponses = MockConfig.enableAccountMocks;

  static final List<Map<String, dynamic>> _phones = [
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
  ];

  Future<Map<String, dynamic>> getUserProfileResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return {
      'success': true,
      'message': 'User fetched successfully.',
      'data': {
        'id': 3,
        'publicId': '6eb5e735d13e1fc3f6c8630b26',
        'phones': List<Map<String, dynamic>>.from(_phones),
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

  Future<Map<String, dynamic>> addUserPhoneResponse({
    required String phone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final nextId = _phones.fold<int>(
      0,
      (maxId, entry) {
        final rawId = entry['id'];
        final id = rawId is num ? rawId.toInt() : int.tryParse('$rawId') ?? 0;
        return id > maxId ? id : maxId;
      },
    );
    _phones.add({
      'id': nextId + 1,
      'msisdn': phone,
      'jazzCashVerified': false,
      'primary': false,
    });
    return {
      'success': true,
      'message': 'Phone added successfully.',
    };
  }

  Future<Map<String, dynamic>> deleteUserPhoneResponse({
    required String phoneId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _phones.removeWhere((entry) => entry['id'].toString() == phoneId);
    return {
      'success': true,
      'message': 'User account removed successfully.',
      'data': null,
    };
  }
}
