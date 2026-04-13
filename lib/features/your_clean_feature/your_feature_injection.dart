import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/your_feature_local_data_source.dart';
import 'data/data_sources/your_feature_local_data_source_impl.dart';
import 'data/data_sources/your_feature_remote_data_source.dart';
import 'data/data_sources/your_feature_remote_data_source_impl.dart';
import 'data/repositories/your_feature_repository_impl.dart';
import 'domain/repositories/your_feature_repository.dart';
import 'domain/use_cases/create_your_feature_use_case.dart';
import 'domain/use_cases/get_your_features_use_case.dart';
import 'presentation/cubit/your_features_cubit.dart';

/// Initialize your_clean_feature dependencies
/// Simple example: GET list and POST create
/// This is a sample injection file for understanding Clean Architecture structure
void initYourFeatureInjector() {
  // Register Remote Data Source
  sl.registerLazySingleton<YourFeatureRemoteDataSource>(
    () => YourFeatureRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Local Data Source
  sl.registerLazySingleton<YourFeatureLocalDataSource>(
    () => YourFeatureLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Register Repository
  sl.registerLazySingleton<YourFeatureRepository>(
    () => YourFeatureRepositoryImpl(
      remoteDataSource: sl<YourFeatureRemoteDataSource>(),
      localDataSource: sl<YourFeatureLocalDataSource>(),
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetYourFeaturesUseCase>(
    () => GetYourFeaturesUseCase(
      featureRepository: sl<YourFeatureRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateYourFeatureUseCase>(
    () => CreateYourFeatureUseCase(
      featureRepository: sl<YourFeatureRepository>(),
    ),
  );

  // Register Cubit (Factory - creates new instance each time)
  sl.registerFactory<YourFeaturesCubit>(
    () => YourFeaturesCubit(
      getFeaturesUseCase: sl<GetYourFeaturesUseCase>(),
      createFeatureUseCase: sl<CreateYourFeatureUseCase>(),
    ),
  );
}
