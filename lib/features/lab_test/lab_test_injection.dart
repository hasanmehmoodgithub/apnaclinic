import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/lab_test_remote_data_source.dart';
import 'data/data_sources/lab_test_remote_data_source_impl.dart';
import 'data/mock/lab_test_mock_api.dart';
import 'data/repositories/lab_test_cart_repository_impl.dart';
import 'data/repositories/lab_test_repository_impl.dart';
import 'domain/repositories/lab_test_cart_repository.dart';
import 'domain/repositories/lab_test_repository.dart';
import 'domain/use_cases/get_lab_test_catalog_use_case.dart';
import 'presentation/cubit/lab_test_cart_cubit.dart';
import 'presentation/cubit/lab_test_cubit.dart';

void initLabTestInjector() {
  sl.registerLazySingleton<LabTestMockApi>(() => LabTestMockApi());

  sl.registerLazySingleton<LabTestRemoteDataSource>(
    () => LabTestRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<LabTestMockApi>(),
    ),
  );

  sl.registerLazySingleton<LabTestRepository>(
    () =>
        LabTestRepositoryImpl(remoteDataSource: sl<LabTestRemoteDataSource>()),
  );

  sl.registerLazySingleton<LabTestCartRepository>(
    () => LabTestCartRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetLabTestCatalogUseCase>(
    () => GetLabTestCatalogUseCase(repository: sl<LabTestRepository>()),
  );

  sl.registerFactory<LabTestCubit>(
    () =>
        LabTestCubit(getLabTestCatalogUseCase: sl<GetLabTestCatalogUseCase>()),
  );

  sl.registerFactory<LabTestCartCubit>(
    () => LabTestCartCubit(sl<LabTestCartRepository>()),
  );
}
