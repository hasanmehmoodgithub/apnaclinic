import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/customer_support_mock_api.dart';
import '../models/customer_support_model.dart';
import 'customer_support_remote_data_source.dart';

class CustomerSupportRemoteDataSourceImpl
    implements CustomerSupportRemoteDataSource {
  CustomerSupportRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final CustomerSupportMockApi mockApi;

  @override
  Future<CustomerSupportResponseModel> getCustomerSupportContent() async {
    try {
      final Map<String, dynamic> response;
      if (CustomerSupportMockApi.useMockResponses) {
        response = await mockApi.getCustomerSupportSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.customerSupport);
        log('getCustomerSupportContent response: $response');
      }

      if (response['success'] == true) {
        final responseModel = CustomerSupportResponseModel.fromJson(response);
        return Future.value(responseModel);
      }

      final message =
          (response['message'] ?? AppStrings.customerSupportLoadError)
              .toString();
      return Future.error(message);
    } catch (e) {
      log('getCustomerSupportContent error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.customerSupport,
      );
      return Future.error(message);
    }
  }
}
