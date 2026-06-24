import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import 'data/data_sources/instant_doctor_remote_data_source.dart';
import 'data/data_sources/instant_doctor_remote_data_source_impl.dart';
import 'data/mock/instant_doctor_mock_api.dart';
import 'data/repositories/instant_doctor_repository_impl.dart';
import 'domain/repositories/instant_doctor_repository.dart';
import 'domain/use_cases/get_instant_doctor_content_use_case.dart';
import 'presentation/cubit/instant_doctor_cubit.dart';

void initInstantDoctorInjector() {
  sl.registerLazySingleton<InstantDoctorMockApi>(() => InstantDoctorMockApi());

  sl.registerLazySingleton<InstantDoctorRemoteDataSource>(
    () => InstantDoctorRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<InstantDoctorMockApi>(),
    ),
  );

  sl.registerLazySingleton<InstantDoctorRepository>(
    () => InstantDoctorRepositoryImpl(
      remoteDataSource: sl<InstantDoctorRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetInstantDoctorContentUseCase>(
    () => GetInstantDoctorContentUseCase(repository: sl<InstantDoctorRepository>()),
  );

  sl.registerFactory<InstantDoctorCubit>(
    () => InstantDoctorCubit(
      getContentUseCase: sl<GetInstantDoctorContentUseCase>(),
      appPref: sl<AppPref>(),
    ),
  );
}
