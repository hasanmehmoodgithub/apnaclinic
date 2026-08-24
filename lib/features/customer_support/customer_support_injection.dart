import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import 'data/data_sources/customer_support_remote_data_source.dart';
import 'data/data_sources/customer_support_remote_data_source_impl.dart';
import 'data/mock/customer_support_mock_api.dart';
import 'data/repositories/customer_support_repository_impl.dart';
import 'domain/repositories/customer_support_repository.dart';
import 'domain/use_cases/get_customer_support_content_use_case.dart';
import 'presentation/cubit/customer_support_cubit.dart';

void initCustomerSupportInjector() {
  sl.registerLazySingleton<CustomerSupportMockApi>(
    () => CustomerSupportMockApi(),
  );

  sl.registerLazySingleton<CustomerSupportRemoteDataSource>(
    () => CustomerSupportRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<CustomerSupportMockApi>(),
    ),
  );

  sl.registerLazySingleton<CustomerSupportRepository>(
    () => CustomerSupportRepositoryImpl(
      remoteDataSource: sl<CustomerSupportRemoteDataSource>(),
      appPref: sl<AppPref>(),
    ),
  );

  sl.registerLazySingleton<GetCustomerSupportContentUseCase>(
    () => GetCustomerSupportContentUseCase(
      repository: sl<CustomerSupportRepository>(),
    ),
  );

  sl.registerFactory<CustomerSupportCubit>(
    () => CustomerSupportCubit(
      getContentUseCase: sl<GetCustomerSupportContentUseCase>(),
    ),
  );
}
