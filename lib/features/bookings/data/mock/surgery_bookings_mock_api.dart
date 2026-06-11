import '../models/surgery_booking_list_item_model.dart';

class SurgeryBookingsMockApi {
  Future<List<SurgeryBookingListItemModel>> getBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mockBookings
        .map(SurgeryBookingListItemModel.fromJson)
        .toList(growable: false);
  }

  Future<SurgeryBookingListItemModel> getBookingDetails({
    required String bookingId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockBookings
        .map(SurgeryBookingListItemModel.fromJson)
        .firstWhere(
          (item) => item.bookingId == bookingId,
          orElse: () => SurgeryBookingListItemModel.fromJson(_mockBookings.first),
        );
  }

  static const List<Map<String, dynamic>> _mockBookings = [
    {
      'bookingId': 'sb-2026-0001',
      'procedure': 'LASIK Eye',
      'hospital': 'Al Shifa Hospital',
      'doctor': 'Dr. Sumbal Shahid',
      'specialty': 'Eye Surgeon',
      'qualification': 'MMBS, FCPS',
      'status': 'In Review',
      'dateCreated': '11 Feb,2025',
      'initialStatus': 'inReview',
      'procedureSubtitle': 'Photorefractive keratectomy Surgery',
      'patientName': 'Haseeb Qasim',
      'age': 24,
      'contactNumber': '0341-2211221',
      'emergencyContact': '0341-2211221',
      'fee': 80000,
      'discountPercent': 15,
      'discountAmount': 12000,
      'total': 68000,
      'appointmentDay': '15',
      'appointmentMonth': 'May',
      'appointmentWeekday': 'Thursday',
      'appointmentTime': '09am - 10am',
      'appointmentDateFull': '15th May,2025',
      'partnerLogoUrl': 'https://placehold.co/80x80/F39A2E/ffffff?text=ola',
    },
    {
      'bookingId': 'sb-2026-0002',
      'procedure': 'ACL',
      'hospital': 'Shaukat Khanum Memorial Hospital',
      'doctor': 'Dr. Hina Tariq',
      'specialty': 'Orthopaedic Surgeon',
      'qualification': 'MBBS, FCPS',
      'status': 'Payment Pending',
      'dateCreated': '14 Feb,2025',
      'initialStatus': 'paymentPending',
      'procedureSubtitle': 'ACL Reconstruction',
      'patientName': 'Ali Raza',
      'age': 32,
      'contactNumber': '0300-1234567',
      'emergencyContact': '0300-7654321',
      'fee': 120000,
      'discountPercent': 10,
      'discountAmount': 12000,
      'total': 108000,
      'appointmentDay': '20',
      'appointmentMonth': 'May',
      'appointmentWeekday': 'Tuesday',
      'appointmentTime': '11am - 12pm',
      'appointmentDateFull': '20th May,2025',
      'partnerLogoUrl': 'https://placehold.co/80x80/1F3A8A/ffffff?text=doc',
    },
    {
      'bookingId': 'sb-2026-0003',
      'procedure': 'Gallbladder Removal',
      'hospital': 'Aga Khan University Hospital',
      'doctor': 'Dr. Umar Farooq',
      'specialty': 'General Surgeon',
      'qualification': 'MBBS, FCPS',
      'status': 'Confirmed',
      'dateCreated': '18 Feb,2025',
      'initialStatus': 'confirmed',
      'procedureSubtitle': 'Laparoscopic Cholecystectomy',
      'patientName': 'Sara Khan',
      'age': 28,
      'contactNumber': '0333-9876543',
      'emergencyContact': '0333-1122334',
      'fee': 95000,
      'discountPercent': 12,
      'discountAmount': 11400,
      'total': 83600,
      'appointmentDay': '25',
      'appointmentMonth': 'May',
      'appointmentWeekday': 'Sunday',
      'appointmentTime': '02pm - 03pm',
      'appointmentDateFull': '25th May,2025',
      'partnerLogoUrl': 'https://placehold.co/80x80/0FAA9A/ffffff?text=AKU',
    },
  ];
}
