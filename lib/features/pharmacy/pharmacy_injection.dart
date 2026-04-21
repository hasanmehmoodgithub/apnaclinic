import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/pharmacy_remote_data_source.dart';
import 'data/data_sources/pharmacy_remote_data_source_impl.dart';
import 'data/mock/pharmacy_mock_api.dart';
import 'data/repositories/pharmacy_repository_impl.dart';
import 'domain/repositories/pharmacy_repository.dart';
import 'domain/use_cases/add_to_cart_use_case.dart';
import 'domain/use_cases/get_pharmacy_cart_use_case.dart';
import 'domain/use_cases/get_pharmacy_medicines_use_case.dart';
import 'presentation/cubit/pharmacy_cubit.dart';

void initPharmacyInjector() {
  sl.registerLazySingleton<PharmacyMockApi>(() => PharmacyMockApi());

  sl.registerLazySingleton<PharmacyRemoteDataSource>(
    () => PharmacyRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<PharmacyMockApi>(),
    ),
  );

  sl.registerLazySingleton<PharmacyRepository>(
    () => PharmacyRepositoryImpl(
      remoteDataSource: sl<PharmacyRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetPharmacyMedicinesUseCase>(
    () => GetPharmacyMedicinesUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerLazySingleton<GetPharmacyCartUseCase>(
    () => GetPharmacyCartUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerFactory<PharmacyCubit>(
    () => PharmacyCubit(
      getPharmacyMedicinesUseCase: sl<GetPharmacyMedicinesUseCase>(),
      getPharmacyCartUseCase: sl<GetPharmacyCartUseCase>(),
      addToCartUseCase: sl<AddToCartUseCase>(),
    ),
  );
}
