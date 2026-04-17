import 'dart:developer';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/surgery_mock_api.dart';
import '../models/surgery_content_model.dart';
import 'surgery_remote_data_source.dart';

class SurgeryRemoteDataSourceImpl implements SurgeryRemoteDataSource {
  SurgeryRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final SurgeryMockApi mockApi;

  @override
  Future<SurgeryContentModel> getSurgeryContent() async {
    try {
      final Map<String, dynamic> response;
      if (SurgeryMockApi.useMockResponses) {
        response = await mockApi.getSurgeryContentSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.surgeryProcedures);
        log('getSurgeryContent response: $response');
      }

      if (response['success'] == true) {
        return SurgeryContentModel.fromJson(response);
      }

      return Future.error(
        (response['message'] ?? 'Failed to load surgery content').toString(),
      );
    } catch (e) {
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.surgeryProcedures,
      );
      return Future.error(message);
    }
  }
}
