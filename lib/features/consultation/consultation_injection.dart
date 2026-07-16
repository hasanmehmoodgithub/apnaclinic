import '../../core/di/dependency_injection.dart';
import '../bookings/presentation/cubit/doctor_consultation_bookings_cubit.dart';
import 'data/data_sources/consultation_remote_data_source.dart';
import 'data/data_sources/consultation_remote_data_source_impl.dart';
import 'data/mock/consultation_booking_mock_api.dart';
import 'data/mock/consultation_bookings_list_mock_api.dart';
import 'data/mock/consultation_categories_mock_api.dart';
import 'data/mock/consultation_doctor_slots_mock_api.dart';
import 'data/mock/consultation_doctors_mock_api.dart';
import 'data/mock/payment_providers_mock_api.dart';
import 'data/repositories/consultation_repository_impl.dart';
import 'domain/repositories/consultation_repository.dart';
import 'domain/use_cases/get_consultation_booking_use_case.dart';
import 'domain/use_cases/get_consultation_bookings_use_case.dart';
import 'domain/use_cases/get_consultation_categories_use_case.dart';
import 'domain/use_cases/get_consultation_doctor_slots_use_case.dart';
import 'domain/use_cases/get_consultation_doctors_use_case.dart';
import 'domain/use_cases/get_payment_providers_use_case.dart';
import 'domain/use_cases/submit_consultation_booking_use_case.dart';
import 'domain/use_cases/submit_consultation_feedback_use_case.dart';
import 'presentation/cubit/consultation_cubit.dart';
import 'presentation/cubit/doctor_consultation_checkout_cubit.dart';

void initConsultationInjector() {
  sl.registerLazySingleton<ConsultationCategoriesMockApi>(
    () => ConsultationCategoriesMockApi(),
  );
  sl.registerLazySingleton<ConsultationDoctorsMockApi>(
    () => ConsultationDoctorsMockApi(),
  );
  sl.registerLazySingleton<ConsultationDoctorSlotsMockApi>(
    () => ConsultationDoctorSlotsMockApi(),
  );
  sl.registerLazySingleton<ConsultationBookingMockApi>(
    () => ConsultationBookingMockApi(),
  );
  sl.registerLazySingleton<ConsultationBookingsListMockApi>(
    () => ConsultationBookingsListMockApi(),
  );
  sl.registerLazySingleton<PaymentProvidersMockApi>(
    () => PaymentProvidersMockApi(),
  );

  sl.registerLazySingleton<ConsultationRemoteDataSource>(
    () => ConsultationRemoteDataSourceImpl(
      apiService: sl(),
      mockApi: sl<ConsultationCategoriesMockApi>(),
      doctorsMockApi: sl<ConsultationDoctorsMockApi>(),
      slotsMockApi: sl<ConsultationDoctorSlotsMockApi>(),
      bookingMockApi: sl<ConsultationBookingMockApi>(),
      bookingsListMockApi: sl<ConsultationBookingsListMockApi>(),
      paymentProvidersMockApi: sl<PaymentProvidersMockApi>(),
    ),
  );

  sl.registerLazySingleton<ConsultationRepository>(
    () => ConsultationRepositoryImpl(
      remoteDataSource: sl<ConsultationRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetConsultationCategoriesUseCase>(
    () => GetConsultationCategoriesUseCase(
      repository: sl<ConsultationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetConsultationDoctorsUseCase>(
    () =>
        GetConsultationDoctorsUseCase(repository: sl<ConsultationRepository>()),
  );

  sl.registerLazySingleton<GetConsultationDoctorSlotsUseCase>(
    () => GetConsultationDoctorSlotsUseCase(
      repository: sl<ConsultationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetPaymentProvidersUseCase>(
    () => GetPaymentProvidersUseCase(repository: sl<ConsultationRepository>()),
  );

  sl.registerLazySingleton<SubmitConsultationBookingUseCase>(
    () => SubmitConsultationBookingUseCase(
      repository: sl<ConsultationRepository>(),
    ),
  );

  sl.registerLazySingleton<SubmitConsultationFeedbackUseCase>(
    () => SubmitConsultationFeedbackUseCase(
      repository: sl<ConsultationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetConsultationBookingsUseCase>(
    () => GetConsultationBookingsUseCase(
      repository: sl<ConsultationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetConsultationBookingUseCase>(
    () => GetConsultationBookingUseCase(
      repository: sl<ConsultationRepository>(),
    ),
  );

  sl.registerFactory<ConsultationCubit>(
    () => ConsultationCubit(
      getCategoriesUseCase: sl<GetConsultationCategoriesUseCase>(),
    ),
  );

  sl.registerFactory<DoctorConsultationCheckoutCubit>(
    () => DoctorConsultationCheckoutCubit(
      getPaymentProvidersUseCase: sl<GetPaymentProvidersUseCase>(),
      submitBookingUseCase: sl<SubmitConsultationBookingUseCase>(),
      appPref: sl(),
    ),
  );

  sl.registerFactory<DoctorConsultationBookingsCubit>(
    () => DoctorConsultationBookingsCubit(
      getBookingsUseCase: sl<GetConsultationBookingsUseCase>(),
    ),
  );
}
