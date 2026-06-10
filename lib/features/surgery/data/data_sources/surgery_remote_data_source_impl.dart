import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/surgery_booking_request_entity.dart';
import '../mock/surgery_checkout_mock_api.dart';
import '../mock/surgery_doctors_mock_api.dart';
import '../mock/surgery_mock_api.dart';
import '../mock/surgery_patient_form_mock_api.dart';
import '../models/surgery_content_model.dart';
import '../models/surgery_doctor_model.dart';
import '../models/surgery_patient_form_model.dart';
import 'surgery_remote_data_source.dart';

class SurgeryRemoteDataSourceImpl implements SurgeryRemoteDataSource {
  SurgeryRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.doctorsMockApi,
    required this.patientFormMockApi,
    required this.checkoutMockApi,
  });

  final ApiService apiService;
  final SurgeryMockApi mockApi;
  final SurgeryDoctorsMockApi doctorsMockApi;
  final SurgeryPatientFormMockApi patientFormMockApi;
  final SurgeryCheckoutMockApi checkoutMockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<SurgeryContentModel> getSurgeryContent() async {
    try {
      final Map<String, dynamic> response;
      if (SurgeryMockApi.useMockResponses) {
        response = await mockApi.getSurgeryContentSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.surgeryProcedures);
        log('getSurgeryContent response: $response');
      }

      if (_isSuccessResponse(response)) {
        return SurgeryContentModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getSurgeryContent error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryProcedures,
      );
      return Future.error(message);
    }
  }

  @override
  Future<SurgeryDoctorsResponseModel> getSurgeryDoctors({
    required String surgeryId,
    required String procedureName,
    required String city,
    required String cityId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (SurgeryDoctorsMockApi.useMockResponses) {
        response = await doctorsMockApi.getSurgeryDoctorsSuccessResponse(
          surgeryId: surgeryId,
          procedureName: procedureName,
          city: city,
          cityId: cityId,
        );
      } else {
        response = await apiService.get(
          AppUrls.surgeryProviders(surgeryId: surgeryId, cityId: cityId),
        );
        log('getSurgeryDoctors response: $response');
      }

      if (_isSuccessResponse(response)) {
        return SurgeryDoctorsResponseModel.fromJson(
          response,
          procedureName: procedureName,
          city: city,
        );
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getSurgeryDoctors error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryProviders(
          surgeryId: surgeryId,
          cityId: cityId,
        ),
      );
      return Future.error(message);
    }
  }

  @override
  Future<SurgeryPatientFormModel> getSurgeryPatientForm({
    required String doctorId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (true) {
        response = await patientFormMockApi.getPatientFormSuccessResponse(
          doctorId: doctorId,
        );
      } else {
        response = await apiService.get(AppUrls.surgeryPatientForm(doctorId));
        log('getSurgeryPatientForm response: $response');
      }

      if (response['success'] == true) {
        return SurgeryPatientFormModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getSurgeryPatientForm error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryPatientForm(doctorId),
      );
      return Future.error(message);
    }
  }

  @override
  Future<void> submitSurgeryBooking(SurgeryBookingRequestEntity request) async {
    try {
      final Map<String, dynamic> response;
      if (SurgeryCheckoutMockApi.useMockResponses) {
        response = await checkoutMockApi.submitSurgeryBooking(
          patientName: request.patientName,
          age: request.age,
          contactNumber: request.contactNumber,
          emergencyContact: request.emergencyContact,
          surgeryName: request.surgeryName,
          doctorName: request.doctorName,
          hospitalName: request.hospitalName,
        );
      } else {
        response = await apiService.post(
          AppUrls.surgeryBooking,
          data: {
            'patientName': request.patientName,
            'age': request.age,
            'contactNumber': request.contactNumber,
            'emergencyContact': request.emergencyContact,
            'surgeryName': request.surgeryName,
            'doctorName': request.doctorName,
            'hospitalName': request.hospitalName,
          },
        );
        log('submitSurgeryBooking response: $response');
      }

      if (response['success'] == true) {
        return;
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('submitSurgeryBooking error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryBooking,
      );
      return Future.error(message);
    }
  }
}
