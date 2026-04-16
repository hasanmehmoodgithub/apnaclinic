import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import '../mock/auth_mock_api.dart';
import '../models/auth_response_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this.apiService,
    required this.authMockApi,
  });

  final ApiService apiService;
  final AuthMockApi authMockApi;

  @override
  Future<AuthResponseModel> requestOtp(RequestOtpParams params) async {
    try {
      final Map<String, dynamic> response;
      if (AuthMockApi.useMockResponses) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        response = await authMockApi.requestOtpSuccessResponse(
          phoneNumber: params.phoneNumber,
        );
      } else {
        response = await apiService.post(
          AppUrls.requestOtp,
          data: <String, dynamic>{'phone': params.phoneNumber},
        );
        log('requestOtp response: $response');
      }

      if (response['success'] == true) {
        return Future.value(AuthResponseModel.fromJson(response));
      }

      final message =
          (response['message'] ?? AppStrings.authRequestOtpError).toString();
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
        response = await authMockApi.verifyOtpSuccessResponse(
          phoneNumber: params.phoneNumber,
          otp: params.otp,
        );
      } else {
        response = await apiService.post(
          AppUrls.verifyOtp,
          data: <String, dynamic>{
            'phone': params.phoneNumber,
            'otp': params.otp,
          },
        );
        log('verifyOtp response: $response');
      }

      if (response['success'] == true) {
        return Future.value(AuthResponseModel.fromJson(response));
      }

      final message =
          (response['message'] ?? AppStrings.authVerifyOtpError).toString();
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
}
