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
  Future<NotificationsResponseModel> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final endpoint = AppUrls.notifications(page: page, limit: limit);
    try {
      final Map<String, dynamic> response;
      if (NotificationMockApi.useMockResponses) {
        response = await mockApi.getNotificationsSuccessResponse(
          page: page,
          limit: limit,
        );
      } else {
        response = await apiService.get(endpoint);
        log('getNotifications response: $response');
      }

      if (_isListResponse(response)) {
        return NotificationsResponseModel.fromJson(response);
      }

      final message =
          (response['message'] ?? AppStrings.notificationsLoadError).toString();
      return Future.error(message);
    } catch (e) {
      log('getNotifications error: $e');
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  @override
  Future<void> markNotificationRead({required String publicId}) async {
    final endpoint = AppUrls.notificationMarkRead(publicId);
    try {
      final Map<String, dynamic> response;
      if (NotificationMockApi.useMockResponses) {
        response = await mockApi.markNotificationReadSuccessResponse(
          publicId: publicId,
        );
      } else {
        response = await apiService.put(
          endpoint,
          data: const <String, dynamic>{},
        );
        log('markNotificationRead response: $response');
      }

      if (_isMarkReadSuccess(response)) return;

      final message =
          (response['message'] ?? AppStrings.genericErrorMessage).toString();
      return Future.error(message);
    } catch (e) {
      log('markNotificationRead error: $e');
      final message = ErrorHandler.handleExceptions(e, endpoint: endpoint);
      return Future.error(message);
    }
  }

  static bool _isListResponse(Map<String, dynamic> response) {
    if (response.containsKey('items')) return true;
    final data = response['data'];
    if (data is Map && data.containsKey('items')) return true;
    if (response['success'] == true) return true;
    if (response['code'] == 200 || response['code'] == '200') return true;
    return false;
  }

  static bool _isMarkReadSuccess(Map<String, dynamic> response) {
    if (response.isEmpty) return true;
    if (response['success'] == true) return true;
    if (response['isRead'] == true || response['is_read'] == true) return true;
    if (response['code'] == 200 || response['code'] == '200') return true;
    // HTTP 2xx with unknown body shape — treat as success.
    return !response.containsKey('success') || response['success'] != false;
  }
}
