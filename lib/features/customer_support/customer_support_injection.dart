import '../../core/di/dependency_injection.dart';
import '../dashboard/domain/repositories/dashboard_repository.dart';
import 'data/repositories/customer_support_repository_impl.dart';
import 'domain/repositories/customer_support_repository.dart';
import 'domain/use_cases/get_customer_support_content_use_case.dart';
import 'presentation/cubit/customer_support_cubit.dart';

void initCustomerSupportInjector() {
  sl.registerLazySingleton<CustomerSupportRepository>(
    () => CustomerSupportRepositoryImpl(
      dashboardRepository: sl<DashboardRepository>(),
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
