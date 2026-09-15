class LabListItemModel {
  const LabListItemModel({
    required this.id,
    required this.name,
    required this.slug,
    this.publicId = '',
    this.logoUrl,
    this.supportsHomeSampling = true,
    this.supportsWalkIn = true,
    this.homeSamplingFee,
    this.rating,
    this.estimatedReportHours,
  });

  final String id;
  final String publicId;
  final String name;
  final String slug;
  final String? logoUrl;
  final bool supportsHomeSampling;
  final bool supportsWalkIn;
  final String? homeSamplingFee;
  final String? rating;
  final int? estimatedReportHours;

  factory LabListItemModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['labId'] ?? json['lab_id'] ?? '';
    return LabListItemModel(
      id: id.toString().trim(),
      publicId: (json['publicId'] ?? json['public_id'] ?? '').toString().trim(),
      name: (json['name'] ?? json['labName'] ?? json['lab_name'] ?? '')
          .toString()
          .trim(),
      slug: (json['slug'] ?? json['labSlug'] ?? json['lab_slug'] ?? '')
          .toString()
          .trim(),
      logoUrl: (json['logoUrl'] ??
              json['labLogoUrl'] ??
              json['logo_url'] ??
              json['logo'])
          ?.toString(),
      supportsHomeSampling: _toBool(json['supportsHomeSampling'], fallback: true),
      supportsWalkIn: _toBool(json['supportsWalkIn'], fallback: true),
      homeSamplingFee: json['homeSamplingFee']?.toString(),
      rating: json['rating']?.toString().trim(),
      estimatedReportHours: _toInt(json['estimatedReportHours']),
    );
  }

  static bool _toBool(dynamic value, {required bool fallback}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return fallback;
  }

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}

class LabListResponseModel {
  const LabListResponseModel({required this.labs});

  final List<LabListItemModel> labs;

  factory LabListResponseModel.fromJson(Map<String, dynamic> json) {
    return LabListResponseModel(
      labs: _parseLabs(json)
          .map(LabListItemModel.fromJson)
          .where((lab) => lab.id.isNotEmpty && lab.name.isNotEmpty)
          .toList(growable: false),
    );
  }

  /// Live API: `{ success, message, data: [ { id, name, slug, logoUrl, ... } ] }`.
  static List<Map<String, dynamic>> _parseLabs(Map<String, dynamic> json) {
    final data = json['data'];
    final raw = _asMapList(data) ??
        _asMapList(_mapValue(data, const ['labs', 'items', 'data'])) ??
        _asMapList(json['labs']) ??
        _asMapList(json['items']) ??
        const <Map<String, dynamic>>[];
    return raw;
  }

  static List<Map<String, dynamic>>? _asMapList(dynamic value) {
    if (value is! List) return null;
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  static dynamic _mapValue(dynamic value, List<String> keys) {
    if (value is! Map) return null;
    final map = Map<String, dynamic>.from(value);
    for (final key in keys) {
      if (map[key] != null) return map[key];
    }
    return null;
  }
}
