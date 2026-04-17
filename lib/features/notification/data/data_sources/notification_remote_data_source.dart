import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications();
}
