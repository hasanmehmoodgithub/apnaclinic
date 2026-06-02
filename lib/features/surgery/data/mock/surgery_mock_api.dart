import '../../../../core/config/mock_config.dart';

class SurgeryMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getSurgeryContentSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Surgery content fetched successfully',
      'defaultCity': 'Islamabad',
      'cities': ['Islamabad', 'Lahore', 'Peshawar', 'Rawalpindi', 'Karachi'],
      'procedures': [
        {
          'id': 'acl',
          'name': 'ACL',
          'highlighted': true,
          'description':
              'Anterior cruciate ligament (ACL) is in the middle of the knee. It prevents the shin bone from sliding out in front of the thigh bone. Posterior cruciate ligament (PCL) works with the ACL. It prevents the shin bone from sliding backward under the femur.',
        },
        {
          'id': 'cataract-eye',
          'name': 'Cataract Eye',
          'highlighted': true,
          'description':
              'Cataract surgery removes the cloudy lens and improves vision.',
        },
        {
          'id': 'c-section',
          'name': 'C-Section',
          'highlighted': true,
          'description': 'C-section is a surgical procedure to deliver a baby.',
        },
        {
          'id': 'fistula',
          'name': 'Fitsula',
          'highlighted': true,
          'description':
              'Fistula surgery treats abnormal connections between organs.',
        },
        {
          'id': 'lasik-eye',
          'name': 'LASIK Eye',
          'highlighted': true,
          'description':
              'Uses a laser to fix vision issues like nearsightedness.',
        },
        {
          'id': 'liposuction',
          'name': 'Liposuction',
          'highlighted': true,
          'description':
              'Liposuction removes excess fat deposits from selected areas.',
        },
        {
          'id': 'cataract-surgery',
          'name': 'Cataract Surgery',
          'highlighted': true,
          'description': 'Cataract surgery replaces the cloudy eye lens.',
        },
        {
          'id': 'stent-procedure',
          'name': 'Stent Procedure',
          'highlighted': true,
          'description': 'Stent procedure opens blocked blood vessels.',
        },
        {
          'id': 'gallbladder-removal',
          'name': 'Gallbladder Removal',
          'highlighted': true,
          'description':
              'Gallbladder removal treats stones or inflammation.',
        },
        {
          'id': 'breast-surgery',
          'name': 'Breast Surgery',
          'highlighted': true,
          'description':
              'Breast surgery includes therapeutic and corrective procedures.',
        },
      ],
    };
  }
}
