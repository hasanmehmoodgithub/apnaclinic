import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import '../../core/session/auth_session_refresh.dart';
import 'data/data_sources/auth_remote_data_source.dart';
import 'data/data_sources/auth_remote_data_source_impl.dart';
import 'data/mock/auth_mock_api.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/use_cases/logout_use_case.dart';
import 'domain/use_cases/request_otp_use_case.dart';
import 'domain/use_cases/verify_otp_use_case.dart';
import 'presentation/cubit/auth_cubit.dart';

void initAuthInjector() {


  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        apiService: sl<ApiService>(),
      ),
    );
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<RequestOtpUseCase>()) {
    sl.registerLazySingleton<RequestOtpUseCase>(
      () => RequestOtpUseCase(repository: sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<VerifyOtpUseCase>()) {
    sl.registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(repository: sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(repository: sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerFactory<AuthCubit>(
      () => AuthCubit(
        requestOtpUseCase: sl<RequestOtpUseCase>(),
        verifyOtpUseCase: sl<VerifyOtpUseCase>(),
        appPref: sl<AppPref>(),
        sessionRefresh: sl<AuthSessionRefresh>(),
      ),
    );
  }
}
