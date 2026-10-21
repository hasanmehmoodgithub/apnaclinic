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
