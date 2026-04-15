import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/dashboard_services_mock_api.dart';
import '../models/our_service_model.dart';
import 'dashboard_remote_data_source.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final DashboardServicesMockApi mockApi;

  @override
  Future<OurServicesModel> getOurServices() async {
    try {
      final Map<String, dynamic> response;
      if (DashboardServicesMockApi.useMockResponses) {
        response = await mockApi.getDashboardServicesSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.ourServices);
        log('getOurServices response: $response');
      }

      if (response['success'] == true) {
        final responseModel = OurServicesModel.fromJson(response);
        return Future.value(responseModel);
      }

      final message =
          (response['message'] ?? AppStrings.ourServicesLoadError)
              .toString();
      return Future.error(message);
    } catch (e) {
      log('getOurServices error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.ourServices,
      );
      return Future.error(message);
    }
  }
}

