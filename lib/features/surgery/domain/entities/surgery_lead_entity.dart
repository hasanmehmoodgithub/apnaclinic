class SurgeryLeadEntity {
  const SurgeryLeadEntity({
    required this.leadId,
    required this.surgeryId,
    required this.surgeryType,
    required this.subSurgeryType,
    required this.providerId,
    required this.providerName,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.education,
    required this.status,
    required this.paymentAllowed,
    required this.leadCreatedDate,
    required this.leadCreatedTime,
    required this.leadCreatedAt,
    required this.confirmedDate,
    required this.scheduledDate,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.phone,
    required this.emergencyPhone,
    required this.fee,
    required this.discount,
    required this.total,
    required this.currency,
  });

  final String leadId;
  final String surgeryId;
  final String surgeryType;
  final String subSurgeryType;
  final String providerId;
  final String providerName;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String education;

  /// API `status` (e.g. PENDING, PAID).
  final String status;
  final bool paymentAllowed;
  final String leadCreatedDate;
  final String leadCreatedTime;
  final String leadCreatedAt;
  final String? confirmedDate;
  final String? scheduledDate;
  final String patientName;
  final int age;
  final String gender;
  final String phone;
  final String emergencyPhone;
  final int fee;
  final int discount;
  final int total;
  final String currency;
}

class SurgeryLeadsPageEntity {
  const SurgeryLeadsPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<SurgeryLeadEntity> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
