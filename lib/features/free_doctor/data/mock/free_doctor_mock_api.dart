import '../../../../core/config/mock_config.dart';

class FreeDoctorMockApi {
  /// Toggle mock responses for free doctor API.
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getFreeDoctorSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'Instant doctor content fetched successfully',
      'data': {
        'title': '24/7 Instant Doctor Consultation',
        'descriptionPoints': [
          'This service is available exclusively for M-Health subscribers.',
          'Get 24/7 access to qualified doctors for general medical support and much more.',
        ],
        'fikrfreeAndroidPackage': 'com.fikrfree.android',
        'fikrfreeIosAppStoreUrl':
            'https://apps.apple.com/pk/app/fikrfree/id6738691924',
        'fikrfreeWebUrl': 'https://www.fikrfree.com',
      },
    };
  }
}
