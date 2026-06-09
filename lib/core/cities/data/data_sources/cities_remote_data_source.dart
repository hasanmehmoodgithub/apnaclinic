import '../models/city_model.dart';

abstract class CitiesRemoteDataSource {
  Future<List<CityModel>> getCities();
}
