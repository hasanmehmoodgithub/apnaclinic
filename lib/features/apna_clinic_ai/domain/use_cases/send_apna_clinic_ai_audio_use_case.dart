import '../entities/apna_clinic_ai_stream_event.dart';
import '../repositories/apna_clinic_ai_repository.dart';
import 'send_apna_clinic_ai_audio_params.dart';

/// Multipart audio SSE turn (`/assistant/turn/audio/stream`).
class SendApnaClinicAiAudioUseCase {
  SendApnaClinicAiAudioUseCase({required this.repository});

  final ApnaClinicAiRepository repository;

  Stream<ApnaClinicAiStreamEvent> call(SendApnaClinicAiAudioParams params) {
    return repository.sendAudio(params);
  }
}
