import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

class NotificationMapper {
  static NotificationEntity toEntity(NotificationItemModel model) {
    return NotificationEntity(
      id: model.id,
      title: model.title,
      message: model.message,
      timeLabel: model.time,
      dateLabel: model.date,
      type: model.type,
      isRead: model.isRead,
    );
  }

  static List<NotificationEntity> toEntityList(NotificationsResponseModel model) {
    return model.notifications.map(toEntity).toList();
  }
}
