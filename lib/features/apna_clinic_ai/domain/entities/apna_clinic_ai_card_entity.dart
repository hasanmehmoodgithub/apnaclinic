import 'package:equatable/equatable.dart';

class ApnaClinicAiQuickActionEntity extends Equatable {
  const ApnaClinicAiQuickActionEntity({
    required this.label,
    required this.send,
    this.url,
  });

  final String label;
  final String send;
  /// App deep link for native navigation (e.g. pharmacy cart).
  final String? url;

  @override
  List<Object?> get props => [label, send, url];
}

class ApnaClinicAiDoctorCardEntity extends Equatable {
  const ApnaClinicAiDoctorCardEntity({
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

  bool get isMedicine => kind.toLowerCase() == 'medicine';

  bool get isPayment => kind.toLowerCase() == 'payment';

  @override
  List<Object?> get props => [
    id,
    kind,
    name,
    send,
    specialty,
    years,
    fee,
    rating,
    imageUrl,
    badge,
    description,
    cta,
  ];
}

class ApnaClinicAiSlotEntity extends Equatable {
  const ApnaClinicAiSlotEntity({required this.label, required this.send});

  final String label;
  final String send;

  @override
  List<Object?> get props => [label, send];
}

class ApnaClinicAiSlotDayEntity extends Equatable {
  const ApnaClinicAiSlotDayEntity({
    required this.date,
    required this.slots,
  });

  final String date;
  final List<ApnaClinicAiSlotEntity> slots;

  @override
  List<Object?> get props => [date, slots];
}

class ApnaClinicAiPaymentEntity extends Equatable {
  const ApnaClinicAiPaymentEntity({
    required this.label,
    required this.send,
    this.hint,
    this.url,
  });

  final String label;
  final String send;
  final String? hint;

  /// HTTP → payment web view; `apnaclinic://…` → native pharmacy/consultation.
  final String? url;

  bool get opensPaymentWebView {
    final link = url?.trim() ?? '';
    return link.startsWith('http://') || link.startsWith('https://');
  }

  bool get opensPharmacyCart {
    final link = url?.trim().toLowerCase() ?? '';
    if (link.isEmpty) return false;
    return link.contains('pharmacy/cart') ||
        link.contains('intent=pharmacy_checkout') ||
        link.startsWith('apnaclinic://pharmacy');
  }

  bool get opensConsultationCheckout {
    final link = url?.trim().toLowerCase() ?? '';
    if (link.isEmpty) return false;
    return link.contains('apnaclinic://doctor/') ||
        link.contains('intent=book_consultation');
  }

  @override
  List<Object?> get props => [label, send, hint, url];
}
