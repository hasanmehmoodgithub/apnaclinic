import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../../domain/entities/surgery_booking_request_entity.dart';
import '../mock/surgery_checkout_mock_api.dart';
import '../mock/surgery_doctors_mock_api.dart';
import '../mock/surgery_leads_mock_api.dart';
import '../mock/surgery_mock_api.dart';
import '../mock/surgery_patient_form_mock_api.dart';
import '../mock/surgery_provider_details_mock_api.dart';
import '../models/surgery_content_model.dart';
import '../models/surgery_doctor_model.dart';
import '../models/surgery_lead_model.dart';
import '../models/surgery_patient_form_model.dart';
import '../models/surgery_provider_details_model.dart';
import 'surgery_remote_data_source.dart';

class SurgeryRemoteDataSourceImpl implements SurgeryRemoteDataSource {
  SurgeryRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.doctorsMockApi,
    required this.providerDetailsMockApi,
    required this.patientFormMockApi,
    required this.checkoutMockApi,
    required this.leadsMockApi,
  });

  final ApiService apiService;
  final SurgeryMockApi mockApi;
  final SurgeryDoctorsMockApi doctorsMockApi;
  final SurgeryProviderDetailsMockApi providerDetailsMockApi;
  final SurgeryPatientFormMockApi patientFormMockApi;
  final SurgeryCheckoutMockApi checkoutMockApi;
  final SurgeryLeadsMockApi leadsMockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<SurgeryContentModel> getSurgeryContent({String? cityId}) async {
    try {
      final Map<String, dynamic> response;
      if (SurgeryMockApi.useMockResponses) {
        response = await mockApi.getSurgeryContentSuccessResponse(
          cityId: cityId,
        );
      } else {
        response = await apiService.get(AppUrls.surgeryProcedures(cityId: cityId));
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
        endpoint: AppUrls.surgeryProcedures(cityId: cityId),
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
  Future<SurgeryProviderDetailsModel> getSurgeryProviderDetails({
    required String surgeryId,
    required String cityId,
    required String doctorId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (SurgeryProviderDetailsMockApi.useMockResponses) {
        response =
            await providerDetailsMockApi.getProviderDetailsSuccessResponse(
          surgeryId: surgeryId,
          cityId: cityId,
          doctorId: doctorId,
        );
      } else {
        response = await apiService.get(
          AppUrls.surgeryProviderDetails(
            surgeryId: surgeryId,
            cityId: cityId,
            doctorId: doctorId,
          ),
        );
        log('getSurgeryProviderDetails response: $response');
      }

      if (_isSuccessResponse(response)) {
        return SurgeryProviderDetailsModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getSurgeryProviderDetails error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryProviderDetails(
          surgeryId: surgeryId,
          cityId: cityId,
          doctorId: doctorId,
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

  static int? _parseIntId(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }

  static String _digitsOnly(String value) =>
      value.replaceAll(RegExp(r'\D'), '');

  @override
  Future<SurgeryLeadsPageModel> getSurgeryLeads({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (SurgeryLeadsMockApi.useMockResponses) {
        response = await leadsMockApi.getSurgeryLeadsSuccessResponse(
          page: page,
          limit: limit,
        );
      } else {
        response = await apiService.get(
          AppUrls.surgeryLeads(page: page, limit: limit),
        );
        log('getSurgeryLeads response: $response');
      }

      if (_isSuccessResponse(response)) {
        return SurgeryLeadsPageModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getSurgeryLeads error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryLeads(page: page, limit: limit),
      );
      return Future.error(message);
    }
  }

  @override
  Future<SurgeryLeadModel> getSurgeryLead({required int leadId}) async {
    final endpoint = AppUrls.surgeryLeadDetail(leadId);
    try {
      final Map<String, dynamic> response;
      if (SurgeryLeadsMockApi.useMockResponses) {
        response = await leadsMockApi.getSurgeryLeadSuccessResponse(
          leadId: leadId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getSurgeryLead response: $response');
      }

      if (_isSuccessResponse(response)) {
        final data = response['data'];
        final payload = data is Map
            ? Map<String, dynamic>.from(data)
            : <String, dynamic>{};
        return SurgeryLeadModel.fromJson(payload);
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getSurgeryLead error: $e');
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<String> submitSurgeryBooking(SurgeryBookingRequestEntity request) async {
    try {
      final doctorId = _parseIntId(request.doctorId);
      final surgeryId = _parseIntId(request.surgeryId);
      final packageId = _parseIntId(request.packageId);
      final cityId = _parseIntId(request.cityId);
      final age = _parseIntId(request.age);
      final phone = _digitsOnly(request.phone);
      final emergencyPhone = _digitsOnly(request.emergencyPhone);

      if (doctorId == null ||
          surgeryId == null ||
          packageId == null ||
          cityId == null ||
          age == null ||
          phone.isEmpty ||
          emergencyPhone.isEmpty) {
        return Future.error(AppStrings.surgeryLoadError);
      }

      final body = <String, dynamic>{
        'doctorId': doctorId,
        'surgeryId': surgeryId,
        'packageId': packageId,
        'cityId': cityId,
        'patient': {
          'name': request.patientName,
          'age': age,
          'gender': request.gender,
          'phone': phone,
          'emergencyPhone': emergencyPhone,
        },
      };

      final Map<String, dynamic> response;
      if (SurgeryCheckoutMockApi.useMockResponses) {
        response = await checkoutMockApi.submitSurgeryBooking(
          doctorId: doctorId,
          surgeryId: surgeryId,
          packageId: packageId,
          cityId: cityId,
          patientName: request.patientName,
          age: age,
          gender: request.gender,
          phone: phone,
          emergencyPhone: emergencyPhone,
        );
      } else {
        response = await apiService.post(
          AppUrls.surgeryBooking,
          data: body,
        );
        log('submitSurgeryBooking response: $response');
      }

      if (_isSuccessResponse(response)) {
        return _bookingIdFromResponse(response);
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

  @override
  Future<PaymentInitiationResult> bookSurgery({
    required int leadId,
    required String paymentMethod,
    required String msisdn,
  }) async {
    try {
      final body = <String, dynamic>{
        'leadId': leadId,
        'paymentMethod': paymentMethod,
        'msisdn': msisdn,
      };

      final Map<String, dynamic> response;
      if (SurgeryCheckoutMockApi.useMockResponses) {
        response = await checkoutMockApi.bookSurgery(
          leadId: leadId,
          paymentMethod: paymentMethod,
          msisdn: msisdn,
        );
      } else {
        response = await apiService.post(
          AppUrls.surgeryBookSurgery,
          data: body,
        );
        log('bookSurgery response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PaymentInitiationResult.fromBookingResponse(response);
      }

      final message = (response['message'] ?? AppStrings.surgeryLoadError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('bookSurgery error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryBookSurgery,
      );
      return Future.error(message);
    }
  }

  static String _bookingIdFromResponse(Map<String, dynamic> response) {
    Map<String, dynamic> map = response;
    final data = response['data'];
    if (data is Map) {
      final outer = Map<String, dynamic>.from(data);
      final nested = outer['data'];
      map = nested is Map ? Map<String, dynamic>.from(nested) : outer;
    }
    for (final key in [
      'bookingId',
      'booking_id',
      'leadId',
      'lead_id',
      'id',
    ]) {
      final text = map[key]?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
