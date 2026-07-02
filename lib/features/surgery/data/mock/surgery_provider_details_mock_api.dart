import '../../../../core/config/mock_config.dart';

class SurgeryProviderDetailsMockApi {
  static bool useMockResponses = MockConfig.enableSurgeryMocks;

  Future<Map<String, dynamic>> getProviderDetailsSuccessResponse({
    required String surgeryId,
    required String cityId,
    required String doctorId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return {
      'success': true,
      'message': 'Provider details retrieved',
      'code': 200,
      'data': {
        'doctor': {
          'id': int.tryParse(doctorId) ?? doctorId,
          'name': 'Dr. Faizan Rahim',
          'profileImageUrl': '',
          'yearsOfExperience': 9,
          'education': 'MBBS, FCPS (Plastic Surgery)',
          'bio': null,
          'specialty': 'Plastic Surgeon',
          'partnerId': 1,
          'partnerName': 'Oladoc',
          'partnerLogoUrl': null,
        },
        'packages': [
          {
            'packageId': 3951,
            'packageName': 'Liposuction (Chin)',
            'price': 100000,
            'discountedPrice': 85000,
            'tatMessage':
                'Our representative will contact you within 24 hours',
            'hospitalId': 288,
            'hospitalName': '6D Hair Transplant and Skin Clinic',
          },
          {
            'packageId': 3970,
            'packageName': 'Liposuction (Arm)',
            'price': 250000,
            'discountedPrice': 200000,
            'tatMessage':
                'Our representative will contact you within 24 hours',
            'hospitalId': 288,
            'hospitalName': '6D Hair Transplant and Skin Clinic',
          },
          {
            'packageId': 3968,
            'packageName': 'Liposuction (Thighs)',
            'price': 300000,
            'discountedPrice': 260000,
            'tatMessage':
                'Our representative will contact you within 24 hours',
            'hospitalId': 288,
            'hospitalName': '6D Hair Transplant and Skin Clinic',
          },
          {
            'packageId': 3971,
            'packageName': 'Liposuction (Abdomen)',
            'price': 300000,
            'discountedPrice': 260000,
            'tatMessage':
                'Our representative will contact you within 24 hours',
            'hospitalId': 288,
            'hospitalName': '6D Hair Transplant and Skin Clinic',
          },
        ],
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
