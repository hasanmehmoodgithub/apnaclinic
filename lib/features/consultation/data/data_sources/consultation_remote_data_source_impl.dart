import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../mock/consultation_booking_mock_api.dart';
import '../mock/consultation_bookings_list_mock_api.dart';
import '../mock/payment_providers_mock_api.dart';
import '../mock/consultation_categories_mock_api.dart';
import '../mock/consultation_doctor_slots_mock_api.dart';
import '../mock/consultation_doctors_mock_api.dart';
import '../models/consultation_booking_form_data.dart';
import '../models/consultation_booking_list_model.dart';
import '../models/consultation_category_model.dart';
import '../models/consultation_doctor_model.dart';
import '../models/consultation_doctor_slots_model.dart';
import '../models/payment_provider_model.dart';
import '../../domain/use_cases/abandon_consultation_booking_use_case.dart';
import '../../domain/use_cases/submit_consultation_booking_use_case.dart';
import '../../domain/use_cases/submit_consultation_feedback_use_case.dart';
import 'consultation_remote_data_source.dart';

class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  ConsultationRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.doctorsMockApi,
    required this.slotsMockApi,
    required this.bookingMockApi,
    required this.bookingsListMockApi,
    required this.paymentProvidersMockApi,
  });

  final ApiService apiService;
  final ConsultationCategoriesMockApi mockApi;
  final ConsultationDoctorsMockApi doctorsMockApi;
  final ConsultationDoctorSlotsMockApi slotsMockApi;
  final ConsultationBookingMockApi bookingMockApi;
  final ConsultationBookingsListMockApi bookingsListMockApi;
  final PaymentProvidersMockApi paymentProvidersMockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  static bool _isBookingSubmitSuccess(Map<String, dynamic> response) {
    if (response.isEmpty) return true;
    return _isSuccessResponse(response);
  }

  static bool _isSuccessfulHttpStatus(int? statusCode) {
    final code = statusCode ?? 0;
    return code >= 200 && code < 300;
  }

  static bool _isSuccessfulBookingTransportError(dynamic error) {
    if (error is DioException) {
      return _isSuccessfulHttpStatus(error.response?.statusCode);
    }
    if (error is ApiException) {
      return _isSuccessfulHttpStatus(error.statusCode);
    }
    return false;
  }

  @override
  Future<ConsultationCategoriesResponseModel> getCategories() async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationCategoriesMockApi.useMockResponses) {
        response = await mockApi.getConsultationCategoriesSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.doctorCategories);
        log('getCategories response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ConsultationCategoriesResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
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
  Future<ConsultationDoctorsResponseModel> getDoctors({
    required String mainCategoryId,
    String? partnerId,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationDoctorsMockApi.useMockResponses) {
        response = await doctorsMockApi.getDoctorsResponse(
          mainCategoryId: mainCategoryId,
          partnerId: partnerId,
          search: search,
          page: page,
          limit: limit,
        );
      } else {
        response = await apiService.get(
          AppUrls.doctorConsultationDoctors(
            mainCategoryId: mainCategoryId,
            partnerId: partnerId,
            search: search,
            page: page,
            limit: limit,
          ),
        );
        log('getDoctors response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ConsultationDoctorsResponseModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getDoctors error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorConsultationDoctors(
          mainCategoryId: mainCategoryId,
          partnerId: partnerId,
          search: search,
          page: page,
          limit: limit,
        ),
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

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
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

  @override
  Future<List<PaymentProviderModel>> getPaymentProviders({
    required String module,
  }) async {
    final endpoint = AppUrls.paymentProviders(module: module);
    try {
      final Map<String, dynamic> response;
      if (PaymentProvidersMockApi.useMockResponses) {
        response = await paymentProvidersMockApi
            .getPaymentProvidersSuccessResponse(module: module);
      } else {
        response = await apiService.get(endpoint);
        log('getPaymentProviders response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PaymentProvidersResponseModel.fromJson(response).providers;
      }

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getPaymentProviders error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: endpoint,
      );
      return Future.error(message);
    }
  }

  @override
  Future<ConsultationBookingsPageModel> getBookings({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationBookingsListMockApi.useMockResponses) {
        response = await bookingsListMockApi.getBookingsSuccessResponse(
          page: page,
          limit: limit,
        );
      } else {
        response = await apiService.get(
          AppUrls.doctorConsultationBookings(page: page, limit: limit),
        );
        log('getBookings response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ConsultationBookingsPageModel.fromJson(response);
      }

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getBookings error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorConsultationBookings(page: page, limit: limit),
      );
      return Future.error(message);
    }
  }

  @override
  Future<ConsultationBookingListItemModel> getBooking({
    required int appointmentId,
  }) async {
    final endpoint = AppUrls.doctorConsultationBookingDetail(appointmentId);
    try {
      final Map<String, dynamic> response;
      if (ConsultationBookingsListMockApi.useMockResponses) {
        response = await bookingsListMockApi.getBookingSuccessResponse(
          appointmentId: appointmentId,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getBooking response: $response');
      }

      if (_isSuccessResponse(response)) {
        final data = response['data'];
        final payload = data is Map
            ? Map<String, dynamic>.from(data)
            : <String, dynamic>{};
        return ConsultationBookingListItemModel.fromJson(payload);
      }

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('getBooking error: $e');
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<PaymentInitiationResult> submitBooking(
    SubmitConsultationBookingParams params,
  ) async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationBookingMockApi.useMockResponses) {
        response = await bookingMockApi.submitBookingSuccessResponse();
      } else {
        final formData = await consultationBookingFormData(params);
        response = await apiService.post(
          AppUrls.doctorConsultationBooking,
          data: formData,
          headers: const {'Content-Type': 'multipart/form-data'},
        );
        log('submitBooking response: $response');
      }

      if (_isBookingSubmitSuccess(response)) {
        return PaymentInitiationResult.fromBookingResponse(response);
      }

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('submitBooking error: $e');
      if (_isSuccessfulBookingTransportError(e)) {
        return const PaymentInitiationResult();
      }
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorConsultationBooking,
      );
      return Future.error(message);
    }
  }

  @override
  Future<Map<String, dynamic>> abandonBooking(
    AbandonConsultationBookingParams params,
  ) async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationBookingMockApi.useMockResponses) {
        response = await bookingMockApi.abandonBookingSuccessResponse(params);
      } else {
        response = await apiService.post(
          AppUrls.doctorConsultationBookingAbandon,
          data: params.toJson(),
        );
        log('abandonBooking response: $response');
      }

      if (_isSuccessResponse(response)) {
        return response;
      }

      final message =
          (response['message'] ?? AppStrings.consultationAbandonOrderError)
              .toString();
      return Future.error(message);
    } catch (e) {
      log('abandonBooking error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorConsultationBookingAbandon,
      );
      return Future.error(message);
    }
  }

  @override
  Future<void> submitFeedback(SubmitConsultationFeedbackParams params) async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationBookingMockApi.useMockResponses) {
        response = await bookingMockApi.submitFeedbackSuccessResponse();
      } else {
        response = await apiService.post(
          AppUrls.doctorConsultationFeedback,
          data: {
            'refNo': params.refNo,
            'rating': params.rating,
            'review': params.review,
          },
        );
        log('submitFeedback response: $response');
      }

      if (_isSuccessResponse(response)) {
        return;
      }

      final message = (response['message'] ?? AppStrings.genericErrorMessage)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('submitFeedback error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.doctorConsultationFeedback,
      );
      return Future.error(message);
    }
  }
}
