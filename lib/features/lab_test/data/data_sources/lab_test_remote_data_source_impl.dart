import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/lab_test_mock_api.dart';
import '../models/lab_test_catalog_model.dart';
import '../models/lab_test_detail_response_model.dart';
import '../models/lab_test_mobile_tests_response_model.dart';
import 'lab_test_remote_data_source.dart';

class LabTestRemoteDataSourceImpl implements LabTestRemoteDataSource {
  LabTestRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final LabTestMockApi mockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

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

      if (_isSuccessResponse(response)) {
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

  @override
  Future<LabTestMobileTestsResponseModel> getLabTests({
    required String cityId,
    int page = 1,
    int limit = 20,
    String? search,
    String? labId,
  }) async {
    final endpoint = AppUrls.labTests(
      cityId: cityId,
      page: page,
      limit: limit,
      search: search,
      labId: labId,
    );

    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.getLabTestsSuccessResponse(
          cityId: cityId,
          page: page,
          limit: limit,
          search: search,
          labId: labId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getLabTests response: $response');
      }

      if (_isSuccessResponse(response)) {
        return LabTestMobileTestsResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<LabTestDetailResponseModel> getLabTestDetail({
    required int testId,
    required String cityId,
  }) async {
    final endpoint = AppUrls.labTestDetail(testId: testId, cityId: cityId);

    try {
      final Map<String, dynamic> response;
      if (LabTestMockApi.useMockResponses) {
        response = await mockApi.getLabTestDetailSuccessResponse(
          testId: testId,
          cityId: cityId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getLabTestDetail response: $response');
      }

      if (_isSuccessResponse(response)) {
        return LabTestDetailResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.ourServicesLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }
}
