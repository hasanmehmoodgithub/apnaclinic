enum DoctorConsultationBookingStatus {
  pending,
  confirmed,
  cancel,
  completed,
  failed;

  static DoctorConsultationBookingStatus fromApi(String value) {
    switch (value.trim().toUpperCase().replaceAll(' ', '_')) {
      case 'PENDING':
      case 'PENDING_PAYMENT':
        return DoctorConsultationBookingStatus.pending;
      case 'CONFIRMED':
      case 'PAID':
        return DoctorConsultationBookingStatus.confirmed;
      case 'CANCEL':
      case 'CANCELLED':
      case 'CANCELED':
        return DoctorConsultationBookingStatus.cancel;
      case 'FAILED':
        return DoctorConsultationBookingStatus.failed;
      case 'COMPLETED':
        return DoctorConsultationBookingStatus.completed;
      default:
        return DoctorConsultationBookingStatus.pending;
    }
  }
}

class DoctorConsultationBookingPatientReview {
  const DoctorConsultationBookingPatientReview({
    required this.rating,
    required this.review,
    required this.dateLabel,
  });

  final double rating;
  final String review;
  final String dateLabel;
}

class DoctorConsultationBookingDetailsModel {
  const DoctorConsultationBookingDetailsModel({
    required this.bookingId,
    required this.doctorName,
    required this.specialty,
    required this.experience,
    required this.qualification,
    required this.doctorImageUrl,
    required this.status,
    required this.listDate,
    required this.listTime,
    required this.appointmentMonth,
    required this.appointmentDay,
    required this.appointmentWeekday,
    required this.appointmentTime,
    required this.patientLabel,
    required this.patientValue,
    required this.issueLabel,
    required this.issueValue,
    required this.consultationFee,
    required this.discountAmount,
    required this.originalFee,
    required this.discountPercent,
    required this.totalText,
    this.partnerRefNo = '',
    this.meetingLink = '',
    this.ratings,
    this.pmdcVerified = false,
    this.partnerTenantId = '',
    this.partnerLogoUrl = '',
    this.attachments = const [],
    this.doctorPrescriptions = const [],
    this.patientReview,
    this.slotStartAt,
    this.slotEndAt,
  });

  final String bookingId;
  final String doctorName;
  final String specialty;
  final String experience;
  final String qualification;
  final String doctorImageUrl;
  final DoctorConsultationBookingStatus status;
  final String listDate;
  final String listTime;
  final String appointmentMonth;
  final String appointmentDay;
  final String appointmentWeekday;
  final String appointmentTime;
  final String patientLabel;
  final String patientValue;
  final String issueLabel;
  final String issueValue;
  final int consultationFee;
  final int discountAmount;
  final int originalFee;
  final double discountPercent;
  final String totalText;
  final String partnerRefNo;
  final String meetingLink;
  final double? ratings;
  final bool pmdcVerified;
  final String partnerTenantId;
  final String partnerLogoUrl;
  final List<String> attachments;
  final List<String> doctorPrescriptions;
  final DoctorConsultationBookingPatientReview? patientReview;
  final DateTime? slotStartAt;
  final DateTime? slotEndAt;

  /// Prefer partner ref for feedback API; fall back to booking id.
  String get feedbackRefNo {
    final partner = partnerRefNo.trim();
    if (partner.isNotEmpty) return partner;
    return bookingId.trim();
  }

  /// Patient attachments + doctor prescriptions for the Documents section.
  List<String> get documentUrls {
    if (doctorPrescriptions.isEmpty) return attachments;
    if (attachments.isEmpty) return doctorPrescriptions;
    return [...doctorPrescriptions, ...attachments];
  }

  /// Join when confirmed, link present, and now is within [start, end].
  bool get canJoinNow {
    if (status != DoctorConsultationBookingStatus.confirmed) return false;
    if (meetingLink.trim().isEmpty) return false;
    final start = slotStartAt;
    final end = slotEndAt;
    if (start == null || end == null) return false;
    final now = DateTime.now();
    return !now.isBefore(start) && !now.isAfter(end);
  }

  /// Feedback submit / “Your Feedback” after slot end only.
  bool get canShowFeedbackSection {
    final end = slotEndAt;
    if (end == null) return patientReview != null;
    return DateTime.now().isAfter(end);
  }

  DoctorConsultationBookingDetailsModel copyWith({
    DoctorConsultationBookingPatientReview? patientReview,
  }) {
    return DoctorConsultationBookingDetailsModel(
      bookingId: bookingId,
      doctorName: doctorName,
      specialty: specialty,
      experience: experience,
      qualification: qualification,
      doctorImageUrl: doctorImageUrl,
      status: status,
      listDate: listDate,
      listTime: listTime,
      appointmentMonth: appointmentMonth,
      appointmentDay: appointmentDay,
      appointmentWeekday: appointmentWeekday,
      appointmentTime: appointmentTime,
      patientLabel: patientLabel,
      patientValue: patientValue,
      issueLabel: issueLabel,
      issueValue: issueValue,
      consultationFee: consultationFee,
      discountAmount: discountAmount,
      originalFee: originalFee,
      discountPercent: discountPercent,
      totalText: totalText,
      partnerRefNo: partnerRefNo,
      meetingLink: meetingLink,
      ratings: ratings,
      pmdcVerified: pmdcVerified,
      partnerTenantId: partnerTenantId,
      partnerLogoUrl: partnerLogoUrl,
      attachments: attachments,
      doctorPrescriptions: doctorPrescriptions,
      patientReview: patientReview ?? this.patientReview,
      slotStartAt: slotStartAt,
      slotEndAt: slotEndAt,
    );
  }
}
