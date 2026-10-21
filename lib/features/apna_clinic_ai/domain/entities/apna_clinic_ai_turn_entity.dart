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
    this.status,
    this.intent,
    this.failureCode,
    this.audioBase64,
    this.audioMediaType,
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
  final String? audioBase64;
  final String? audioMediaType;
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
    audioBase64,
    audioMediaType,
    signInRequired,
    authResumeMessage,
    authDeepLink,
  ];
}
