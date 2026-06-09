import '../di/dependency_injection.dart';
import '../network/api_service.dart';
import 'data/data_sources/cities_remote_data_source.dart';
import 'data/data_sources/cities_remote_data_source_impl.dart';
import 'data/repositories/cities_repository_impl.dart';
import 'domain/repositories/cities_repository.dart';

void initCitiesInjector() {
  sl.registerLazySingleton<CitiesRemoteDataSource>(
    () => CitiesRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  sl.registerLazySingleton<CitiesRepository>(
    () => CitiesRepositoryImpl(remoteDataSource: sl<CitiesRemoteDataSource>()),
  );
}
