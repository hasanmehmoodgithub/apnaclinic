class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.dateLabel,
    required this.type,
    required this.isRead,
  });

  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final String dateLabel;
  final String type;
  final bool isRead;

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    String? timeLabel,
    String? dateLabel,
    String? type,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timeLabel: timeLabel ?? this.timeLabel,
      dateLabel: dateLabel ?? this.dateLabel,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
