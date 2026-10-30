import '../../core/di/dependency_injection.dart';
import '../../core/preference/app_pref.dart';
import '../../core/services/speech_to_text_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/apna_clinic_ai_urls.dart';
import 'data/data_sources/apna_clinic_ai_local_data_source.dart';
import 'data/data_sources/apna_clinic_ai_remote_data_source.dart';
import 'data/data_sources/apna_clinic_ai_sdk_client.dart';
import 'data/repositories/apna_clinic_ai_repository_impl.dart';
import 'data/sdk_init/apna_clinic_ai_sdk_initializer.dart';
import 'data/services/apna_clinic_ai_audio_player_service.dart';
import 'data/services/apna_clinic_ai_audio_recorder_service.dart';
import 'domain/repositories/apna_clinic_ai_repository.dart';
import 'domain/use_cases/ensure_apna_clinic_ai_session_use_case.dart';
import 'domain/use_cases/send_apna_clinic_ai_audio_use_case.dart';
import 'domain/use_cases/send_apna_clinic_ai_message_use_case.dart';
import 'presentation/cubit/apna_clinic_ai_cubit.dart';

void initApnaClinicAiInjector() {
  sl.registerLazySingleton<ApnaClinicAiConfig>(
    () => ApnaClinicAiConfig.fromEnvironment(
      preferences: sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<ApnaClinicAiSdkClient>(
    () => ApnaClinicAiSdkClient(
      config: sl<ApnaClinicAiConfig>(),
      appPref: sl<AppPref>(),
    ),
  );
  sl.registerLazySingleton<ApnaClinicAiLocalDataSource>(
    () => ApnaClinicAiLocalDataSourceImpl(preferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ApnaClinicAiSdkAuthResolver>(
    () => ApnaClinicAiSdkAuthResolver(
      appPref: sl<AppPref>(),
      localDataSource: sl<ApnaClinicAiLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<ApnaClinicAiSdkInitializer>(
    () => ApnaClinicAiSdkInitializer(
      config: sl<ApnaClinicAiConfig>(),
      client: sl<ApnaClinicAiSdkClient>(),
      authResolver: sl<ApnaClinicAiSdkAuthResolver>(),
    ),
  );
  sl.registerLazySingleton<ApnaClinicAiRemoteDataSource>(
    () => ApnaClinicAiRemoteDataSourceImpl(client: sl<ApnaClinicAiSdkClient>()),
  );
  sl.registerLazySingleton<ApnaClinicAiRepository>(
    () => ApnaClinicAiRepositoryImpl(
      sdkInitializer: sl<ApnaClinicAiSdkInitializer>(),
      remoteDataSource: sl<ApnaClinicAiRemoteDataSource>(),
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
  sl.registerLazySingleton<SendApnaClinicAiAudioUseCase>(
    () => SendApnaClinicAiAudioUseCase(repository: sl<ApnaClinicAiRepository>()),
  );
  sl.registerFactory<ApnaClinicAiAudioRecorderService>(
    ApnaClinicAiAudioRecorderService.new,
  );
  sl.registerFactory<ApnaClinicAiAudioPlayerService>(
    ApnaClinicAiAudioPlayerService.new,
  );
  sl.registerFactory<ApnaClinicAiCubit>(
    () => ApnaClinicAiCubit(
      ensureSessionUseCase: sl<EnsureApnaClinicAiSessionUseCase>(),
      sendMessageUseCase: sl<SendApnaClinicAiMessageUseCase>(),
      sendAudioUseCase: sl<SendApnaClinicAiAudioUseCase>(),
      localDataSource: sl<ApnaClinicAiLocalDataSource>(),
      config: sl<ApnaClinicAiConfig>(),
      preferences: sl<SharedPreferences>(),
      appPref: sl<AppPref>(),
      speechToText: sl<SpeechToTextService>(),
      audioRecorder: sl<ApnaClinicAiAudioRecorderService>(),
    ),
  );
}
