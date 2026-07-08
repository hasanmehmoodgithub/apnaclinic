import '../../../../core/config/mock_config.dart';

class PaymentProvidersMockApi {
  static bool useMockResponses = MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> getPaymentProvidersSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'Payment providers retrieved',
      'code': 200,
      'data': [
        {
          'name': 'JazzCash',
          'code': 'JAZZCASH',
          'isActive': true,
          'iconUrl':
              'https://jazzred-app-stg.jazz.com.pk/api/storage/v1/fintech/05912a86-d6b7-457c-960a-ce7e1c4e5bf8.png',
        },
        {
          'name': 'Card',
          'code': 'CARD',
          'isActive': true,
          'iconUrl':
              'https://jazzred-app-stg.jazz.com.pk/api/storage/v1/fintech/766cc1ae-760a-4fbd-8d39-3c9761c35ac7.png',
        },
      ],
    };
  }
}
