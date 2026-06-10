import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/cities_repository.dart';
import '../data_sources/cities_remote_data_source.dart';

class CitiesRepositoryImpl implements CitiesRepository {
  CitiesRepositoryImpl({required this.remoteDataSource});

  final CitiesRemoteDataSource remoteDataSource;

  static const _fallbackCityNames = <String>[
    'Islamabad',
    'Lahore',
    'Peshawar',
    'Rawalpindi',
    'Karachi',
  ];

  static const _defaultCityName = 'Islamabad';

  List<CityEntity>? _cache;
  Future<void>? _loadFuture;

  @override
  bool get isLoaded => _cache != null;

  @override
  List<CityEntity> get cities => List.unmodifiable(_cache ?? const []);

  @override
  List<String> get cityNames =>
      cities.map((city) => city.name).toList(growable: false);

  @override
  String get defaultCityName => _resolveDefaultCity(cityNames);

  @override
  String? cityIdForName(String cityName) {
    final normalized = cityName.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    for (final city in cities) {
      if (city.name.trim().toLowerCase() == normalized) {
        return city.id;
      }
    }
    return null;
  }

  @override
  Future<void> loadCities() {
    if (_cache != null) {
      return Future.value();
    }
    return _loadFuture ??= _fetchAndCache();
  }

  Future<void> _fetchAndCache() async {
    try {
      final models = await remoteDataSource.getCities();
      _cache = models.map((model) => model.toEntity()).toList(growable: false);
    } catch (_) {
      _cache = _fallbackCityNames
          .map(
            (name) => CityEntity(
              id: name.toLowerCase(),
              name: name,
              slug: name.toLowerCase().replaceAll(' ', '-'),
            ),
          )
          .toList(growable: false);
    } finally {
      _loadFuture = null;
    }
  }

  static String _resolveDefaultCity(List<String> names) {
    if (names.contains(_defaultCityName)) return _defaultCityName;
    return names.isNotEmpty ? names.first : '';
  }
}
