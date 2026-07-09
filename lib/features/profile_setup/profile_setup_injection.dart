import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import '../account/domain/use_cases/delete_user_phone_use_case.dart';
import '../account/domain/use_cases/get_accounts_list_use_case.dart';
import 'data/data_sources/profile_setup_remote_data_source.dart';
import 'data/data_sources/profile_setup_remote_data_source_impl.dart';
import 'data/mock/profile_setup_mock_api.dart';
import 'data/repositories/profile_setup_repository_impl.dart';
import 'domain/repositories/profile_setup_repository.dart';
import 'domain/use_cases/get_profile_setup_content_use_case.dart';
import 'domain/use_cases/save_profile_setup_use_case.dart';
import 'presentation/cubit/profile_cubit.dart';
import 'presentation/cubit/profile_setup_cubit.dart';

void initProfileSetupInjector() {
  sl.registerLazySingleton<ProfileSetupMockApi>(() => ProfileSetupMockApi());

  sl.registerLazySingleton<ProfileSetupRemoteDataSource>(
    () => ProfileSetupRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<ProfileSetupMockApi>(),
      appPref: sl<AppPref>(),
    ),
  );

  sl.registerLazySingleton<ProfileSetupRepository>(
    () => ProfileSetupRepositoryImpl(
      remoteDataSource: sl<ProfileSetupRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetProfileSetupContentUseCase>(
    () =>
        GetProfileSetupContentUseCase(repository: sl<ProfileSetupRepository>()),
  );

  sl.registerLazySingleton<SaveProfileSetupUseCase>(
    () => SaveProfileSetupUseCase(repository: sl<ProfileSetupRepository>()),
  );

  sl.registerFactory<ProfileSetupCubit>(
    () => ProfileSetupCubit(
      getProfileSetupContentUseCase: sl<GetProfileSetupContentUseCase>(),
      saveProfileSetupUseCase: sl<SaveProfileSetupUseCase>(),
    ),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      appPref: sl<AppPref>(),
      getProfileSetupContentUseCase: sl<GetProfileSetupContentUseCase>(),
      getAccountsListUseCase: sl<GetAccountsListUseCase>(),
      deleteUserPhoneUseCase: sl<DeleteUserPhoneUseCase>(),
    ),
  );
}
