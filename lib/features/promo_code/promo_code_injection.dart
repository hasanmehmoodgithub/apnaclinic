import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/promo_code_remote_data_source.dart';
import 'data/data_sources/promo_code_remote_data_source_impl.dart';
import 'data/mock/promo_code_mock_api.dart';
import 'data/repositories/promo_code_repository_impl.dart';
import 'domain/repositories/promo_code_repository.dart';
import 'domain/use_cases/validate_promo_code_use_case.dart';
import 'presentation/cubit/promo_code_cubit.dart';

void initPromoCodeInjector() {
  sl.registerLazySingleton<PromoCodeMockApi>(() => PromoCodeMockApi());

  sl.registerLazySingleton<PromoCodeRemoteDataSource>(
    () => PromoCodeRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<PromoCodeMockApi>(),
    ),
  );

  sl.registerLazySingleton<PromoCodeRepository>(
    () => PromoCodeRepositoryImpl(
      remoteDataSource: sl<PromoCodeRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ValidatePromoCodeUseCase>(
    () => ValidatePromoCodeUseCase(repository: sl<PromoCodeRepository>()),
  );

  sl.registerFactory<PromoCodeCubit>(
    () => PromoCodeCubit(validateUseCase: sl<ValidatePromoCodeUseCase>()),
  );
}
