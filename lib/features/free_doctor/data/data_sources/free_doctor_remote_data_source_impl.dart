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

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<FreeDoctorResponseModel> getFreeDoctorContent({
    required String msisdn,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (FreeDoctorMockApi.useMockResponses) {
        response = await mockApi.getFreeDoctorSuccessResponse(msisdn: msisdn);
      } else {
        final endpoint = AppUrls.instantDoctorConsultation(msisdn);
        response = await apiService.get(endpoint);
        log('getFreeDoctorContent response: $response');
      }

      if (_isSuccessResponse(response)) {
        return FreeDoctorResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.freeDoctorLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getFreeDoctorContent error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.instantDoctorConsultation(msisdn),
      );
      return Future.error(message);
    }
  }
}
