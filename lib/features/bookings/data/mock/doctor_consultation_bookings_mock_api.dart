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
      bookingId: '1ZQYOXDG',
      doctorName: 'Dr. M. Atif Munawar',
      specialty: 'Oncologist',
      experience: '',
      qualification: '',
      doctorImageUrl:
          'https://d1t78adged64l7.cloudfront.net/images/profile-pics/doctors-ww-jbxzjskfsd/1586874314_doc_male_orig-png.webp?t=1605656842',
      status: DoctorConsultationBookingStatus.confirmed,
      listDate: '16/07/26',
      listTime: '9:40 am - 10:00 am',
      appointmentMonth: 'Jul',
      appointmentDay: '16',
      appointmentWeekday: 'Thursday',
      appointmentTime: '9:40 am - 10:00 am',
      patientLabel: 'Self',
      patientValue: 'Self',
      issueLabel: '-',
      issueValue: '-',
      consultationFee: 3000,
      discountAmount: 0,
      originalFee: 3000,
      discountPercent: 0,
      totalText: 'Rs.3000',
      partnerRefNo: '1ZQYOXDG',
      meetingLink: 'https://demo.oladoc.com/vc/hnl9o3tZ1783939936',
      ratings: 5,
      pmdcVerified: true,
      partnerTenantId: '2',
      patientReview: const DoctorConsultationBookingPatientReview(
        rating: 5,
        review: 'Excellent consultation',
        dateLabel: '14/07/2026',
      ),
    ),
    DoctorConsultationBookingDetailsModel(
      bookingId: '1ZIGLGUT',
      doctorName: 'Dr. Akshai Kumar',
      specialty: 'Family Physician',
      experience: '',
      qualification: '',
      doctorImageUrl:
          'https://d1t78adged64l7.cloudfront.net/images/profile-pics/doctors-ww-jbxzjskfsd/1755953292-159240455003529ecd-ce14-45eb-82e6-3e38ce7a8f57.webp?t=1755953293',
      status: DoctorConsultationBookingStatus.confirmed,
      listDate: '07/07/26',
      listTime: '5:40 pm - 5:50 pm',
      appointmentMonth: 'Jul',
      appointmentDay: '07',
      appointmentWeekday: 'Tuesday',
      appointmentTime: '5:40 pm - 5:50 pm',
      patientLabel: 'Self',
      patientValue: 'Self',
      issueLabel: '-',
      issueValue: '-',
      consultationFee: 1000,
      discountAmount: 0,
      originalFee: 1000,
      discountPercent: 0,
      totalText: 'Rs.1000',
      partnerRefNo: '1ZIGLGUT',
      meetingLink: 'https://demo.oladoc.com/vc/uw2DKUdF1783425812',
      ratings: 5,
      pmdcVerified: true,
      partnerTenantId: '2',
      attachments: const [
        'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/consultations/attachments/019f3c76-3fc5-7059-a7b5-a5d78f08dddf.png',
      ],
      doctorPrescriptions: const [
        'https://medicalguidelines.msf.org/sites/default/files/2026-05/guideline-170-en.pdf',
      ],
    ),
  ];
}
