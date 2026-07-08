import '../../../../core/config/mock_config.dart';

class InstantDoctorMockApi {
  /// Toggle mock responses for instant doctor API.
  static bool useMockResponses = MockConfig.enableInstantDoctorMocks;

  Future<Map<String, dynamic>> getInstantDoctorSuccessResponse({
    required String msisdn,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {
      'success': true,
      'message': 'Instant consultation info retrieved',
      'code': 200,
      'data': [
        {
          'providerId': 1,
          'providerName': 'BIMA',
          'logoUrl': null,
          'isSubscribed': true,
          'product': {
            'productId': 1,
            'productCode': 'BIMAMHEALTH2POSTPAID',
            'productType': 'postpaid',
            'productTitle': 'Apnaclinic - BIMA MHealth @Rs.150+tax/month',
            'priceDisplay': 'Rs. 5.9 + tax per day',
            'benefits': [
              '24/7 Doctor Consultation',
              'Get Rs.500 Cashback on Pharmacy',
            ],
            'redirectUrl': 'https://vidconsult.milvikpakistan.com/',
          },
        },
        {
          'providerId': 3,
          'providerName': 'MEDIQ',
          'logoUrl': null,
          'isSubscribed': false,
          'product': {
            'productId': 4,
            'productCode': 'MEDIQPOSTPAID',
            'productType': 'postpaid',
            'productTitle': 'ApnaClinic - MedIQ MHealth @Rs 150+tax/month',
            'priceDisplay': 'Rs. 5.98 + tax per day',
            'benefits': [
              '24/7 Doctor Consultation',
              'Get Rs. 1000 Cashback on Specialist Consultation',
            ],
            'redirectUrl': '',
          },
        },
      ],
      'timestamp': '2026-07-07T05:17:39.414Z',
    };
  }

  Future<Map<String, dynamic>> sendOtpSuccessResponse({
    required String msisdn,
    required int productId,
    required String uuid,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'OTP sent successfully',
      'code': 200,
      'data': {
        'msisdn': msisdn,
        'productId': productId,
        'uuid': uuid,
      },
    };
  }

  Future<Map<String, dynamic>> verifyOtpResponse({
    required String msisdn,
    required int productId,
    required String otp,
    required String uuid,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (otp == '1234') {
      return {
        'success': true,
        'message': 'Subscription verified successfully',
        'code': 200,
        'data': {
          'msisdn': msisdn,
          'productId': productId,
          'uuid': uuid,
        },
      };
    }
    return {
      'success': false,
      'message': 'Invalid OTP code.',
      'code': 400,
    };
  }

  Future<Map<String, dynamic>> cancelSubscriptionSuccessResponse({
    required String msisdn,
    required int productId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return {
      'success': true,
      'message': 'Subscription cancelled successfully',
      'code': 200,
      'data': {
        'msisdn': msisdn,
        'productId': productId,
      },
    };
  }
}
