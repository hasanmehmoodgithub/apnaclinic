class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.dateLabel,
    required this.type,
    required this.serviceType,
    required this.isRead,
    this.entityId = '',
    this.entityKind = '',
    this.deepLinkEndpoint = '',
    this.priority = '',
    this.createdAt,
  });

  /// API `publicId`.
  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final String dateLabel;

  /// Event type e.g. `BOOKING_CONFIRMED`, `BOOKING_FAILED`.
  final String type;

  /// Domain bucket e.g. `CONSULTATION`, `LAB`, `SURGERY`, `PHARMACY`.
  final String serviceType;
  final bool isRead;

  /// Booking / order id from `deepLink.data.orderId`, `entity.id`, or `entity_id`.
  final String entityId;
  final String entityKind;
  final String deepLinkEndpoint;
  final String priority;
  final DateTime? createdAt;

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    String? timeLabel,
    String? dateLabel,
    String? type,
    String? serviceType,
    bool? isRead,
    String? entityId,
    String? entityKind,
    String? deepLinkEndpoint,
    String? priority,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timeLabel: timeLabel ?? this.timeLabel,
      dateLabel: dateLabel ?? this.dateLabel,
      type: type ?? this.type,
      serviceType: serviceType ?? this.serviceType,
      isRead: isRead ?? this.isRead,
      entityId: entityId ?? this.entityId,
      entityKind: entityKind ?? this.entityKind,
      deepLinkEndpoint: deepLinkEndpoint ?? this.deepLinkEndpoint,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
