import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications({
    int page = 1,
    int limit = 20,
  });

  Future<void> markNotificationRead({required String publicId});
}
