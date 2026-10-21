import '../../../../core/functional/functional_export.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../domain/apna_clinic_ai_failure_codes.dart';
import '../../domain/entities/apna_clinic_ai_session_entity.dart';
import '../../domain/entities/apna_clinic_ai_stream_event.dart';
import '../../domain/repositories/apna_clinic_ai_repository.dart';
import '../../domain/use_cases/init_apna_clinic_ai_session_params.dart';
import '../../domain/use_cases/send_apna_clinic_ai_message_params.dart';
import '../../domain/utils/apna_clinic_ai_msisdn.dart';
import '../data_sources/apna_clinic_ai_local_data_source.dart';
import '../data_sources/apna_clinic_ai_remote_data_source.dart';
import '../data_sources/apna_clinic_ai_sdk_client.dart';
import '../mappers/apna_clinic_ai_mapper.dart';
import '../models/apna_clinic_ai_remote_event.dart';

class ApnaClinicAiRepositoryImpl implements ApnaClinicAiRepository {
  ApnaClinicAiRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.appPref,
  });

  final ApnaClinicAiRemoteDataSource remoteDataSource;
  final ApnaClinicAiLocalDataSource localDataSource;
  final AppPref appPref;

  @override
  Future<Either<ErrorMsg, ApnaClinicAiSessionEntity>> ensureSession(
    InitApnaClinicAiSessionParams params,
  ) async {
    try {
      final signedIn = AuthGuard.isLoggedIn(appPref);
      final mode = signedIn ? 'signed_in' : 'guest';
      final deviceId = await localDataSource.deviceId();
      final user = appPref.getUserLocalModel();

      String? name;
      String? email;
      String? msisdn;
      if (signedIn) {
        final fullName = [
          user?.firstName.trim() ?? '',
          user?.lastName.trim() ?? '',
        ].where((part) => part.isNotEmpty).join(' ');
        name = fullName.isEmpty ? null : fullName;
        final rawEmail = user?.email.trim() ?? '';
        email = rawEmail.isEmpty ? null : rawEmail;
        msisdn = normalizeApnaClinicAiMsisdn(user?.phone);
      }

      final model = await remoteDataSource.ensureSession(
        mode: mode,
        deviceId: deviceId,
        msisdn: msisdn,
        name: name,
        email: email,
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
    await for (final event in remoteDataSource.sendMessage(
      message: params.message,
      speak: params.speak,
      voiceId: params.voiceId,
    )) {
      switch (event.kind) {
        case ApnaClinicAiRemoteEventKind.token:
          yield ApnaClinicAiStreamToken(event.text ?? '');
        case ApnaClinicAiRemoteEventKind.stage:
          yield ApnaClinicAiStreamStage(event.stage ?? '');
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
}
