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
      serviceType: model.serviceType,
      isRead: model.isRead,
      entityId: model.entityId,
      entityKind: model.entityKind,
      unifiedOrderId: model.unifiedOrderId,
      entityPublicId: model.entityPublicId,
      deepLinkEndpoint: model.deepLinkEndpoint,
      priority: model.priority,
      createdAt: model.createdAt,
    );
  }

  static List<NotificationEntity> toEntityList(
    NotificationsResponseModel model,
  ) {
    return model.notifications.map(toEntity).toList(growable: false);
  }
}
