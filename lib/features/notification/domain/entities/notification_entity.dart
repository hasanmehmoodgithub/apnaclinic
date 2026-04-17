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
}
