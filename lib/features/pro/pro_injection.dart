import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/pro_remote_data_source.dart';
import 'data/data_sources/pro_remote_data_source_impl.dart';
import 'data/mock/pro_mock_api.dart';
import 'data/repositories/pro_repository_impl.dart';
import 'domain/repositories/pro_repository.dart';
import 'domain/use_cases/get_pro_catalog_use_case.dart';
import 'presentation/cubit/pro_cubit.dart';

void initProInjector() {
  sl.registerLazySingleton<ProMockApi>(() => ProMockApi());

  sl.registerLazySingleton<ProRemoteDataSource>(
    () => ProRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<ProMockApi>(),
    ),
  );

  sl.registerLazySingleton<ProRepository>(
    () => ProRepositoryImpl(remoteDataSource: sl<ProRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetProCatalogUseCase>(
    () => GetProCatalogUseCase(repository: sl<ProRepository>()),
  );

  sl.registerFactory<ProCubit>(
    () => ProCubit(getCatalogUseCase: sl<GetProCatalogUseCase>()),
  );
}
