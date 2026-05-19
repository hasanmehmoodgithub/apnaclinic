import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import '../profile_setup/domain/use_cases/get_profile_setup_content_use_case.dart';
import 'data/data_sources/dashboard_remote_data_source.dart';
import 'data/data_sources/dashboard_remote_data_source_impl.dart';
import 'data/mock/dashboard_services_mock_api.dart';
import 'data/mock/promotional_banner_mock_api.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'domain/repositories/dashboard_repository.dart';
import 'domain/use_cases/promotional_banner_use_case.dart';
import 'domain/use_cases/get_dashboard_services_use_case.dart';
import 'presentation/cubit/dashboard_services_cubit.dart';

void initDashboardInjector() {
  sl.registerLazySingleton<DashboardServicesMockApi>(
    () => DashboardServicesMockApi(),
  );
  sl.registerLazySingleton<PromotionalBannerMockApi>(
    () => PromotionalBannerMockApi(),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<DashboardServicesMockApi>(),
      promotionalBannerMockApi: sl<PromotionalBannerMockApi>(),
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

  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      getOurServicesUseCase: sl<GetOurServicesUseCase>(),
      getPromotionalBannerUseCase: sl<GetPromotionalBannerUseCase>(),
      getProfileSetupContentUseCase: sl<GetProfileSetupContentUseCase>(),
      appPref: sl<AppPref>(),
    ),
  );

  sl.registerLazySingleton<GetPromotionalBannerUseCase>(
    () => GetPromotionalBannerUseCase(
      repository: sl<DashboardRepository>(),
    ),
  );

}

