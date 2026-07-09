import '../data/models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingDetailsArgs {
  const DoctorConsultationBookingDetailsArgs({
    required this.bookingId,
    this.booking,
  });

  final String bookingId;
  final DoctorConsultationBookingDetailsModel? booking;
}
