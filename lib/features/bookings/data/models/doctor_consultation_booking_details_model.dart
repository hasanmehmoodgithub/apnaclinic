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
        return DoctorConsultationBookingStatus.confirmed;
      case 'CANCEL':
        return DoctorConsultationBookingStatus.cancel;
      case 'COMPLETED':
      default:
        return DoctorConsultationBookingStatus.completed;
    }
  }
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
    required this.totalText,
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
  final String totalText;
}
