import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/surgery_remote_data_source.dart';
import 'data/data_sources/surgery_remote_data_source_impl.dart';
import 'data/mock/surgery_checkout_mock_api.dart';
import 'data/mock/surgery_doctors_mock_api.dart';
import 'data/mock/surgery_mock_api.dart';
import 'data/mock/surgery_patient_form_mock_api.dart';
import 'data/repositories/surgery_repository_impl.dart';
import 'domain/repositories/surgery_repository.dart';
import 'domain/use_cases/get_surgery_content_use_case.dart';
import 'domain/use_cases/get_surgery_doctors_use_case.dart';
import 'domain/use_cases/get_surgery_patient_form_use_case.dart';
import 'domain/use_cases/submit_surgery_booking_use_case.dart';
import 'presentation/cubit/surgery_cubit.dart';

void initSurgeryInjector() {
  sl.registerLazySingleton<SurgeryMockApi>(() => SurgeryMockApi());
  sl.registerLazySingleton<SurgeryDoctorsMockApi>(() => SurgeryDoctorsMockApi());
  sl.registerLazySingleton<SurgeryPatientFormMockApi>(
    () => SurgeryPatientFormMockApi(),
  );
  sl.registerLazySingleton<SurgeryCheckoutMockApi>(
    () => SurgeryCheckoutMockApi(),
  );

  sl.registerLazySingleton<SurgeryRemoteDataSource>(
    () => SurgeryRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<SurgeryMockApi>(),
      doctorsMockApi: sl<SurgeryDoctorsMockApi>(),
      patientFormMockApi: sl<SurgeryPatientFormMockApi>(),
      checkoutMockApi: sl<SurgeryCheckoutMockApi>(),
    ),
  );

  sl.registerLazySingleton<SurgeryRepository>(
    () => SurgeryRepositoryImpl(
      remoteDataSource: sl<SurgeryRemoteDataSource>(),
      citiesRepository: sl(),
    ),
  );

  sl.registerLazySingleton<GetSurgeryContentUseCase>(
    () => GetSurgeryContentUseCase(repository: sl<SurgeryRepository>()),
  );

  sl.registerLazySingleton<GetSurgeryDoctorsUseCase>(
    () => GetSurgeryDoctorsUseCase(repository: sl<SurgeryRepository>()),
  );

  sl.registerLazySingleton<GetSurgeryPatientFormUseCase>(
    () => GetSurgeryPatientFormUseCase(repository: sl<SurgeryRepository>()),
  );

  sl.registerLazySingleton<SubmitSurgeryBookingUseCase>(
    () => SubmitSurgeryBookingUseCase(repository: sl<SurgeryRepository>()),
  );

  sl.registerFactory<SurgeryCubit>(
    () => SurgeryCubit(
      getSurgeryContentUseCase: sl<GetSurgeryContentUseCase>(),
      getSurgeryDoctorsUseCase: sl<GetSurgeryDoctorsUseCase>(),
      getSurgeryPatientFormUseCase: sl<GetSurgeryPatientFormUseCase>(),
      submitSurgeryBookingUseCase: sl<SubmitSurgeryBookingUseCase>(),
    ),
  );
}
