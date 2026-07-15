class ConsultationBookingPatientReviewEntity {
  const ConsultationBookingPatientReviewEntity({
    required this.rating,
    required this.review,
    required this.date,
  });

  final double rating;
  final String review;
  final String date;
}

class ConsultationBookingListItemEntity {
  const ConsultationBookingListItemEntity({
    required this.bookingId,
    required this.status,
    required this.slotDate,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.consultationFee,
    required this.discountAmount,
    required this.originalFee,
    required this.discountPercent,
    required this.patientRelation,
    required this.issue,
    required this.doctorName,
    required this.specialty,
    required this.yearsOfExperience,
    required this.qualifications,
    required this.education,
    required this.doctorImageUrl,
    this.consultationLink = '',
    this.partnerRefNo = '',
    this.ratings,
    this.pmdcVerified = false,
    this.partnerTenantId = '',
    this.partnerLogoUrl = '',
    this.attachments = const [],
    this.doctorPrescriptions = const [],
    this.patientReview,
  });

  final String bookingId;
  final String status;
  final String slotDate;
  final String slotStartTime;
  final String slotEndTime;

  /// Amount payable after discount.
  final int consultationFee;
  final int discountAmount;

  /// Fee before discount.
  final int originalFee;
  final double discountPercent;
  final String patientRelation;
  final String issue;
  final String doctorName;
  final String specialty;
  final int? yearsOfExperience;
  final List<String> qualifications;
  final String education;
  final String doctorImageUrl;
  /// Video consult / join URL (`meetingLink` from API).
  final String consultationLink;
  final String partnerRefNo;
  final double? ratings;
  final bool pmdcVerified;
  final String partnerTenantId;
  final String partnerLogoUrl;
  final List<String> attachments;
  /// Doctor-issued prescription file URLs (`doctorPerscriptions` API typo supported).
  final List<String> doctorPrescriptions;
  final ConsultationBookingPatientReviewEntity? patientReview;
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
