import '../../../../core/config/mock_config.dart';
import '../../domain/use_cases/validate_promo_code_use_case.dart';

class PromoCodeMockApi {
  static bool useMockResponses = MockConfig.enablePromoCodeMocks;

  Future<Map<String, dynamic>> validate(ValidatePromoCodeParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final code = params.code.trim().toUpperCase();
    final amount = params.amount < 0 ? 0 : params.amount;
    final percent = switch (code) {
      'JC50OFF' => 50,
      'SAVE20' => 20,
      _ => null,
    };

    if (percent == null) {
      return {
        'success': false,
        'message': 'Invalid promo code',
        'code': 400,
        'data': null,
      };
    }

    final discountAmount = ((amount * percent) / 100).round();
    final payableAmount = amount - discountAmount;
    return {
      'success': true,
      'message': 'Promo code applied',
      'code': 200,
      'data': {
        'code': code,
        'discountType': 'PERCENTAGE',
        'discountValue': percent,
        'originalAmount': amount,
        'discountAmount': discountAmount,
        'payableAmount': payableAmount < 0 ? 0 : payableAmount,
        'service': params.service.apiValue,
      },
    };
  }
}
