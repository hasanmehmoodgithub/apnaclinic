import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../mock/notification_mock_api.dart';
import '../models/notification_model.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final NotificationMockApi mockApi;

  @override
  Future<NotificationsResponseModel> getNotifications() async {
    try {
      final Map<String, dynamic> response;
      if (NotificationMockApi.useMockResponses) {
        response = await mockApi.getNotificationsSuccessResponse();
      } else {
        response = await apiService.get(AppUrls.notifications);
        log('getNotifications response: $response');
      }

      if (response['success'] == true) {
        final responseModel = NotificationsResponseModel.fromJson(response);
        return Future.value(responseModel);
      }

      final message =
          (response['message'] ?? AppStrings.notificationsLoadError).toString();
      return Future.error(message);
    } catch (e) {
      log('getNotifications error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.notifications,
      );
      return Future.error(message);
    }
  }
}
