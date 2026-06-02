class SurgeryProcedureEntity {
  const SurgeryProcedureEntity({
    required this.id,
    required this.name,
    this.highlighted = false,
    this.description = '',
  });

  final String id;
  final String name;
  final bool highlighted;
  final String description;
}

class SurgeryContentEntity {
  const SurgeryContentEntity({
    required this.cities,
    required this.defaultCity,
    required this.procedures,
  });

  final List<String> cities;
  final String defaultCity;
  final List<SurgeryProcedureEntity> procedures;
}
