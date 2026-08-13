import '../../core/cities/domain/repositories/cities_repository.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import 'data/data_sources/pharmacy_remote_data_source.dart';
import 'data/data_sources/pharmacy_remote_data_source_impl.dart';
import 'data/mock/pharmacy_mock_api.dart';
import 'data/repositories/pharmacy_repository_impl.dart';
import 'domain/repositories/pharmacy_repository.dart';
import 'domain/use_cases/add_pharmacy_profile_address_use_case.dart';
import 'domain/use_cases/add_to_cart_use_case.dart';
import 'domain/use_cases/get_pharmacy_booking_detail_use_case.dart';
import 'domain/use_cases/get_pharmacy_bookings_use_case.dart';
import 'domain/use_cases/get_pharmacy_cart_use_case.dart';
import 'domain/use_cases/get_pharmacy_medicines_use_case.dart';
import 'domain/use_cases/get_pharmacy_product_detail_use_case.dart';
import 'domain/use_cases/get_pharmacy_profile_addresses_use_case.dart';
import 'domain/use_cases/pharmacy_checkout_use_case.dart';
import 'domain/use_cases/update_pharmacy_cart_quantity_use_case.dart';
import 'domain/use_cases/upload_pharmacy_prescription_use_case.dart';
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
    () => GetPharmacyMedicinesUseCase(repository: sl<PharmacyRepository>()),
  );

  sl.registerLazySingleton<GetPharmacyProductDetailUseCase>(
    () => GetPharmacyProductDetailUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerLazySingleton<GetPharmacyCartUseCase>(
    () => GetPharmacyCartUseCase(repository: sl<PharmacyRepository>()),
  );

  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(repository: sl<PharmacyRepository>()),
  );

  sl.registerLazySingleton<UpdatePharmacyCartQuantityUseCase>(
    () => UpdatePharmacyCartQuantityUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerLazySingleton<UploadPharmacyPrescriptionUseCase>(
    () => UploadPharmacyPrescriptionUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerLazySingleton<PharmacyCheckoutUseCase>(
    () => PharmacyCheckoutUseCase(repository: sl<PharmacyRepository>()),
  );

  sl.registerLazySingleton<GetPharmacyProfileAddressesUseCase>(
    () => GetPharmacyProfileAddressesUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerLazySingleton<AddPharmacyProfileAddressUseCase>(
    () => AddPharmacyProfileAddressUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerLazySingleton<GetPharmacyBookingsUseCase>(
    () => GetPharmacyBookingsUseCase(repository: sl<PharmacyRepository>()),
  );

  sl.registerLazySingleton<GetPharmacyBookingDetailUseCase>(
    () => GetPharmacyBookingDetailUseCase(
      repository: sl<PharmacyRepository>(),
    ),
  );

  sl.registerFactory<PharmacyCubit>(
    () => PharmacyCubit(
      getPharmacyMedicinesUseCase: sl<GetPharmacyMedicinesUseCase>(),
      getPharmacyProductDetailUseCase: sl<GetPharmacyProductDetailUseCase>(),
      getPharmacyCartUseCase: sl<GetPharmacyCartUseCase>(),
      addToCartUseCase: sl<AddToCartUseCase>(),
      updatePharmacyCartQuantityUseCase: sl<UpdatePharmacyCartQuantityUseCase>(),
      uploadPharmacyPrescriptionUseCase:
          sl<UploadPharmacyPrescriptionUseCase>(),
      pharmacyCheckoutUseCase: sl<PharmacyCheckoutUseCase>(),
      getPharmacyProfileAddressesUseCase:
          sl<GetPharmacyProfileAddressesUseCase>(),
      addPharmacyProfileAddressUseCase: sl<AddPharmacyProfileAddressUseCase>(),
      citiesRepository: sl<CitiesRepository>(),
      appPref: sl<AppPref>(),
    ),
  );
}
