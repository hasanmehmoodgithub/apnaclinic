import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import '../../core/cities/domain/repositories/cities_repository.dart';
import 'data/data_sources/lab_test_remote_data_source.dart';
import 'data/data_sources/lab_test_remote_data_source_impl.dart';
import 'data/mock/lab_orders_mock_api.dart';
import 'data/mock/lab_test_mock_api.dart';
import 'data/repositories/lab_test_cart_repository_impl.dart';
import 'data/repositories/lab_test_repository_impl.dart';
import 'domain/repositories/lab_test_cart_repository.dart';
import 'domain/repositories/lab_test_repository.dart';
import 'domain/use_cases/get_lab_orders_use_case.dart';
import 'domain/use_cases/book_lab_test_use_case.dart';
import 'domain/use_cases/get_lab_test_catalog_use_case.dart';
import 'domain/use_cases/get_lab_test_detail_use_case.dart';
import 'presentation/cubit/lab_test_cart_cubit.dart';
import 'presentation/cubit/lab_test_cubit.dart';

void initLabTestInjector() {
  sl.registerLazySingleton<LabTestMockApi>(() => LabTestMockApi());
  sl.registerLazySingleton<LabOrdersMockApi>(() => LabOrdersMockApi());

  sl.registerLazySingleton<LabTestRemoteDataSource>(
    () => LabTestRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<LabTestMockApi>(),
      labOrdersMockApi: sl<LabOrdersMockApi>(),
    ),
  );

  sl.registerLazySingleton<LabTestRepository>(
    () => LabTestRepositoryImpl(
      remoteDataSource: sl<LabTestRemoteDataSource>(),
      citiesRepository: sl(),
    ),
  );

  sl.registerLazySingleton<LabTestCartRepository>(
    () => LabTestCartRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetLabTestCatalogUseCase>(
    () => GetLabTestCatalogUseCase(repository: sl<LabTestRepository>()),
  );

  sl.registerLazySingleton<GetLabTestDetailUseCase>(
    () => GetLabTestDetailUseCase(repository: sl<LabTestRepository>()),
  );

  sl.registerLazySingleton<GetLabOrdersUseCase>(
    () => GetLabOrdersUseCase(repository: sl<LabTestRepository>()),
  );

  sl.registerLazySingleton<BookLabTestUseCase>(
    () => BookLabTestUseCase(repository: sl<LabTestRepository>()),
  );

  sl.registerFactory<LabTestCubit>(
    () => LabTestCubit(
      getLabTestCatalogUseCase: sl<GetLabTestCatalogUseCase>(),
      appPref: sl<AppPref>(),
      citiesRepository: sl<CitiesRepository>(),
    ),
  );

  sl.registerFactory<LabTestCartCubit>(
    () => LabTestCartCubit(sl<LabTestCartRepository>()),
  );
}
