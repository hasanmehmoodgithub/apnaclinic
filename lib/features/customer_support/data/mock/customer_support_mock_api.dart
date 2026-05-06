import '../../../../core/config/mock_config.dart';

class CustomerSupportMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getCustomerSupportSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'Customer support content fetched successfully',
      'data': {
        'helpCentreTitle': 'Help Centre',
        'helpCentreSubtitle': 'Reach out to Apna Clinic for any support.',
        'contacts': [
          {
            'cardTitle': 'Apna Clinic Support',
            'dialogTitle': 'Customer Support',
            'dialogMessage':
                'Or further support please contact us 24/7 on\n042-111-333-033.',
            'dialNumber': '042111333033',
          },
        ],
      },
    };
  }
}
