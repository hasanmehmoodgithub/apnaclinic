import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/pro_mock_api.dart';
import '../models/pro_catalog_model.dart';
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
    return code is num && code.toInt() == 200;
  }

  @override
  Future<ProCatalogModel> getCatalog() async {
    try {
      final Map<String, dynamic> response;
      if (ProMockApi.useMockResponses) {
        response = await mockApi.getCatalogSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.membershipCatalog);
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
        endpoint: AppUrls.membershipCatalog,
      );
      return Future.error(message);
    }
  }
}
