import '../../core/di/dependency_injection.dart';
import 'data/repositories/profile_setup_repository_impl.dart';
import 'domain/repositories/profile_setup_repository.dart';
import 'presentation/cubit/profile_setup_cubit.dart';

void initProfileSetupInjector() {
  if (!sl.isRegistered<ProfileSetupRepository>()) {
    sl.registerLazySingleton<ProfileSetupRepository>(
      () => ProfileSetupRepositoryImpl(sl()),
    );
  }

  if (!sl.isRegistered<ProfileSetupCubit>()) {
    sl.registerFactory<ProfileSetupCubit>(() => ProfileSetupCubit(sl()));
  }
}
