import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/session/auth_session_refresh.dart';
import 'data/data_sources/pro_remote_data_source.dart';
import 'data/data_sources/pro_remote_data_source_impl.dart';
import 'data/mock/pro_mock_api.dart';
import 'data/repositories/pro_repository_impl.dart';
import 'domain/repositories/pro_repository.dart';
import 'domain/use_cases/get_pro_catalog_use_case.dart';
import 'domain/use_cases/subscribe_pro_use_case.dart';
import 'domain/use_cases/unsubscribe_pro_use_case.dart';
import 'presentation/cubit/pro_cubit.dart';
import 'presentation/pro_membership_cache.dart';

void initProInjector() {
  sl.registerLazySingleton<ProMockApi>(() => ProMockApi());

  sl.registerLazySingleton<ProRemoteDataSource>(
    () => ProRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<ProMockApi>(),
    ),
  );

  sl.registerLazySingleton<ProRepository>(
    () => ProRepositoryImpl(remoteDataSource: sl<ProRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetProCatalogUseCase>(
    () => GetProCatalogUseCase(repository: sl<ProRepository>()),
  );

  sl.registerLazySingleton<SubscribeProUseCase>(
    () => SubscribeProUseCase(repository: sl<ProRepository>()),
  );

  sl.registerLazySingleton<UnsubscribeProUseCase>(
    () => UnsubscribeProUseCase(repository: sl<ProRepository>()),
  );

  sl.registerLazySingleton<ProMembershipCache>(() => ProMembershipCache());

  sl.registerFactory<ProCubit>(
    () => ProCubit(
      getCatalogUseCase: sl<GetProCatalogUseCase>(),
      subscribeProUseCase: sl<SubscribeProUseCase>(),
      unsubscribeProUseCase: sl<UnsubscribeProUseCase>(),
      membershipCache: sl<ProMembershipCache>(),
      authSessionRefresh: sl<AuthSessionRefresh>(),
    ),
  );
}
