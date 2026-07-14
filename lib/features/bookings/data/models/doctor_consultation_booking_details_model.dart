enum DoctorConsultationBookingStatus {
  pending,
  confirmed,
  cancel,
  completed;

  static DoctorConsultationBookingStatus fromApi(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return DoctorConsultationBookingStatus.pending;
      case 'CONFIRMED':
      case 'PAID':
        return DoctorConsultationBookingStatus.confirmed;
      case 'CANCEL':
      case 'CANCELLED':
      case 'CANCELED':
        return DoctorConsultationBookingStatus.cancel;
      case 'COMPLETED':
      default:
        return DoctorConsultationBookingStatus.completed;
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
    this.ratings,
    this.pmdcVerified = false,
    this.partnerTenantId = '',
    this.partnerLogoUrl = '',
    this.attachments = const [],
    this.patientReview,
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
  final double? ratings;
  final bool pmdcVerified;
  final String partnerTenantId;
  final String partnerLogoUrl;
  final List<String> attachments;
  final DoctorConsultationBookingPatientReview? patientReview;

  /// Prefer partner ref for feedback API; fall back to booking id.
  String get feedbackRefNo {
    final partner = partnerRefNo.trim();
    if (partner.isNotEmpty) return partner;
    return bookingId.trim();
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
      ratings: ratings,
      pmdcVerified: pmdcVerified,
      partnerTenantId: partnerTenantId,
      partnerLogoUrl: partnerLogoUrl,
      attachments: attachments,
      patientReview: patientReview ?? this.patientReview,
    );
  }
}
