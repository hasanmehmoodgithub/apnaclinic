import '../../../../core/functional/functional_export.dart';
import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../../domain/entities/apna_clinic_ai_session_entity.dart';
import '../../domain/entities/apna_clinic_ai_stream_event.dart';
import '../../domain/repositories/apna_clinic_ai_repository.dart';
import '../../domain/use_cases/init_apna_clinic_ai_session_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_audio_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_message_params.dart';
import '../data_sources/apna_clinic_ai_remote_data_source.dart';
import '../data_sources/apna_clinic_ai_sdk_client.dart';
import '../mappers/apna_clinic_ai_mapper.dart';
import '../models/apna_clinic_ai_remote_event.dart';
import '../sdk_init/apna_clinic_ai_sdk_initializer.dart';

class ApnaClinicAiRepositoryImpl implements ApnaClinicAiRepository {
  ApnaClinicAiRepositoryImpl({
    required this.sdkInitializer,
    required this.remoteDataSource,
  });

  final ApnaClinicAiSdkInitializer sdkInitializer;
  final ApnaClinicAiRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, ApnaClinicAiSessionEntity>> ensureSession(
    InitApnaClinicAiSessionParams params,
  ) async {
    try {
      final model = await sdkInitializer.initialize(
        forceRefresh: params.forceRefresh,
      );
      return Right(model.toEntity());
    } on ApnaClinicAiSdkException catch (error) {
      return Left(error.code);
    } catch (_) {
      return const Left(ApnaClinicAiFailureCodes.connectFailed);
    }
  }

  @override
  Stream<ApnaClinicAiStreamEvent> sendMessage(
    SendApnaClinicAiMessageParams params,
  ) async* {
    yield* _mapRemote(
      remoteDataSource.sendMessage(
        message: params.message,
        speak: params.speak,
        voiceId: params.voiceId,
      ),
    );
  }

  @override
  Stream<ApnaClinicAiStreamEvent> sendAudio(
    SendApnaClinicAiAudioParams params,
  ) async* {
    yield* _mapRemote(
      remoteDataSource.sendAudio(
        audioBytes: params.audioBytes,
        fallbackMessage: params.fallbackMessage,
        speak: params.speak,
        language: params.language,
        voiceId: params.voiceId,
      ),
    );
  }

  Stream<ApnaClinicAiStreamEvent> _mapRemote(
    Stream<ApnaClinicAiRemoteEvent> source,
  ) async* {
    await for (final event in source) {
      switch (event.kind) {
        case ApnaClinicAiRemoteEventKind.token:
          yield ApnaClinicAiStreamToken(event.text ?? '');
        case ApnaClinicAiRemoteEventKind.stage:
          yield ApnaClinicAiStreamStage(event.stage ?? '');
        case ApnaClinicAiRemoteEventKind.transcription:
          yield ApnaClinicAiStreamTranscription(event.text ?? '');
        case ApnaClinicAiRemoteEventKind.failure:
          yield ApnaClinicAiStreamFailure(
            event.code ?? ApnaClinicAiFailureCodes.connectFailed,
          );
        case ApnaClinicAiRemoteEventKind.finalTurn:
          final turn = event.turn;
          if (turn == null) {
            yield const ApnaClinicAiStreamFailure(
              ApnaClinicAiFailureCodes.connectFailed,
            );
          } else {
            yield ApnaClinicAiStreamFinal(turn.toEntity());
          }
        case ApnaClinicAiRemoteEventKind.audio:
          final clip = (event.audioBase64 ?? '').trim();
          if (clip.isNotEmpty) {
            yield ApnaClinicAiStreamAudio(
              audioBase64: clip,
              audioMediaType: event.audioMediaType,
              turnId: event.turnId,
            );
          }
      }
    }
  }

  @override
  Future<void> newConversation() => remoteDataSource.newConversation();

  @override
  Future<void> restoreConversation(String id) =>
      remoteDataSource.restoreConversation(id);

  @override
  void detachConversation() => remoteDataSource.detachConversation();

  @override
  String peekPersistedConversationId() =>
      remoteDataSource.peekPersistedConversationId();

  @override
  Future<void> rememberCurrentAsHistory() =>
      remoteDataSource.rememberCurrentAsHistory();
}
