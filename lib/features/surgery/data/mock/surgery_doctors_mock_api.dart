import '../../../../core/config/mock_config.dart';

class SurgeryDoctorsMockApi {
  static bool useMockResponses = MockConfig.enableSurgeryMocks;

  Future<Map<String, dynamic>> getSurgeryDoctorsSuccessResponse({
    required String surgeryId,
    required String procedureName,
    required String city,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return {
      'success': true,
      'message': 'Providers retrieved',
      'code': 200,
      'data': [
        {
          'doctorName': 'Dr. Sumbal Shahid',
          'doctorSlug': 'sumbal-shahid',
          'hospitalName': 'Al Shifa International Hospital',
          'hospitalSlug': 'al-shifa-international',
          'price': 100000,
          'discountedPrice': 65000,
          'tatMessage': 'Our representative will contact you within 24 hours',
        },
        {
          'doctorName': 'Dr. Ayesha',
          'doctorSlug': 'ayesha',
          'hospitalName': 'Al Maroof Hospital',
          'hospitalSlug': 'al-maroof',
          'price': 100000,
          'discountedPrice': 65000,
          'tatMessage': 'Our representative will contact you within 24 hours',
        },
        {
          'doctorName': 'Dr. Raheel Khan',
          'doctorSlug': 'raheel-khan',
          'hospitalName': 'Al Maroof Hospital',
          'hospitalSlug': 'al-maroof',
          'price': 80000,
          'discountedPrice': 50000,
          'tatMessage': 'Our representative will contact you within 24 hours',
        },
      ],
    };
  }
}
