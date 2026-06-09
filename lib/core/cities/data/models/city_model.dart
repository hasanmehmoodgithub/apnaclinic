import '../../domain/entities/city_entity.dart';

class CityModel {
  const CityModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  final String id;
  final String name;
  final String slug;

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString().trim(),
      slug: (json['slug'] ?? '').toString().trim(),
    );
  }

  CityEntity toEntity() {
    return CityEntity(id: id, name: name, slug: slug);
  }
}

class CitiesResponseModel {
  const CitiesResponseModel({
    required this.success,
    required this.cities,
  });

  final bool success;
  final List<CityModel> cities;

  factory CitiesResponseModel.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final success =
        json['success'] == true || (code is num && code.toInt() == 200);
    final data = json['data'];
    final rawCities = data is List ? data : const <dynamic>[];

    final cities = rawCities
        .whereType<Map<String, dynamic>>()
        .map(CityModel.fromJson)
        .where((city) => city.name.isNotEmpty)
        .toList(growable: false);

    return CitiesResponseModel(success: success, cities: cities);
  }
}
