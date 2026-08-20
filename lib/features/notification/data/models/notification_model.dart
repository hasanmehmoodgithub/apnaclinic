import 'package:intl/intl.dart';

class NotificationItemModel {
  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.date,
    required this.type,
    required this.serviceType,
    required this.isRead,
    required this.entityId,
    required this.entityKind,
    required this.deepLinkEndpoint,
    required this.priority,
    this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final String time;
  final String date;
  final String type;
  final String serviceType;
  final bool isRead;
  final String entityId;
  final String entityKind;
  final String deepLinkEndpoint;
  final String priority;
  final DateTime? createdAt;

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    final deepLink = _asMap(json['deepLink'] ?? json['deep_link']);
    final deepData = _asMap(deepLink?['data']);
    final entity = _asMap(deepLink?['entity']);
    final createdAt = _parseDateTime(json['createdAt'] ?? json['created_at']);
    final labels = _formatCreatedAt(createdAt);

    return NotificationItemModel(
      id: _readString(json, const ['publicId', 'public_id', 'id']),
      title: _readString(json, const ['title']),
      message: _readString(json, const ['body', 'message']),
      time: labels.$1,
      date: labels.$2,
      type: _readString(json, const ['type']),
      serviceType: _readString(json, const [
        'serviceType',
        'service_type',
      ], nested: deepData, nestedKeys: const ['service_type', 'serviceType']),
      isRead: _isRead(json),
      entityId: _resolveEntityId(entity: entity, deepData: deepData),
      entityKind: _readString(
        entity ?? const {},
        const ['kind'],
        nested: deepData,
        nestedKeys: const ['entity_kind', 'entityKind'],
      ),
      deepLinkEndpoint: _readString(
        deepLink ?? const {},
        const ['endpoint'],
      ),
      priority: _readString(json, const ['priority']),
      createdAt: createdAt,
    );
  }

  static bool _isRead(Map<String, dynamic> json) {
    if (_asBool(json['isRead'] ?? json['is_read'])) return true;
    final readAt = json['readAt'] ?? json['read_at'];
    if (readAt == null) return false;
    final text = readAt.toString().trim();
    return text.isNotEmpty && text.toLowerCase() != 'null';
  }

  static bool _asBool(dynamic value) {
    if (value == true || value == 1) return true;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  static String _resolveEntityId({
    required Map<String, dynamic>? entity,
    required Map<String, dynamic>? deepData,
  }) {
    final fromEntity = entity?['id'];
    if (fromEntity != null && fromEntity.toString().trim().isNotEmpty) {
      return fromEntity.toString().trim();
    }
    return _readString(
      deepData ?? const {},
      const ['entity_id', 'entityId'],
    );
  }

  static (String time, String date) _formatCreatedAt(DateTime? createdAt) {
    if (createdAt == null) return ('', '');
    final local = createdAt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final time = DateFormat('h:mm a').format(local).toLowerCase();

    if (day == today) {
      return (time, 'Today, ${DateFormat('d MMMM').format(local)}');
    }
    if (day == today.subtract(const Duration(days: 1))) {
      return (time, 'Yesterday, ${DateFormat('d MMMM').format(local)}');
    }
    return (time, DateFormat('d MMMM').format(local));
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    Map<String, dynamic>? nested,
    List<String>? nestedKeys,
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    if (nested != null && nestedKeys != null) {
      for (final key in nestedKeys) {
        final value = nested[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
    }
    return '';
  }
}

class NotificationsResponseModel {
  const NotificationsResponseModel({
    required this.notifications,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<NotificationItemModel> notifications;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final root = _resolveRoot(json);
    final rawList = root['items'] ??
        root['notifications'] ??
        root['data'] ??
        json['items'] ??
        <dynamic>[];
    final list = (rawList is List ? rawList : <dynamic>[])
        .whereType<Map>()
        .map((item) => NotificationItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);

    return NotificationsResponseModel(
      notifications: list,
      page: _readInt(root, 'page', fallback: 1),
      limit: _readInt(root, 'limit', fallback: 20),
      total: _readInt(root, 'total', fallback: list.length),
      totalPages: _readInt(root, 'totalPages', fallback: 1),
    );
  }

  static Map<String, dynamic> _resolveRoot(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  static int _readInt(
    Map<String, dynamic> json,
    String key, {
    required int fallback,
  }) {
    final value = json[key];
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
