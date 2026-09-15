import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/use_cases/validate_promo_code_use_case.dart';
import '../mock/promo_code_mock_api.dart';
import '../models/promo_code_validation_model.dart';
import 'promo_code_remote_data_source.dart';

class PromoCodeRemoteDataSourceImpl implements PromoCodeRemoteDataSource {
  PromoCodeRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final PromoCodeMockApi mockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<PromoCodeValidationModel> validate(
    ValidatePromoCodeParams params,
  ) async {
    try {
      final Map<String, dynamic> response;
      if (PromoCodeMockApi.useMockResponses) {
        response = await mockApi.validate(params);
      } else {
        response = await apiService.post(
          AppUrls.promoCodeValidate,
          data: {
            'code': params.code,
            'service': params.service.apiValue,
            'amount': params.amount,
          },
        );
        log('validatePromoCode response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PromoCodeValidationModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.promoCodeValidateError).toString();
      return Future.error(message);
    } catch (e) {
      log('validatePromoCode error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.promoCodeValidate,
      );
      return Future.error(message);
    }
  }
}
