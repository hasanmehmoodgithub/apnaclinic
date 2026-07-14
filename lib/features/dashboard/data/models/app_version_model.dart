class AppVersionModel {
  const AppVersionModel({
    required this.latestVersion,
    required this.forceUpdate,
    required this.storeUrl,
    required this.isActive,
    this.minimumVersion,
    this.title,
    this.message,
  });

  final String latestVersion;
  final String? minimumVersion;
  final bool forceUpdate;
  final String storeUrl;
  final bool isActive;
  final String? title;
  final String? message;

  static const empty = AppVersionModel(
    latestVersion: '',
    forceUpdate: false,
    storeUrl: '',
    isActive: false,
  );

  bool get hasVersion => isActive && latestVersion.trim().isNotEmpty;

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'] ?? json['version'] ?? json;
    Map<String, dynamic>? data;
    if (dataRaw is Map) {
      data = Map<String, dynamic>.from(dataRaw);
    } else if (dataRaw is List && dataRaw.isNotEmpty) {
      final first = dataRaw.first;
      if (first is Map) {
        data = Map<String, dynamic>.from(first);
      }
    }

    if (data == null) return empty;

    // CMS payload:
    // minVersion, latestVersion, isForceUpgrade, releaseNotes, isActive
    final latest = _stringOf(
      data,
      const [
        'latestVersion',
        'latest_version',
        'version',
        'appVersion',
        'app_version',
      ],
    );
    final minimum = _stringOf(
      data,
      const [
        'minVersion',
        'min_version',
        'minimumVersion',
        'minimum_version',
      ],
    );
    final storeUrl = _stringOf(
      data,
      const [
        'storeUrl',
        'store_url',
        'updateUrl',
        'update_url',
        'downloadUrl',
        'download_url',
        'url',
        'link',
      ],
    );
    final title = _stringOf(data, const ['title', 'heading']);
    final message = _stringOf(
      data,
      const [
        'releaseNotes',
        'release_notes',
        'message',
        'description',
        'notes',
      ],
    );
    final forceUpdate = _boolOf(
      data,
      const [
        'isForceUpgrade',
        'is_force_upgrade',
        'forceUpdate',
        'force_update',
        'isForceUpdate',
        'is_force_update',
        'mandatory',
        'isMandatory',
        'is_mandatory',
      ],
    );
    final isActive = data.containsKey('isActive') || data.containsKey('is_active')
        ? _boolOf(data, const ['isActive', 'is_active'])
        : true;

    return AppVersionModel(
      latestVersion: latest,
      minimumVersion: minimum.isEmpty ? null : minimum,
      forceUpdate: forceUpdate,
      storeUrl: storeUrl,
      isActive: isActive,
      title: title.isEmpty ? null : title,
      message: message.isEmpty ? null : message,
    );
  }

  static String _stringOf(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static bool _boolOf(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      if (value is bool) return value;
      if (value is num) return value != 0;
      final text = value.toString().trim().toLowerCase();
      if (text == 'true' || text == '1' || text == 'yes') return true;
      if (text == 'false' || text == '0' || text == 'no') return false;
    }
    return false;
  }
}

class AppVersionResponseModel {
  const AppVersionResponseModel({
    required this.success,
    required this.message,
    required this.version,
  });

  final bool success;
  final String message;
  final AppVersionModel version;

  factory AppVersionResponseModel.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final success =
        json['success'] == true || (code is num && code.toInt() == 200);
    final version = AppVersionModel.fromJson(json);
    return AppVersionResponseModel(
      success: success && version.hasVersion,
      message: (json['message'] ?? '').toString(),
      version: version,
    );
  }
}
