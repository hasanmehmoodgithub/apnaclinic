import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/consultation_categories_mock_api.dart';
import '../mock/consultation_doctor_slots_mock_api.dart';
import '../mock/consultation_doctors_mock_api.dart';
import '../models/consultation_category_model.dart';
import '../models/consultation_doctor_model.dart';
import '../models/consultation_doctor_slots_model.dart';
import 'consultation_remote_data_source.dart';

class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  ConsultationRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.doctorsMockApi,
    required this.slotsMockApi,
  });

  final ApiService apiService;
  final ConsultationCategoriesMockApi mockApi;
  final ConsultationDoctorsMockApi doctorsMockApi;
  final ConsultationDoctorSlotsMockApi slotsMockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<List<ConsultationCategoryModel>> getCategories() async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationCategoriesMockApi.useMockResponses) {
        response = await mockApi.getConsultationCategoriesSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.doctorCategories);
        log('getCategories response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ConsultationCategoriesResponseModel.fromJson(response).categories;
      }

      final message =
          (response['message'] ?? AppStrings.genericErrorMessage).toString();
      return Future.error(message);
    } catch (e) {
      log('getCategories error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorCategories,
      );
      return Future.error(message);
    }
  }

  @override
  Future<List<ConsultationDoctorModel>> getDoctors({
    required String mainCategoryId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationDoctorsMockApi.useMockResponses) {
        response = await doctorsMockApi.getDoctorsResponse(
          mainCategoryId: mainCategoryId,
        );
      } else {
        response = await apiService.get(
          AppUrls.doctorConsultationDoctors(mainCategoryId),
        );
        log('getDoctors response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ConsultationDoctorsResponseModel.fromJson(response).doctors;
      }

      final message =
          (response['message'] ?? AppStrings.genericErrorMessage).toString();
      return Future.error(message);
    } catch (e) {
      log('getDoctors error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorConsultationDoctors(mainCategoryId),
      );
      return Future.error(message);
    }
  }

  @override
  Future<ConsultationDoctorSlotsModel> getDoctorSlots({
    required String doctorId,
    String? hospitalId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationDoctorSlotsMockApi.useMockResponses) {
        response = await slotsMockApi.getDoctorSlotsSuccessResponse(
          doctorId: doctorId,
        );
      } else {
        response = await apiService.get(
          AppUrls.doctorConsultationSlots(
            doctorId: doctorId,
            hospitalId: hospitalId,
          ),
        );
        log('getDoctorSlots response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ConsultationDoctorSlotsModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.genericErrorMessage).toString();
      return Future.error(message);
    } catch (e) {
      log('getDoctorSlots error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorConsultationSlots(
          doctorId: doctorId,
          hospitalId: hospitalId,
        ),
      );
      return Future.error(message);
    }
  }
}
