import 'package:equatable/equatable.dart';

class ApnaClinicAiQuickActionEntity extends Equatable {
  const ApnaClinicAiQuickActionEntity({required this.label, required this.send});

  final String label;
  final String send;

  @override
  List<Object?> get props => [label, send];
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

  /// Card checkout URL. When set, the row opens the payment web view.
  final String? url;

  bool get opensPaymentWebView {
    final link = url?.trim() ?? '';
    return link.startsWith('http://') || link.startsWith('https://');
  }

  @override
  List<Object?> get props => [label, send, hint, url];
}
