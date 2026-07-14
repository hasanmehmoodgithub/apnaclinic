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
              'yearsOfExperience': null,
              'profileImageUrl':
                  'https://d1t78adged64l7.cloudfront.net/images/profile-pics/doctors-ww-jbxzjskfsd/1586874314_doc_male_orig-png.webp?t=1605656842',
              'consultationFee': '3000.00',
              'discountPercent': '0.00',
              'isFree': false,
              'education': null,
              'specialtyName': 'Oncologist',
              'ratings': 5,
              'pmdcVerified': true,
              'partner': {'tenantId': 2, 'logoUrl': null},
            },
            'patientRelation': 'Self',
            'slotDate': '2026-07-16',
            'slotStartTime': '09:40',
            'slotEndTime': '10:00',
            'success': 'PAID',
            'partnerRefNo': '1ZQYOXDG',
            'issue': null,
            'attachments': <String>[],
            'patientReview': {
              'rating': 5,
              'review': 'Excellent consultation',
              'date': '2026-07-14',
            },
          },
          {
            'doctorInfo': {
              'doctorid': 6538,
              'displayName': 'Dr. Akshai Kumar',
              'yearsOfExperience': null,
              'profileImageUrl':
                  'https://d1t78adged64l7.cloudfront.net/images/profile-pics/doctors-ww-jbxzjskfsd/1755953292-159240455003529ecd-ce14-45eb-82e6-3e38ce7a8f57.webp?t=1755953293',
              'consultationFee': '1000.00',
              'discountPercent': '0.00',
              'isFree': false,
              'education': null,
              'specialtyName': 'Family Physician',
              'ratings': 5,
              'pmdcVerified': true,
              'partner': {'tenantId': 2, 'logoUrl': null},
            },
            'patientRelation': 'self',
            'slotDate': '2026-07-07',
            'slotStartTime': '17:40',
            'slotEndTime': '17:50',
            'success': 'PAID',
            'partnerRefNo': '1ZIGLGUT',
            'issue': null,
            'attachments': [
              'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/consultations/attachments/019f3c76-3fc5-7059-a7b5-a5d78f08dddf.png',
            ],
            'patientReview': null,
          },
        ],
        'page': page,
        'limit': limit,
        'total': 2,
      },
    };
  }
}
