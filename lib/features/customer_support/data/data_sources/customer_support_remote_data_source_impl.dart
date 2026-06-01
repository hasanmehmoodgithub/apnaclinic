import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/customer_support_mock_api.dart';
import '../models/support_settings_model.dart';
import 'customer_support_remote_data_source.dart';

class CustomerSupportRemoteDataSourceImpl
    implements CustomerSupportRemoteDataSource {
  CustomerSupportRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final CustomerSupportMockApi mockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<SupportSettingsResponseModel> getSupportSettings() async {
    try {
      final Map<String, dynamic> response;
      if (CustomerSupportMockApi.useMockResponses) {
        response = await mockApi.getSupportSettingsSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.mobileSupport);
        log('getSupportSettings response: $response');
      }

      if (_isSuccessResponse(response)) {
        return SupportSettingsResponseModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.customerSupportLoadError)
              .toString();
      return Future.error(message);
    } catch (e) {
      log('getSupportSettings error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.mobileSupport,
      );
      return Future.error(message);
    }
  }
}
