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
            'appointmentId': 11,
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
            'meetingLink': 'https://demo.oladoc.com/vc/mock-meeting-1',
            'issue': null,
            'attachments': <String>[],
            'doctorPerscriptions': <String>[],
            'patientReview': {
              'rating': 5,
              'review': 'Excellent consultation',
              'date': '2026-07-14',
            },
          },
          {
            'appointmentId': 12,
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
            'meetingLink': 'https://demo.oladoc.com/vc/mock-meeting-2',
            'issue': null,
            'attachments': [
              'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/consultations/attachments/019f3c76-3fc5-7059-a7b5-a5d78f08dddf.png',
            ],
            'doctorPerscriptions': [
              'https://medicalguidelines.msf.org/sites/default/files/2026-05/guideline-170-en.pdf',
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

  Future<Map<String, dynamic>> getBookingSuccessResponse({
    required int appointmentId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final list = await getBookingsSuccessResponse();
    final pageData = list['data'];
    final items = pageData is Map ? pageData['data'] : null;
    if (items is List) {
      for (final item in items) {
        if (item is! Map) continue;
        final id = item['appointmentId'];
        final parsed = id is num
            ? id.toInt()
            : int.tryParse(id?.toString() ?? '');
        if (parsed == appointmentId) {
          return {
            'success': true,
            'message': 'Consultation retrieved',
            'code': 200,
            'data': Map<String, dynamic>.from(item),
          };
        }
      }
    }

    return {
      'success': true,
      'message': 'Consultation retrieved',
      'code': 200,
      'data': {
        'appointmentId': appointmentId,
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
          'partner': {
            'tenantId': 2,
            'logoUrl':
                'http://bucket-route-minio.apps.jpocp.jazz.com.pk/apna-clinic/019f6574-0e42-711a-beff-919f80951036.png',
          },
        },
        'patientRelation': 'Self',
        'slotDate': '2026-07-13',
        'slotStartTime': '09:20 AM',
        'slotEndTime': '09:40 AM',
        'success': 'PAID',
        'partnerRefNo': '1ZMVN7Z0',
        'meetingLink': 'https://demo.oladoc.com/vc/FnqWNcLJ1783692953',
        'issue': null,
        'attachments': <String>[],
        'doctorPerscriptions': <String>[],
        'patientReview': {
          'rating': 5,
          'review': 'Excellent consultation',
          'date': '2026-07-14',
        },
      },
    };
  }
}
