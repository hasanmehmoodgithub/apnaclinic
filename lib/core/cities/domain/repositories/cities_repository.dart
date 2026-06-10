import '../entities/city_entity.dart';

abstract class CitiesRepository {
  /// Fetches cities from the API once and caches the result for the session.
  Future<void> loadCities();

  bool get isLoaded;

  List<CityEntity> get cities;

  List<String> get cityNames;

  String get defaultCityName;

  /// Returns the aggregator city id for [cityName], or null if not found.
  String? cityIdForName(String cityName);
}
