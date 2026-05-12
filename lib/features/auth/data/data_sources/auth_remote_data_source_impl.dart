import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/jwt_utils.dart';
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

  String? _extractUserId(Map<String, dynamic> response) {
    final data = response['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final directUserId = dataMap['userId'] ?? response['userId'];
    if (directUserId != null) {
      return directUserId.toString();
    }

    final accessToken = dataMap['accessToken'];
    final accessTokenMap = accessToken is Map<String, dynamic>
        ? accessToken
        : <String, dynamic>{};
    final token =
        (dataMap['token'] ?? accessTokenMap['token'] ?? '').toString();
    final tokenUserId = JwtUtils.claim<dynamic>(token, 'userId');
    return tokenUserId?.toString();
  }

  String _normalizeMsisdn(String phoneNumber) {
    var digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (!digits.startsWith('92')) {
      digits = '92$digits';
    }
    return digits;
  }

  @override
  Future<AuthResponseModel> requestOtp(RequestOtpParams params) async {
    try {
      final Map<String, dynamic> response;
      if (AuthMockApi.useMockResponses) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        response = await authMockApi.requestOtpSuccessResponse(
          phoneNumber: _normalizeMsisdn(params.phoneNumber),
          channel: params.channel,
        );
      } else {
        response = await apiService.post(
          AppUrls.requestOtp,
          data: <String, dynamic>{
            'msisdn': _normalizeMsisdn(params.phoneNumber),
            'channel': params.channel,
          },
        );
        log('requestOtp response: $response');
      }

      if (response['success'] == true) {
        final mapped = AuthResponseModel.fromJson(response);
        if (mapped.isOnboardingCompleted) {
          final userId = _extractUserId(response);
          if (userId != null && userId.isNotEmpty && !AuthMockApi.useMockResponses) {
            final profileResponse = await apiService.get(
              AppUrls.userProfileById(userId),
            );
            if (profileResponse['success'] == true) {
              final profileData = profileResponse['data'];
              if (profileData is Map<String, dynamic>) {
                final data = response['data'];
                final dataMap = data is Map<String, dynamic>
                    ? Map<String, dynamic>.from(data)
                    : <String, dynamic>{};
                dataMap['user'] = profileData;
                response['data'] = dataMap;
              }
            }
          }
        }
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
            'msisdn': _normalizeMsisdn(params.phoneNumber),
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
