import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import 'data/data_sources/free_doctor_remote_data_source.dart';
import 'data/data_sources/free_doctor_remote_data_source_impl.dart';
import 'data/mock/free_doctor_mock_api.dart';
import 'data/repositories/free_doctor_repository_impl.dart';
import 'domain/repositories/free_doctor_repository.dart';
import 'domain/use_cases/get_free_doctor_content_use_case.dart';
import 'presentation/cubit/free_doctor_cubit.dart';

void initFreeDoctorInjector() {
  sl.registerLazySingleton<FreeDoctorMockApi>(() => FreeDoctorMockApi());

  sl.registerLazySingleton<FreeDoctorRemoteDataSource>(
    () => FreeDoctorRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<FreeDoctorMockApi>(),
    ),
  );

  sl.registerLazySingleton<FreeDoctorRepository>(
    () => FreeDoctorRepositoryImpl(
      remoteDataSource: sl<FreeDoctorRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetFreeDoctorContentUseCase>(
    () => GetFreeDoctorContentUseCase(repository: sl<FreeDoctorRepository>()),
  );

  sl.registerFactory<FreeDoctorCubit>(
    () => FreeDoctorCubit(
      getContentUseCase: sl<GetFreeDoctorContentUseCase>(),
      appPref: sl<AppPref>(),
    ),
  );
}
