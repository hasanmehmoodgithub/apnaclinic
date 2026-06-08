class SurgeryProcedureModel {
  const SurgeryProcedureModel({
    required this.id,
    required this.name,
    this.slug = '',
    this.imageUrl = '',
    this.highlighted = false,
    this.description = '',
    this.displayOrder = 0,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final bool highlighted;
  final String description;
  final int displayOrder;
  final bool isActive;

  factory SurgeryProcedureModel.fromJson(Map<String, dynamic> json) {
    final slug = (json['slug'] ?? '').toString().trim();
    final id = (json['id'] ?? slug).toString().trim();

    return SurgeryProcedureModel(
      id: id.isNotEmpty ? id : slug,
      name: (json['name'] ?? '').toString().trim(),
      slug: slug,
      imageUrl: (json['image'] ??
              json['imagePath'] ??
              json['imageUrl'] ??
              json['image_url'] ??
              '')
          .toString()
          .trim(),
      highlighted: json['highlighted'] == true,
      description: (json['description'] ?? '').toString().trim(),
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      isActive: _readIsActive(json['isActive']),
    );
  }

  static bool _readIsActive(dynamic raw) {
    return switch (raw) {
      bool value => value,
      int value => value == 1,
      String value => value.toLowerCase() == 'true' || value == '1',
      _ => true,
    };
  }
}

class SurgeryContentModel {
  const SurgeryContentModel({
    required this.success,
    required this.message,
    required this.cities,
    required this.defaultCity,
    required this.procedures,
  });

  static const _defaultCities = <String>[
    'Islamabad',
    'Lahore',
    'Peshawar',
    'Rawalpindi',
    'Karachi',
  ];

  static const _defaultCity = 'Islamabad';

  final bool success;
  final String message;
  final List<String> cities;
  final String defaultCity;
  final List<SurgeryProcedureModel> procedures;

  factory SurgeryContentModel.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final success = json['success'] == true || (code is num && code.toInt() == 200);
    final dataRaw = json['data'];

    if (dataRaw is List) {
      final procedures = _parseProcedures(dataRaw);
      return SurgeryContentModel(
        success: success,
        message: (json['message'] ?? '').toString(),
        cities: _defaultCities,
        defaultCity: _defaultCity,
        procedures: procedures,
      );
    }

    final payload = _contentMap(json);
    final rawCities = payload['cities'];
    final rawProcedures = payload['procedures'] ?? payload['surgeries'] ?? dataRaw;

    return SurgeryContentModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      cities: _parseCities(rawCities),
      defaultCity: (payload['defaultCity'] ?? _defaultCity).toString(),
      procedures: _parseProcedures(rawProcedures),
    );
  }

  static List<String> _parseCities(dynamic rawCities) {
    final cities = (rawCities is List ? rawCities : const <dynamic>[])
        .map((e) => e.toString().trim())
        .where((city) => city.isNotEmpty)
        .toList();
    return cities.isNotEmpty ? cities : _defaultCities;
  }

  static List<SurgeryProcedureModel> _parseProcedures(dynamic rawProcedures) {
    final list = (rawProcedures is List ? rawProcedures : const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(SurgeryProcedureModel.fromJson)
        .where((item) => item.isActive && item.name.isNotEmpty)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return list;
  }

  static Map<String, dynamic> _contentMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }

    final content = json['content'];
    if (content is Map<String, dynamic>) {
      return content;
    }

    final copy = Map<String, dynamic>.from(json)
      ..remove('success')
      ..remove('message')
      ..remove('code')
      ..remove('timestamp');
    return copy;
  }
}
