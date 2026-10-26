class ApnaClinicAiQuickActionModel {
  const ApnaClinicAiQuickActionModel({required this.label, required this.send});

  final String label;
  final String send;
}

class ApnaClinicAiDoctorCardModel {
  const ApnaClinicAiDoctorCardModel({
    required this.name,
    required this.send,
    this.id,
    this.kind = 'doctor',
    this.specialty,
    this.years,
    this.fee,
    this.rating,
    this.imageUrl,
    this.badge,
    this.description,
    this.cta,
  });

  final String? id;
  final String kind;
  final String name;
  final String send;
  final String? specialty;
  final String? years;
  final String? fee;
  final String? rating;
  final String? imageUrl;
  final String? badge;
  final String? description;
  final String? cta;
}

class ApnaClinicAiSlotDayModel {
  const ApnaClinicAiSlotDayModel({
    required this.date,
    required this.slots,
  });

  final String date;
  final List<ApnaClinicAiSlotModel> slots;
}

class ApnaClinicAiSlotModel {
  const ApnaClinicAiSlotModel({required this.label, required this.send});

  final String label;
  final String send;
}

class ApnaClinicAiPaymentModel {
  const ApnaClinicAiPaymentModel({
    required this.label,
    required this.send,
    this.hint,
    this.url,
  });

  final String label;
  final String send;
  final String? hint;

  /// Card checkout URL. When set, the row opens the payment web view.
  final String? url;
}

class ApnaClinicAiTurnModel {
  const ApnaClinicAiTurnModel({
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
  final List<ApnaClinicAiQuickActionModel> quickActions;
  final List<ApnaClinicAiDoctorCardModel> doctors;
  final List<ApnaClinicAiSlotModel> slots;
  final List<ApnaClinicAiSlotDayModel> slotDays;
  final List<ApnaClinicAiPaymentModel> payments;
  final String? audioBase64;
  final String? audioMediaType;
  final bool audioPending;
  /// Server turn id from SSE `final` / delayed `type: audio` (`turn_id`).
  final String? turnId;
  final bool signInRequired;
  final String? authResumeMessage;
  final String? authDeepLink;
}
