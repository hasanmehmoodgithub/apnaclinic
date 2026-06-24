import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/instant_doctor_mock_api.dart';
import '../models/instant_doctor_model.dart';
import 'instant_doctor_remote_data_source.dart';

class InstantDoctorRemoteDataSourceImpl implements InstantDoctorRemoteDataSource {
  InstantDoctorRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final InstantDoctorMockApi mockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<InstantDoctorResponseModel> getInstantDoctorContent({
    required String msisdn,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (InstantDoctorMockApi.useMockResponses) {
        response = await mockApi.getInstantDoctorSuccessResponse(msisdn: msisdn);
      } else {
        final endpoint = AppUrls.instantDoctorConsultation(msisdn);
        response = await apiService.get(endpoint);
        log('getInstantDoctorContent response: $response');
      }

      if (_isSuccessResponse(response)) {
        return InstantDoctorResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.instantDoctorLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getInstantDoctorContent error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.instantDoctorConsultation(msisdn),
      );
      return Future.error(message);
    }
  }
}
