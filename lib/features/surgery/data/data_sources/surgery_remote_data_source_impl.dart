import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/surgery_booking_request_entity.dart';
import '../mock/surgery_checkout_mock_api.dart';
import '../mock/surgery_mock_api.dart';
import '../models/surgery_content_model.dart';
import 'surgery_remote_data_source.dart';

class SurgeryRemoteDataSourceImpl implements SurgeryRemoteDataSource {
  SurgeryRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.checkoutMockApi,
  });

  final ApiService apiService;
  final SurgeryMockApi mockApi;
  final SurgeryCheckoutMockApi checkoutMockApi;

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

      if (response['success'] == true) {
        final responseModel = SurgeryContentModel.fromJson(response);
        return Future.value(responseModel);
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
