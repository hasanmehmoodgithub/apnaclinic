import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/use_cases/subscribe_pro_params.dart';
import '../../domain/use_cases/unsubscribe_pro_params.dart';
import '../mock/pro_mock_api.dart';
import '../models/pro_catalog_model.dart';
import '../models/pro_subscribe_response_model.dart';
import '../models/pro_unsubscribe_response_model.dart';
import 'pro_remote_data_source.dart';

class ProRemoteDataSourceImpl implements ProRemoteDataSource {
  ProRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final ProMockApi mockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    if (code is num && code.toInt() == 200) return true;
    // Live details payload is `{ message, data }` with no success flag.
    return response['data'] is Map;
  }

  @override
  Future<ProCatalogModel> getCatalog() async {
    try {
      final Map<String, dynamic> response;
      if (ProMockApi.useMockResponses) {
        response = await mockApi.getCatalogSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.proDetails);
        log('getProCatalog response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ProCatalogModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.proCatalogLoadError).toString();
      return Future.error(message);
    } catch (e) {
      log('getProCatalog error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.proDetails,
      );
      return Future.error(message);
    }
  }

  @override
  Future<ProSubscribeResponseModel> subscribe(SubscribeProParams params) async {
    try {
      final Map<String, dynamic> response;
      if (ProMockApi.useMockResponses) {
        response = await mockApi.subscribeSuccessResponse();
      } else {
        response = await apiService.post(
          AppUrls.proSubscribe,
          data: params.toJson(),
        );
        log('subscribePro response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ProSubscribeResponseModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.proSubscribeError).toString();
      return Future.error(message);
    } catch (e) {
      log('subscribePro error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.proSubscribe,
      );
      return Future.error(message);
    }
  }

  @override
  Future<ProUnsubscribeResponseModel> unsubscribe(
    UnsubscribeProParams params,
  ) async {
    try {
      final Map<String, dynamic> response;
      if (ProMockApi.useMockResponses) {
        response = await mockApi.unsubscribeSuccessResponse();
      } else {
        response = await apiService.post(
          AppUrls.proUnsubscribe,
          data: params.toJson(),
        );
        log('unsubscribePro response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ProUnsubscribeResponseModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.proUnsubscribeError).toString();
      return Future.error(message);
    } catch (e) {
      log('unsubscribePro error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.proUnsubscribe,
      );
      return Future.error(message);
    }
  }
}
