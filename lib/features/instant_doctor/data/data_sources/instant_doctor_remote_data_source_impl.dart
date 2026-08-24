import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/use_cases/get_instant_doctor_bookings_params.dart';
import '../mock/instant_doctor_mock_api.dart';
import '../models/instant_doctor_booking_model.dart';
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

  @override
  Future<InstantDoctorBookingsPageModel> getBookings(
    GetInstantDoctorBookingsParams params,
  ) async {
    final endpoint = AppUrls.instantDoctorBookings(
      page: params.page,
      limit: params.limit,
    );
    try {
      final Map<String, dynamic> response;
      if (InstantDoctorMockApi.useMockResponses) {
        response = await mockApi.getBookingsSuccessResponse(
          page: params.page,
          limit: params.limit,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getInstantDoctorBookings response: $response');
      }

      if (_isBookingsSuccessResponse(response)) {
        return InstantDoctorBookingsPageModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.instantDoctorBookingsLoadError)
              .toString();
      return Future.error(message);
    } catch (e) {
      log('getInstantDoctorBookings error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: endpoint,
      );
      return Future.error(message);
    }
  }

  static bool _isBookingsSuccessResponse(Map<String, dynamic> response) {
    if (_isSuccessResponse(response)) return true;
    final data = response['data'];
    return data is Map || data is List;
  }

  @override
  Future<void> sendSubscriptionOtp({
    required String msisdn,
    required int productId,
    required String uuid,
    required String action,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (InstantDoctorMockApi.useMockResponses) {
        response = await mockApi.sendOtpSuccessResponse(
          msisdn: msisdn,
          productId: productId,
          uuid: uuid,
          action: action,
        );
      } else {
        response = await apiService.post(
          AppUrls.instantDoctorSendOtp,
          data: <String, dynamic>{
            'msisdn': msisdn,
            'productId': productId,
            'uuid': uuid,
            'action': action,
          },
        );
        log('sendSubscriptionOtp response: $response');
      }

      if (_isSuccessResponse(response)) return;

      final message = (response['message'] ?? AppStrings.instantDoctorSendOtpError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('sendSubscriptionOtp error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.instantDoctorSendOtp,
      );
      return Future.error(message);
    }
  }

  @override
  Future<InstantDoctorVerifyOtpResultModel> verifySubscriptionOtp({
    required String msisdn,
    required int productId,
    required String otp,
    required String uuid,
    required String action,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (InstantDoctorMockApi.useMockResponses) {
        response = await mockApi.verifyOtpResponse(
          msisdn: msisdn,
          productId: productId,
          otp: otp,
          uuid: uuid,
          action: action,
        );
      } else {
        response = await apiService.post(
          AppUrls.instantDoctorVerifyOtp,
          data: <String, dynamic>{
            'msisdn': msisdn,
            'productId': productId,
            'otp': otp,
            'uuid': uuid,
            'action': action,
          },
        );
        log('verifySubscriptionOtp response: $response');
      }

      if (_isSuccessResponse(response)) {
        final data = response['data'];
        if (data is Map<String, dynamic>) {
          return InstantDoctorVerifyOtpResultModel.fromJson(data);
        }
        return const InstantDoctorVerifyOtpResultModel(
          resultCode: '',
          status: '',
          transactionId: '',
          description: '',
          redirectUrl: '',
        );
      }

      final message =
          (response['message'] ?? AppStrings.instantDoctorVerifyOtpError)
              .toString();
      return Future.error(message);
    } catch (e) {
      log('verifySubscriptionOtp error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.instantDoctorVerifyOtp,
      );
      return Future.error(message);
    }
  }

}
