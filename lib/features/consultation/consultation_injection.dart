import '../../core/di/dependency_injection.dart';
import 'data/data_sources/consultation_local_data_source.dart';
import 'data/data_sources/consultation_local_data_source_impl.dart';
import 'data/mock/consultation_categories_mock_api.dart';
import 'data/mock/consultation_doctors_mock_api.dart';
import 'data/repositories/consultation_repository_impl.dart';
import 'domain/repositories/consultation_repository.dart';
import 'domain/use_cases/get_consultation_categories_use_case.dart';
import 'presentation/cubit/consultation_cubit.dart';

void initConsultationInjector() {
  sl.registerLazySingleton<ConsultationCategoriesMockApi>(
    () => ConsultationCategoriesMockApi(),
  );
  sl.registerLazySingleton<ConsultationDoctorsMockApi>(
    () => ConsultationDoctorsMockApi(),
  );

  sl.registerLazySingleton<ConsultationLocalDataSource>(
    () => ConsultationLocalDataSourceImpl(
      mockApi: sl<ConsultationCategoriesMockApi>(),
    ),
  );

  sl.registerLazySingleton<ConsultationRepository>(
    () => ConsultationRepositoryImpl(
      localDataSource: sl<ConsultationLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetConsultationCategoriesUseCase>(
    () => GetConsultationCategoriesUseCase(
      repository: sl<ConsultationRepository>(),
    ),
  );

  sl.registerFactory<ConsultationCubit>(
    () => ConsultationCubit(
      getCategoriesUseCase: sl<GetConsultationCategoriesUseCase>(),
    ),
  );
}
