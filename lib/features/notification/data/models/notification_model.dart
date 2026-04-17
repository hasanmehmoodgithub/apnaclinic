class NotificationItemModel {
  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.date,
    required this.type,
    required this.isRead,
  });

  final String id;
  final String title;
  final String message;
  final String time;
  final String date;
  final String type;
  final bool isRead;

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      isRead: json['isRead'] == true,
    );
  }
}

class NotificationsResponseModel {
  const NotificationsResponseModel({
    required this.success,
    required this.message,
    required this.notifications,
  });

  final bool success;
  final String message;
  final List<NotificationItemModel> notifications;

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['notifications'] ?? json['data'] ?? <dynamic>[];
    final list = (rawList is List ? rawList : <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(NotificationItemModel.fromJson)
        .toList();

    return NotificationsResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      notifications: list,
    );
  }
}
