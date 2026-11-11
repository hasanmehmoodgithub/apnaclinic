import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import '../profile_setup/domain/use_cases/get_profile_setup_content_use_case.dart';
import 'data/data_sources/dashboard_remote_data_source.dart';
import 'data/data_sources/dashboard_remote_data_source_impl.dart';
import 'data/mock/app_version_mock_api.dart';
import 'data/mock/dashboard_services_mock_api.dart';
import 'data/mock/promotional_banner_mock_api.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'domain/repositories/dashboard_repository.dart';
import 'domain/services/home_ai_enabled_session.dart';
import 'domain/services/home_pro_banner_session.dart';
import 'domain/services/promotional_banner_session.dart';
import 'domain/use_cases/check_app_update_use_case.dart';
import 'domain/use_cases/promotional_banner_use_case.dart';
import 'domain/use_cases/get_dashboard_services_use_case.dart';
import 'presentation/cubit/dashboard_services_cubit.dart';

void initDashboardInjector() {
  sl.registerLazySingleton<HomeAiEnabledSession>(() => HomeAiEnabledSession());
  sl.registerLazySingleton<HomeProBannerSession>(() => HomeProBannerSession());
  sl.registerLazySingleton<DashboardServicesMockApi>(
    () => DashboardServicesMockApi(),
  );
  sl.registerLazySingleton<PromotionalBannerMockApi>(
    () => PromotionalBannerMockApi(),
  );
  sl.registerLazySingleton<AppVersionMockApi>(
    () => AppVersionMockApi(),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      appPref: sl<AppPref>(),
      mockApi: sl<DashboardServicesMockApi>(),
      promotionalBannerMockApi: sl<PromotionalBannerMockApi>(),
      appVersionMockApi: sl<AppVersionMockApi>(),
    ),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetOurServicesUseCase>(
    () => GetOurServicesUseCase(
      repository: sl<DashboardRepository>(),
    ),
  );

  sl.registerLazySingleton<GetPromotionalBannerUseCase>(
    () => GetPromotionalBannerUseCase(
      repository: sl<DashboardRepository>(),
    ),
  );

  sl.registerLazySingleton<CheckAppUpdateUseCase>(
    () => CheckAppUpdateUseCase(
      repository: sl<DashboardRepository>(),
    ),
  );

  sl.registerLazySingleton<PromotionalBannerSession>(
    () => PromotionalBannerSession(
      getPromotionalBannerUseCase: sl<GetPromotionalBannerUseCase>(),
    ),
  );

  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      getOurServicesUseCase: sl<GetOurServicesUseCase>(),
      promotionalBannerSession: sl<PromotionalBannerSession>(),
      checkAppUpdateUseCase: sl<CheckAppUpdateUseCase>(),
      getProfileSetupContentUseCase: sl<GetProfileSetupContentUseCase>(),
      appPref: sl<AppPref>(),
    ),
  );
}
