import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/free_doctor_mock_api.dart';
import '../models/free_doctor_model.dart';
import 'free_doctor_remote_data_source.dart';

class FreeDoctorRemoteDataSourceImpl implements FreeDoctorRemoteDataSource {
  FreeDoctorRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final FreeDoctorMockApi mockApi;

  @override
  Future<FreeDoctorResponseModel> getFreeDoctorContent() async {
    try {
      final Map<String, dynamic> response;
      if (FreeDoctorMockApi.useMockResponses) {
        response = await mockApi.getFreeDoctorSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.freeDoctor);
        log('getFreeDoctorContent response: $response');
      }

      if (response['success'] == true) {
        final responseModel = FreeDoctorResponseModel.fromJson(response);
        return Future.value(responseModel);
      }

      final message = (response['message'] ?? AppStrings.freeDoctorLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getFreeDoctorContent error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.freeDoctor,
      );
      return Future.error(message);
    }
  }
}
