import '../entities/apna_clinic_ai_stream_event.dart';
import '../repositories/apna_clinic_ai_repository.dart';
import 'send_apna_clinic_ai_message_params.dart';

/// Streaming turn. Does not use [UseCase] because the SDK replies over SSE.
class SendApnaClinicAiMessageUseCase {
  SendApnaClinicAiMessageUseCase({required this.repository});

  final ApnaClinicAiRepository repository;

  Stream<ApnaClinicAiStreamEvent> call(SendApnaClinicAiMessageParams params) {
    return repository.sendMessage(params);
  }

  Future<void> newConversation() => repository.newConversation();

  Future<void> restoreConversation(String id) =>
      repository.restoreConversation(id);

  void detachConversation() => repository.detachConversation();

  String peekPersistedConversationId() =>
      repository.peekPersistedConversationId();
}
