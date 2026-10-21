import '../../core/di/dependency_injection.dart';
import '../../core/preference/app_pref.dart';
import '../../core/services/speech_to_text_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/apna_clinic_ai_local_data_source.dart';
import 'data/data_sources/apna_clinic_ai_remote_data_source.dart';
import 'data/data_sources/apna_clinic_ai_sdk_client.dart';
import 'data/repositories/apna_clinic_ai_repository_impl.dart';
import 'domain/repositories/apna_clinic_ai_repository.dart';
import 'domain/use_cases/ensure_apna_clinic_ai_session_use_case.dart';
import 'domain/use_cases/send_apna_clinic_ai_message_use_case.dart';
import 'presentation/cubit/apna_clinic_ai_cubit.dart';

void initApnaClinicAiInjector() {
  sl.registerLazySingleton<ApnaClinicAiConfig>(
    ApnaClinicAiConfig.fromEnvironment,
  );
  sl.registerLazySingleton<ApnaClinicAiSdkClient>(
    () => ApnaClinicAiSdkClient(
      config: sl<ApnaClinicAiConfig>(),
      appPref: sl<AppPref>(),
    ),
  );
  sl.registerLazySingleton<ApnaClinicAiRemoteDataSource>(
    () => ApnaClinicAiRemoteDataSourceImpl(client: sl<ApnaClinicAiSdkClient>()),
  );
  sl.registerLazySingleton<ApnaClinicAiLocalDataSource>(
    () => ApnaClinicAiLocalDataSourceImpl(preferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ApnaClinicAiRepository>(
    () => ApnaClinicAiRepositoryImpl(
      remoteDataSource: sl<ApnaClinicAiRemoteDataSource>(),
      localDataSource: sl<ApnaClinicAiLocalDataSource>(),
      appPref: sl<AppPref>(),
    ),
  );
  sl.registerLazySingleton<EnsureApnaClinicAiSessionUseCase>(
    () => EnsureApnaClinicAiSessionUseCase(
      repository: sl<ApnaClinicAiRepository>(),
    ),
  );
  sl.registerLazySingleton<SendApnaClinicAiMessageUseCase>(
    () => SendApnaClinicAiMessageUseCase(repository: sl<ApnaClinicAiRepository>()),
  );
  sl.registerFactory<ApnaClinicAiCubit>(
    () => ApnaClinicAiCubit(
      ensureSessionUseCase: sl<EnsureApnaClinicAiSessionUseCase>(),
      sendMessageUseCase: sl<SendApnaClinicAiMessageUseCase>(),
      localDataSource: sl<ApnaClinicAiLocalDataSource>(),
      appPref: sl<AppPref>(),
      speechToText: sl<SpeechToTextService>(),
    ),
  );
}
