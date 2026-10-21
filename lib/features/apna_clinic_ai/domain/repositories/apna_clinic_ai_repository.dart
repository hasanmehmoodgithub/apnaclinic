import '../../../../core/functional/functional_export.dart';
import '../entities/apna_clinic_ai_session_entity.dart';
import '../entities/apna_clinic_ai_stream_event.dart';
import '../use_cases/init_apna_clinic_ai_session_params.dart';
import '../use_cases/send_apna_clinic_ai_message_params.dart';

abstract class ApnaClinicAiRepository {
  Future<Either<ErrorMsg, ApnaClinicAiSessionEntity>> ensureSession(
    InitApnaClinicAiSessionParams params,
  );

  Stream<ApnaClinicAiStreamEvent> sendMessage(SendApnaClinicAiMessageParams params);

  Future<void> newConversation();

  Future<void> restoreConversation(String id);

  void detachConversation();

  String peekPersistedConversationId();
}
