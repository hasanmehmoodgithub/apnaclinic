import '../models/apna_clinic_ai_turn_model.dart';

class ApnaClinicAiRemoteEvent {
  const ApnaClinicAiRemoteEvent._({
    required this.kind,
    this.text,
    this.stage,
    this.code,
    this.turn,
    this.audioBase64,
    this.audioMediaType,
    this.turnId,
  });

  const ApnaClinicAiRemoteEvent.token(String accumulated)
    : this._(kind: ApnaClinicAiRemoteEventKind.token, text: accumulated);

  const ApnaClinicAiRemoteEvent.stage(String stage)
    : this._(kind: ApnaClinicAiRemoteEventKind.stage, stage: stage);

  const ApnaClinicAiRemoteEvent.failure(String code)
    : this._(kind: ApnaClinicAiRemoteEventKind.failure, code: code);

  const ApnaClinicAiRemoteEvent.finalTurn(ApnaClinicAiTurnModel turn)
    : this._(kind: ApnaClinicAiRemoteEventKind.finalTurn, turn: turn);

  const ApnaClinicAiRemoteEvent.transcription(String text)
    : this._(kind: ApnaClinicAiRemoteEventKind.transcription, text: text);

  const ApnaClinicAiRemoteEvent.audio({
    required String base64,
    String? mediaType,
    String? turnId,
  }) : this._(
         kind: ApnaClinicAiRemoteEventKind.audio,
         audioBase64: base64,
         audioMediaType: mediaType,
         turnId: turnId,
       );

  final ApnaClinicAiRemoteEventKind kind;
  final String? text;
  final String? stage;
  final String? code;
  final ApnaClinicAiTurnModel? turn;
  final String? audioBase64;
  final String? audioMediaType;
  final String? turnId;
}

enum ApnaClinicAiRemoteEventKind {
  token,
  stage,
  failure,
  finalTurn,
  transcription,
  audio,
}
