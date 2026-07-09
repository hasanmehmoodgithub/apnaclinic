class ConsultationBookingListItemEntity {
  const ConsultationBookingListItemEntity({
    required this.bookingId,
    required this.status,
    required this.slotDate,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.consultationFee,
    required this.discountAmount,
    required this.patientRelation,
    required this.issue,
    required this.doctorName,
    required this.specialty,
    required this.yearsOfExperience,
    required this.qualifications,
    required this.education,
    required this.doctorImageUrl,
    this.consultationLink = '',
  });

  final String bookingId;
  final String status;
  final String slotDate;
  final String slotStartTime;
  final String slotEndTime;
  final int consultationFee;
  final int discountAmount;
  final String patientRelation;
  final String issue;
  final String doctorName;
  final String specialty;
  final int? yearsOfExperience;
  final List<String> qualifications;
  final String education;
  final String doctorImageUrl;
  final String consultationLink;
}

class ConsultationBookingsPageEntity {
  const ConsultationBookingsPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<ConsultationBookingListItemEntity> items;
  final int page;
  final int limit;
  final int total;

  bool get hasMore => page * limit < total;
}
