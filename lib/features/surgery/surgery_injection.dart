import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/surgery_remote_data_source.dart';
import 'data/data_sources/surgery_remote_data_source_impl.dart';
import 'data/mock/surgery_checkout_mock_api.dart';
import 'data/mock/surgery_mock_api.dart';
import 'data/repositories/surgery_repository_impl.dart';
import 'domain/repositories/surgery_repository.dart';
import 'domain/use_cases/get_surgery_content_use_case.dart';
import 'domain/use_cases/submit_surgery_booking_use_case.dart';
import 'presentation/cubit/surgery_cubit.dart';

void initSurgeryInjector() {
  sl.registerLazySingleton<SurgeryMockApi>(() => SurgeryMockApi());
  sl.registerLazySingleton<SurgeryCheckoutMockApi>(
    () => SurgeryCheckoutMockApi(),
  );

  sl.registerLazySingleton<SurgeryRemoteDataSource>(
    () => SurgeryRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<SurgeryMockApi>(),
      checkoutMockApi: sl<SurgeryCheckoutMockApi>(),
    ),
  );

  sl.registerLazySingleton<SurgeryRepository>(
    () =>
        SurgeryRepositoryImpl(remoteDataSource: sl<SurgeryRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetSurgeryContentUseCase>(
    () => GetSurgeryContentUseCase(repository: sl<SurgeryRepository>()),
  );

  sl.registerFactory<SurgeryCubit>(
    () => SurgeryCubit(
      getSurgeryContentUseCase: sl<GetSurgeryContentUseCase>(),
      submitSurgeryBookingUseCase: sl<SubmitSurgeryBookingUseCase>(),
    ),
  );

  sl.registerLazySingleton<SubmitSurgeryBookingUseCase>(
    () => SubmitSurgeryBookingUseCase(repository: sl<SurgeryRepository>()),
  );
}
