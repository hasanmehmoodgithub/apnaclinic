import 'package:equatable/equatable.dart';

import 'apna_clinic_ai_card_entity.dart';

class ApnaClinicAiTurnEntity extends Equatable {
  const ApnaClinicAiTurnEntity({
    required this.reply,
    required this.quickActions,
    required this.doctors,
    required this.slots,
    required this.slotDays,
    required this.payments,
    this.sectionTitles = const {},
    this.status,
    this.intent,
    this.failureCode,
    this.audioBase64,
    this.audioMediaType,
    this.audioPending = false,
    this.turnId,
    this.signInRequired = false,
    this.authResumeMessage,
    this.authDeepLink,
  });

  final String reply;
  final String? status;
  final String? intent;
  final String? failureCode;
  final List<ApnaClinicAiQuickActionEntity> quickActions;
  final List<ApnaClinicAiDoctorCardEntity> doctors;
  final List<ApnaClinicAiSlotEntity> slots;
  final List<ApnaClinicAiSlotDayEntity> slotDays;
  final List<ApnaClinicAiPaymentEntity> payments;
  /// Headings from each block `kind`'s `title`.
  final Map<String, String> sectionTitles;
  final String? audioBase64;
  final String? audioMediaType;
  /// True when SSE `final` arrives before a later `type: audio` event.
  final bool audioPending;
  /// Matches delayed SSE `type: audio` via `turn_id`.
  final String? turnId;
  final bool signInRequired;
  final String? authResumeMessage;
  final String? authDeepLink;

  @override
  List<Object?> get props => [
    reply,
    status,
    intent,
    failureCode,
    quickActions,
    doctors,
    slots,
    slotDays,
    payments,
    sectionTitles,
    audioBase64,
    audioMediaType,
    audioPending,
    turnId,
    signInRequired,
    authResumeMessage,
    authDeepLink,
  ];
}
