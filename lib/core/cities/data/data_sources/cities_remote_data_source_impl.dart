import 'dart:developer';

import '../../../constants/app_strings.dart';
import '../../../network/api_service.dart';
import '../../../network/app_urls.dart';
import '../../../utils/error_handler.dart';
import '../models/city_model.dart';
import 'cities_remote_data_source.dart';

class CitiesRemoteDataSourceImpl implements CitiesRemoteDataSource {
  CitiesRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final response = await apiService.get(AppUrls.cities);
      log('getCities response count: ${(response['data'] as List?)?.length}');
      final model = CitiesResponseModel.fromJson(response);
      if (model.success && model.cities.isNotEmpty) {
        return model.cities;
      }

      final message =
          (response['message'] ?? AppStrings.genericErrorMessage).toString();
      return Future.error(message);
    } catch (e) {
      log('getCities error: $e');
      final message = ErrorHandler.handleExceptions(
        e,
        endpoint: AppUrls.cities,
      );
      return Future.error(message);
    }
  }
}
