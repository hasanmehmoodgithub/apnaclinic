import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/models/profile_setup_data.dart';
import '../mock/profile_setup_mock_api.dart';
import '../models/profile_setup_model.dart';
import 'profile_setup_remote_data_source.dart';

class ProfileSetupRemoteDataSourceImpl implements ProfileSetupRemoteDataSource {
  ProfileSetupRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final ProfileSetupMockApi mockApi;

  @override
  Future<ProfileSetupResponseModel> getProfileSetupContent() async {
    try {
      final Map<String, dynamic> response;
      if (ProfileSetupMockApi.useMockResponses) {
        response = await mockApi.getProfileSetupSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.profileSetup);
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
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.profileSetup,
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
        response = await apiService.post(
          AppUrls.saveProfileSetup,
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
