import '../../../../core/config/mock_config.dart';

class ConsultationBookingsListMockApi {
  static bool useMockResponses = MockConfig.enableConsultationMocks;

  Future<Map<String, dynamic>> getBookingsSuccessResponse({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Consultations retrieved',
      'code': 200,
      'data': {
        'data': [
          {
            'doctorInfo': {
              'doctorid': 6617,
              'displayName': 'Dr. M. Atif Munawar',
              'yearsOfExperience': 4,
              'profileImageUrl':
                  'https://images.unsplash.com/photo-1594824476967-48c8b964273f?auto=format&fit=crop&w=800&q=80',
              'consultationFee': '500.00',
              'discountPercent': '100.00',
              'isFree': false,
              'specialtyName': 'General Practitioner',
            },
            'slotDate': '2024-09-10',
            'slotStartTime': '10:00',
            'slotEndTime': '13:00',
            'success': 'PAID',
            'consultationLink': 'https://demo.oladoc.com/vc/mock-booking-001',
          },
          {
            'doctorInfo': {
              'doctorid': 6618,
              'displayName': 'Dr. Kainat Shahid',
              'yearsOfExperience': 4,
              'profileImageUrl':
                  'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=800&q=80',
              'consultationFee': '900.00',
              'discountPercent': '33.33',
              'isFree': false,
              'specialtyName': 'Neurologist',
            },
            'slotDate': '2024-09-11',
            'slotStartTime': '11:00',
            'slotEndTime': '12:00',
            'success': 'PAID',
            'consultationLink': 'https://demo.oladoc.com/vc/mock-booking-002',
          },
        ],
        'page': page,
        'limit': limit,
        'total': 2,
      },
    };
  }
}
