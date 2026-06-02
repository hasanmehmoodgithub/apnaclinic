import '../../../../core/config/mock_config.dart';

class CustomerSupportMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getSupportSettingsSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return {
      'success': true,
      'message': 'Support settings retrieved',
      'code': 200,
      'data': {
        'phone': '03001118828',
        'email': 'support@apnaclinic.com.pk',
        'description':
            'For further support please contact us 24/7 on 03001118828 or email at support@apnaclinic.com.pk',
        'buttonText': 'Call Now',
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
