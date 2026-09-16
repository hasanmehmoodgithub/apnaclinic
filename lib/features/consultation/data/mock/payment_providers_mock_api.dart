import '../../../../core/config/mock_config.dart';

class PaymentProvidersMockApi {
  static bool useMockResponses = MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> getPaymentProvidersSuccessResponse({
    String? module,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'Payment providers retrieved',
      'data': [
        {
          'code': 'JAZZCASH',
          'title': 'JazzCash',
          'subtitle': '20% of on all labs',
          'label': {
            'text': 'enjoy discount',
            'color': '#343434',
          },
          'termsAndCondition': {
            'title': 'terms',
            'description': 'tt\nt\nt\nt',
          },
          'logo':
              'https://jazzred-app-stg.jazz.com.pk/api/storage/v1/fintech/05912a86-d6b7-457c-960a-ce7e1c4e5bf8.png',
        },
        {
          'code': 'CARD',
          'title': 'Card',
          'subtitle': 'Card',
          'label': null,
          'termsAndCondition': null,
          'logo':
              'https://jazzred-msa-stg.jazz.com.pk/acs-media/apna-clinic/8a4168e7-4089-4ad3-ba78-e0773d1de4e0.png',
        },
        {
          'code': 'COD',
          'title': 'Cash on Delivery',
          'subtitle': 'Cash on Delivery',
          'label': null,
          'termsAndCondition': null,
          'logo': null,
        },
      ],
    };
  }
}
