import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/your_mvvm_local_data_source.dart';
import 'data/data_sources/your_mvvm_local_data_source_impl.dart';
import 'data/data_sources/your_mvvm_remote_data_source.dart';
import 'data/data_sources/your_mvvm_remote_data_source_impl.dart';
import 'data/repositories/your_mvvm_repository.dart';
import 'viewmodel/your_mvvm_cubit.dart';

/// Initialize your_mvvm_feature dependencies
/// Simple example: GET list and POST create
void initYourMvvmInjector() {
  // Register Remote Data Source
  sl.registerLazySingleton<YourMvvmRemoteDataSource>(
    () => YourMvvmRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  // Register Local Data Source
  sl.registerLazySingleton<YourMvvmLocalDataSource>(
    () => YourMvvmLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Register Repository
  sl.registerLazySingleton<YourMvvmRepository>(
    () => YourMvvmRepository(
      remoteDataSource: sl<YourMvvmRemoteDataSource>(),
      localDataSource: sl<YourMvvmLocalDataSource>(),
    ),
  );

  // Register Cubit (Factory - creates new instance each time)
  sl.registerFactory<YourMvvmCubit>(
    () => YourMvvmCubit(repository: sl<YourMvvmRepository>()),
  );
}
