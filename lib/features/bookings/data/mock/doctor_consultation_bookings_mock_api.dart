import '../models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingsMockApi {
  Future<List<DoctorConsultationBookingDetailsModel>> getBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mockBookings;
  }

  Future<DoctorConsultationBookingDetailsModel> getBookingDetails({
    required String bookingId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return _mockBookings.firstWhere(
      (item) => item.bookingId == bookingId,
      orElse: () => _mockBookings.first,
    );
  }

  static final List<DoctorConsultationBookingDetailsModel> _mockBookings = [
    DoctorConsultationBookingDetailsModel(
      bookingId: 'dc-1',
      doctorName: 'Dr. Saadiya Akhtar J.',
      specialty: 'General Practitioner',
      experience: '4 years Experience',
      qualification: 'MBBS',
      doctorImageUrl:
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?auto=format&fit=crop&w=800&q=80',
      status: DoctorConsultationBookingStatus.confirmed,
      listDate: '10/09/24',
      listTime: '10am - 1pm',
      appointmentMonth: 'May',
      appointmentDay: '07',
      appointmentWeekday: 'Thursday',
      appointmentTime: '07:30pm - 08:00pm',
      patientLabel: 'Self',
      patientValue: 'Self',
      issueLabel: 'Feeling ill',
      issueValue: 'Feeling ill',
      consultationFee: 500,
      discountAmount: 500,
      totalText: 'Free',
    ),
    DoctorConsultationBookingDetailsModel(
      bookingId: 'dc-2',
      doctorName: 'Dr. Kainat Shahid',
      specialty: 'Neurologist',
      experience: '4 years Experience',
      qualification: 'MBBS, FCPS',
      doctorImageUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=800&q=80',
      status: DoctorConsultationBookingStatus.pending,
      listDate: '11/09/24',
      listTime: '11am - 12pm',
      appointmentMonth: 'May',
      appointmentDay: '08',
      appointmentWeekday: 'Friday',
      appointmentTime: '11:30am - 12:00pm',
      patientLabel: 'Self',
      patientValue: 'Self',
      issueLabel: 'Headache',
      issueValue: 'Headache',
      consultationFee: 900,
      discountAmount: 300,
      totalText: 'Rs.600',
    ),
    DoctorConsultationBookingDetailsModel(
      bookingId: 'dc-3',
      doctorName: 'Dr. Umar Farooq',
      specialty: 'Orthopaedic',
      experience: '6 years Experience',
      qualification: 'MBBS, FCPS',
      doctorImageUrl:
          'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=800&q=80',
      status: DoctorConsultationBookingStatus.cancel,
      listDate: '12/09/24',
      listTime: '08am - 09am',
      appointmentMonth: 'May',
      appointmentDay: '09',
      appointmentWeekday: 'Saturday',
      appointmentTime: '08:30am - 09:00am',
      patientLabel: 'Self',
      patientValue: 'Self',
      issueLabel: 'Back pain',
      issueValue: 'Back pain',
      consultationFee: 1200,
      discountAmount: 200,
      totalText: 'Rs.1000',
    ),
    DoctorConsultationBookingDetailsModel(
      bookingId: 'dc-4',
      doctorName: 'Dr. Hina Tariq',
      specialty: 'Dermatologist',
      experience: '8 years Experience',
      qualification: 'MBBS, DDerm',
      doctorImageUrl:
          'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?auto=format&fit=crop&w=800&q=80',
      status: DoctorConsultationBookingStatus.completed,
      listDate: '13/09/24',
      listTime: '03pm - 04pm',
      appointmentMonth: 'May',
      appointmentDay: '10',
      appointmentWeekday: 'Sunday',
      appointmentTime: '03:30pm - 04:00pm',
      patientLabel: 'Self',
      patientValue: 'Self',
      issueLabel: 'Skin rash',
      issueValue: 'Skin rash',
      consultationFee: 1000,
      discountAmount: 500,
      totalText: 'Rs.500',
    ),
  ];
}
