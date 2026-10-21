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
  });

  final String id;
  final ApnaClinicAiMessageRole role;
  final String text;
  final bool isVoice;
  final bool pending;
  final bool showEmergencyNote;
  final String? failureCode;

  ApnaClinicAiMessageEntity copyWith({
    String? text,
    bool? pending,
    bool? isVoice,
    bool? showEmergencyNote,
    String? failureCode,
    bool clearFailureCode = false,
  }) {
    return ApnaClinicAiMessageEntity(
      id: id,
      role: role,
      text: text ?? this.text,
      isVoice: isVoice ?? this.isVoice,
      pending: pending ?? this.pending,
      showEmergencyNote: showEmergencyNote ?? this.showEmergencyNote,
      failureCode: clearFailureCode ? null : (failureCode ?? this.failureCode),
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
  ];
}
