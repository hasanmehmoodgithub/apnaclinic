import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/lab_test_mock_api.dart';
import '../models/lab_test_catalog_model.dart';
import 'lab_test_remote_data_source.dart';

class LabTestRemoteDataSourceImpl implements LabTestRemoteDataSource {
  LabTestRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final LabTestMockApi mockApi;

  @override
  Future<LabTestCatalogResponseModel> getLabTestCatalog() async {
    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.getLabTestCatalogSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.labTestCatalog);
        log('getLabTestCatalog response: $response');
      }

      if (response['success'] == true) {
        return Future.value(LabTestCatalogResponseModel.fromJson(response));
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.labTestCatalog,
      );
      return Future.error(message);
    }
  }
}
