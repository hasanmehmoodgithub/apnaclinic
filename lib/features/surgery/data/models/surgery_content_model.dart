class SurgeryProcedureModel {
  const SurgeryProcedureModel({
    required this.id,
    required this.name,
    this.highlighted = false,
  });

  final String id;
  final String name;
  final bool highlighted;

  factory SurgeryProcedureModel.fromJson(Map<String, dynamic> json) {
    return SurgeryProcedureModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      highlighted: json['highlighted'] == true,
    );
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

  final bool success;
  final String message;
  final List<String> cities;
  final String defaultCity;
  final List<SurgeryProcedureModel> procedures;

  factory SurgeryContentModel.fromJson(Map<String, dynamic> json) {
    final payload = _contentMap(json);
    final rawCities = payload['cities'];
    final rawProcedures = payload['procedures'];
    return SurgeryContentModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      cities: (rawCities is List ? rawCities : const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      defaultCity: (payload['defaultCity'] ?? '').toString(),
      procedures: (rawProcedures is List ? rawProcedures : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SurgeryProcedureModel.fromJson)
          .toList(),
    );
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
      ..remove('message');
    return copy;
  }
}
