import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../mock/app_version_mock_api.dart';
import '../mock/dashboard_services_mock_api.dart';
import '../mock/promotional_banner_mock_api.dart';
import '../models/app_version_model.dart';
import '../models/promotional_banner_model.dart';
import '../models/our_service_model.dart';
import 'dashboard_remote_data_source.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({
    required this.apiService,
    required this.appPref,
    required this.mockApi,
    required this.promotionalBannerMockApi,
    required this.appVersionMockApi,
  });

  final ApiService apiService;
  final AppPref appPref;
  final DashboardServicesMockApi mockApi;
  final PromotionalBannerMockApi promotionalBannerMockApi;
  final AppVersionMockApi appVersionMockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<OurServicesModel> getOurServices() async {
    try {
      final Map<String, dynamic> response;
      if (DashboardServicesMockApi.useMockResponses) {
        response = await mockApi.getDashboardServicesSuccessResponse();
      } else {
        final token = appPref.getToken();
        if (token.isNotEmpty && JwtUtils.isExpired(token)) {
          log('getOurServices: access token expired, refresh should run via interceptor');
        }
        response = await apiService.get(AppUrls.home);
        log('getOurServices response: $response');
      }

      if (_isSuccessResponse(response)) {
        return OurServicesModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.ourServicesLoadError).toString();
      return Future.error(message);
    } on ApiUnauthorizedException catch (e) {
      log('getOurServices unauthorized: $e');
      final msg = e.message.trim();
      return Future.error(
        msg.isNotEmpty
            ? msg
            : 'Session expired. Please log in again.',
      );
    } catch (e) {
      log('getOurServices error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.home,
      );
      return Future.error(message);
    }
  }

  @override
  Future<PromotionalBannerResponseModel> getPromotionalBanner() async {
    try {
      final Map<String, dynamic> response;
      if (PromotionalBannerMockApi.useMockResponses) {
        response = await promotionalBannerMockApi
            .getPromotionalBannerSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.promotionalBanner);
        log('getPromotionalBanner response: $response');
      }

      if (_isSuccessResponse(response)) {
        return PromotionalBannerResponseModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.ourServicesLoadError).toString();
      return Future.error(message);
    } catch (e) {
      log('getPromotionalBanner error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.promotionalBanner,
      );
      return Future.error(message);
    }
  }

  @override
  Future<AppVersionResponseModel> getAppVersion({
    required String platform,
  }) async {
    final endpoint = AppUrls.appVersion(platform: platform);
    try {
      final Map<String, dynamic> response;
      if (AppVersionMockApi.useMockResponses) {
        response = await appVersionMockApi.getAppVersionSuccessResponse(
          platform: platform,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getAppVersion ($platform) response: $response');
      }

      if (_isSuccessResponse(response)) {
        return AppVersionResponseModel.fromJson(response);
      }

      // CMS returns HTTP 200 + code 404 when no version is configured.
      final code = response['code'];
      if (code is num && code.toInt() == 404) {
        return AppVersionResponseModel(
          success: false,
          message: (response['message'] ?? '').toString(),
          version: AppVersionModel.empty,
        );
      }

      final message =
          (response['message'] ?? AppStrings.ourServicesLoadError).toString();
      return Future.error(message);
    } on ApiNotFoundException catch (e) {
      log('getAppVersion not found: $e');
      return AppVersionResponseModel(
        success: false,
        message: e.message,
        version: AppVersionModel.empty,
      );
    } catch (e) {
      log('getAppVersion error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: endpoint,
      );
      return Future.error(message);
    }
  }
}
