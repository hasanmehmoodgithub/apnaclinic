import '../../domain/entities/pharmacy_city_entity.dart';

class PharmacyCityModel {
  const PharmacyCityModel({
    required this.id,
    required this.name,
    this.slug = '',
    this.partner = '',
  });

  final int id;
  final String name;
  final String slug;
  final String partner;

  factory PharmacyCityModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return PharmacyCityModel(
      id: id,
      name: (json['name'] ?? '').toString().trim(),
      slug: (json['slug'] ?? '').toString().trim(),
      partner: (json['partner'] ?? '').toString().trim(),
    );
  }

  PharmacyCityEntity toEntity() {
    return PharmacyCityEntity(
      id: id,
      name: name,
      slug: slug,
      partner: partner,
    );
  }
}

class PharmacyCitiesResponseModel {
  const PharmacyCitiesResponseModel({
    required this.success,
    required this.cities,
  });

  final bool success;
  final List<PharmacyCityModel> cities;

  factory PharmacyCitiesResponseModel.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final success =
        json['success'] == true || (code is num && code.toInt() == 200);
    final data = json['data'];
    final rawCities = data is List ? data : const <dynamic>[];

    final cities = rawCities
        .whereType<Map>()
        .map((e) => PharmacyCityModel.fromJson(Map<String, dynamic>.from(e)))
        .where((city) => city.id > 0 && city.name.isNotEmpty)
        .toList(growable: false);

    return PharmacyCitiesResponseModel(success: success, cities: cities);
  }
}
