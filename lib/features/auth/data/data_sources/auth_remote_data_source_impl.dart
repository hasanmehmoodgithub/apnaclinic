import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/auth_api_utils.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import '../mock/auth_mock_api.dart';
import '../models/auth_response_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this.apiService,
  });

  final ApiService apiService;

  @override
  Future<AuthResponseModel> requestOtp(RequestOtpParams params) async {
    try {
      final Map<String, dynamic> response;
      if (AuthMockApi.useMockResponses) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        response = await AuthMockApi().requestOtpSuccessResponse(
          phoneNumber: AuthApiUtils.normalizeMsisdn(params.phoneNumber),
          channel: params.channel,
        );
      } else {
        response = await apiService.post(
          AppUrls.requestOtp,
          data: <String, dynamic>{
            'msisdn': AuthApiUtils.normalizeMsisdn(params.phoneNumber),
            'channel': params.channel,
          },
        );
        log('requestOtp response: $response');
      }

      if (response['success'] == true) {
        return Future.value(AuthResponseModel.fromJson(response));
      }

      final message = (response['message'] ?? AppStrings.authRequestOtpError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('requestOtp error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.requestOtp,
      );
      return Future.error(message);
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp(VerifyOtpParams params) async {
    try {
      final Map<String, dynamic> response;
      if (AuthMockApi.useMockResponses) {
        await Future<void>.delayed(const Duration(milliseconds: 700));
        response = await  AuthMockApi().verifyOtpSuccessResponse(
          phoneNumber: params.phoneNumber,
          otp: params.otp,
        );
      } else {
        final payload = <String, dynamic>{
          'msisdn': AuthApiUtils.normalizeMsisdn(params.phoneNumber),
          'otp': params.otp,
        };
        final fcmToken = params.fcmToken?.trim();
        if (fcmToken != null && fcmToken.isNotEmpty) {
          payload['fcmToken'] = fcmToken;
        }
        response = await apiService.post(
          AppUrls.verifyOtp,
          data: payload,
        );
        log('verifyOtp response: $response');
      }

      if (response['success'] == true) {
        return Future.value(AuthResponseModel.fromJson(response));
      }

      final message = (response['message'] ?? AppStrings.authVerifyOtpError)
          .toString();
      return Future.error(message);
    } catch (e) {
      log('verifyOtp error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.verifyOtp,
      );
      return Future.error(message);
    }
  }

  @override
  Future<void> logout(LogoutParams params) async {
    final trimmed = params.userId.trim();
    if (trimmed.isEmpty) {
      return;
    }
    if (AuthMockApi.useMockResponses) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return;
    }
    try {
      final response = await apiService.post(
        AppUrls.logout,
        data: <String, dynamic>{
          'refreshToken': params.refreshToken.trim(),
        },
      );
      if (response['success'] != true) {
        final message = (response['message'] ?? AppStrings.authLogoutError)
            .toString();
        return Future.error(message);
      }
      log('logout response ok for userId: $trimmed');
    } catch (e) {
      log('logout error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.logout,
      );
      return Future.error(message);
    }
  }
}
