import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/consultation_categories_mock_api.dart';
import '../models/consultation_category_model.dart';
import 'consultation_remote_data_source.dart';

class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  ConsultationRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final ConsultationCategoriesMockApi mockApi;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  @override
  Future<List<ConsultationCategoryModel>> getCategories() async {
    try {
      final Map<String, dynamic> response;
      if (ConsultationCategoriesMockApi.useMockResponses) {
        response = await mockApi.getConsultationCategoriesSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.doctorCategories);
        log('getCategories response: $response');
      }

      if (_isSuccessResponse(response)) {
        return ConsultationCategoriesResponseModel.fromJson(response).categories;
      }

      final message =
          (response['message'] ?? AppStrings.genericErrorMessage).toString();
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
}
