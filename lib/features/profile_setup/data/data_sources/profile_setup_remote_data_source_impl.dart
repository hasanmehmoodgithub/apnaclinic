import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/models/profile_setup_data.dart';
import '../mock/profile_setup_mock_api.dart';
import '../models/profile_setup_model.dart';
import 'profile_setup_remote_data_source.dart';

class ProfileSetupRemoteDataSourceImpl implements ProfileSetupRemoteDataSource {
  ProfileSetupRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.appPref,
  });

  final ApiService apiService;
  final ProfileSetupMockApi mockApi;
  final AppPref appPref;

  @override
  Future<ProfileSetupResponseModel> getProfileSetupContent() async {
    try {
      final Map<String, dynamic> response;
      if (ProfileSetupMockApi.useMockResponses) {
        response = await mockApi.getProfileSetupSuccessResponse();
      } else {
        final userId = appPref.getUserId();
        if (userId.isEmpty) {
          return Future.error(AppStrings.profileSetupLoadError);
        }
        response = await apiService.get(AppUrls.userProfileById(userId));
        log('getProfileSetupContent response: $response');
      }

      if (response['success'] == true) {
        return ProfileSetupResponseModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.profileSetupLoadError).toString();
      return Future.error(message);
    } catch (e) {
      log('getProfileSetupContent error: $e');
      final userId = appPref.getUserId();
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: userId.isEmpty
            ? AppUrls.saveProfileSetup
            : AppUrls.userProfileById(userId),
      );
      return Future.error(message);
    }
  }

  @override
  Future<void> saveProfile(ProfileSetupData data) async {
    try {
      final Map<String, dynamic> response;
      if (ProfileSetupMockApi.useMockResponses) {
        response = await mockApi.saveProfileSuccessResponse(data);
      } else {
        response = await apiService.patch(
          AppUrls.saveProfileSetup+appPref.getUserId(),
          data: profileSetupSavePayload(data),
        );
        log('saveProfile response: $response');
      }

      if (response['success'] == true) return;

      final message =
          (response['message'] ?? AppStrings.profileSetupSaveError).toString();
      return Future.error(message);
    } catch (e) {
      log('saveProfile error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.saveProfileSetup,
      );
      return Future.error(message);
    }
  }
}
