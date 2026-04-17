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
    final rawCities = json['cities'];
    final rawProcedures = json['procedures'];
    return SurgeryContentModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      cities: (rawCities is List ? rawCities : const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      defaultCity: (json['defaultCity'] ?? '').toString(),
      procedures: (rawProcedures is List ? rawProcedures : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(SurgeryProcedureModel.fromJson)
          .toList(),
    );
  }
}
