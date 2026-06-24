import '../../../../core/config/mock_config.dart';

class FreeDoctorMockApi {
  /// Toggle mock responses for instant doctor API.
  static bool useMockResponses = MockConfig.enableFreeDoctorMocks;

  Future<Map<String, dynamic>> getFreeDoctorSuccessResponse({
    required String msisdn,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'Instant consultation info retrieved',
      'code': 200,
      'data': {
        'isSubscribed': true,
        'bulletText': [
          'You have an active Jazz Health subscription.',
          'Connect with a doctor instantly.',
        ],
        'buttonText': 'Start Consultation',
        'redirectUrl': 'https://vidconsult.milvikpakistan.com',
      },
    };
  }
}
