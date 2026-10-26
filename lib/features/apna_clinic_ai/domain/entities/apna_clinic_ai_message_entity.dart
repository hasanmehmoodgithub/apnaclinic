import 'package:equatable/equatable.dart';

enum ApnaClinicAiMessageRole { user, assistant, system }

class ApnaClinicAiMessageEntity extends Equatable {
  const ApnaClinicAiMessageEntity({
    required this.id,
    required this.role,
    required this.text,
    this.isVoice = false,
    this.pending = false,
    this.showEmergencyNote = false,
    this.failureCode,
    this.audioBase64,
    this.audioMediaType,
    this.audioPending = false,
    this.turnId,
    this.sentAt,
  });

  final String id;
  final ApnaClinicAiMessageRole role;
  final String text;
  final bool isVoice;
  final bool pending;
  final bool showEmergencyNote;
  final String? failureCode;
  final String? audioBase64;
  final String? audioMediaType;
  /// True after `final` with `audio_pending` until delayed `type: audio` attaches.
  final bool audioPending;
  /// Server `turn_id` used to attach delayed `type: audio` clips.
  final String? turnId;
  final DateTime? sentAt;

  bool get hasAudio => (audioBase64 ?? '').isNotEmpty;

  ApnaClinicAiMessageEntity copyWith({
    String? text,
    bool? pending,
    bool? isVoice,
    bool? showEmergencyNote,
    String? failureCode,
    bool clearFailureCode = false,
    String? audioBase64,
    String? audioMediaType,
    bool clearAudio = false,
    bool? audioPending,
    String? turnId,
  }) {
    return ApnaClinicAiMessageEntity(
      id: id,
      role: role,
      text: text ?? this.text,
      isVoice: isVoice ?? this.isVoice,
      pending: pending ?? this.pending,
      showEmergencyNote: showEmergencyNote ?? this.showEmergencyNote,
      failureCode: clearFailureCode ? null : (failureCode ?? this.failureCode),
      audioBase64: clearAudio ? null : (audioBase64 ?? this.audioBase64),
      audioMediaType: clearAudio
          ? null
          : (audioMediaType ?? this.audioMediaType),
      audioPending: audioPending ?? this.audioPending,
      turnId: turnId ?? this.turnId,
      sentAt: sentAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    role,
    text,
    isVoice,
    pending,
    showEmergencyNote,
    failureCode,
    hasAudio,
    audioPending,
    turnId,
    sentAt,
  ];
}
