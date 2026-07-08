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

  @override
  Future<void> sendSubscriptionOtp({
    required String msisdn,
    required int productId,
    required String uuid,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (InstantDoctorMockApi.useMockResponses) {
        response = await mockApi.sendOtpSuccessResponse(
          msisdn: msisdn,
          productId: productId,
          uuid: uuid,
        );
      } else {
        response = await apiService.post(
          AppUrls.instantDoctorSendOtp,
          data: <String, dynamic>{
            'msisdn': msisdn,
            'productId': productId,
            'uuid': uuid,
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
  Future<void> verifySubscriptionOtp({
    required String msisdn,
    required int productId,
    required String otp,
    required String uuid,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (InstantDoctorMockApi.useMockResponses) {
        response = await mockApi.verifyOtpResponse(
          msisdn: msisdn,
          productId: productId,
          otp: otp,
          uuid: uuid,
        );
      } else {
        response = await apiService.post(
          AppUrls.instantDoctorVerifyOtp,
          data: <String, dynamic>{
            'msisdn': msisdn,
            'productId': productId,
            'otp': otp,
            'uuid': uuid,
          },
        );
        log('verifySubscriptionOtp response: $response');
      }

      if (_isSuccessResponse(response)) return;

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

  @override
  Future<void> cancelSubscription({
    required String msisdn,
    required int productId,
  }) async {
    try {
      final Map<String, dynamic> response;
      if (InstantDoctorMockApi.useMockResponses) {
        response = await mockApi.cancelSubscriptionSuccessResponse(
          msisdn: msisdn,
          productId: productId,
        );
      } else {
        response = await apiService.post(
          AppUrls.instantDoctorCancelSubscription,
          data: <String, dynamic>{
            'msisdn': msisdn,
            'productId': productId,
          },
        );
        log('cancelSubscription response: $response');
      }

      if (_isSuccessResponse(response)) return;

      final message = (response['message'] ??
              AppStrings.instantDoctorCancelSubscriptionError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('cancelSubscription error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.instantDoctorCancelSubscription,
      );
      return Future.error(message);
    }
  }
}
