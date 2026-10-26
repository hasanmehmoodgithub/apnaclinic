import 'apna_clinic_ai_turn_entity.dart';

sealed class ApnaClinicAiStreamEvent {
  const ApnaClinicAiStreamEvent();
}

class ApnaClinicAiStreamToken extends ApnaClinicAiStreamEvent {
  const ApnaClinicAiStreamToken(this.accumulated);

  final String accumulated;
}

class ApnaClinicAiStreamStage extends ApnaClinicAiStreamEvent {
  const ApnaClinicAiStreamStage(this.stage);

  final String stage;
}

class ApnaClinicAiStreamFailure extends ApnaClinicAiStreamEvent {
  const ApnaClinicAiStreamFailure(this.code);

  final String code;
}

class ApnaClinicAiStreamFinal extends ApnaClinicAiStreamEvent {
  const ApnaClinicAiStreamFinal(this.turn);

  final ApnaClinicAiTurnEntity turn;
}

/// Server (or interim) transcription of the user's voice clip.
class ApnaClinicAiStreamTranscription extends ApnaClinicAiStreamEvent {
  const ApnaClinicAiStreamTranscription(this.text);

  final String text;
}

/// Delayed TTS clip after `final` with `audio_pending: true`.
class ApnaClinicAiStreamAudio extends ApnaClinicAiStreamEvent {
  const ApnaClinicAiStreamAudio({
    required this.audioBase64,
    this.audioMediaType,
    this.turnId,
  });

  final String audioBase64;
  final String? audioMediaType;
  /// Same `turn_id` as the preceding `final` event.
  final String? turnId;
}
