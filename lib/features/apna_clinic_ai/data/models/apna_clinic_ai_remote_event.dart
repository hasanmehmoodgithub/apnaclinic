import '../models/apna_clinic_ai_turn_model.dart';

class ApnaClinicAiRemoteEvent {
  const ApnaClinicAiRemoteEvent._({
    required this.kind,
    this.text,
    this.stage,
    this.code,
    this.turn,
  });

  const ApnaClinicAiRemoteEvent.token(String accumulated)
    : this._(kind: ApnaClinicAiRemoteEventKind.token, text: accumulated);

  const ApnaClinicAiRemoteEvent.stage(String stage)
    : this._(kind: ApnaClinicAiRemoteEventKind.stage, stage: stage);

  const ApnaClinicAiRemoteEvent.failure(String code)
    : this._(kind: ApnaClinicAiRemoteEventKind.failure, code: code);

  const ApnaClinicAiRemoteEvent.finalTurn(ApnaClinicAiTurnModel turn)
    : this._(kind: ApnaClinicAiRemoteEventKind.finalTurn, turn: turn);

  final ApnaClinicAiRemoteEventKind kind;
  final String? text;
  final String? stage;
  final String? code;
  final ApnaClinicAiTurnModel? turn;
}

enum ApnaClinicAiRemoteEventKind { token, stage, failure, finalTurn }
