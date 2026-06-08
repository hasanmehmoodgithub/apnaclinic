import '../../../../core/config/mock_config.dart';

class SurgeryMockApi {
  static bool useMockResponses = MockConfig.enableSurgeryMocks;

  Future<Map<String, dynamic>> getSurgeryContentSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Surgeries retrieved',
      'code': 200,
      'data': [
        {
          'id': 1,
          'name': 'ACL',
          'slug': 'acl',
          'image': 'https://placehold.co/400x300/2563eb/ffffff?text=ACL',
          'description':
              'Anterior cruciate ligament (ACL) is in the middle of the knee. It prevents the shin bone from sliding out in front of the thigh bone.',
          'displayOrder': 1,
          'isActive': true,
        },
        {
          'id': 2,
          'name': 'Cataract Eye',
          'slug': 'cataract-eye',
          'image': 'https://placehold.co/400x300/2563eb/ffffff?text=Cataract',
          'description':
              'Cataract surgery removes the cloudy lens and improves vision.',
          'displayOrder': 2,
          'isActive': true,
        },
        {
          'id': 3,
          'name': 'C-Section',
          'slug': 'c-section',
          'image': 'https://placehold.co/400x300/2563eb/ffffff?text=C-Section',
          'description': 'C-section is a surgical procedure to deliver a baby.',
          'displayOrder': 3,
          'isActive': true,
        },
        {
          'id': 4,
          'name': 'Gallbladder Removal',
          'slug': 'gallbladder-removal',
          'image':
              'https://placehold.co/400x300/2563eb/ffffff?text=Gallbladder',
          'description': 'Surgical removal of the gallbladder.',
          'displayOrder': 4,
          'isActive': true,
        },
        {
          'id': 5,
          'name': 'LASIK Eye Surgery',
          'slug': 'lasik-eye-surgery',
          'image': 'https://placehold.co/400x300/2563eb/ffffff?text=LASIK',
          'description': 'Laser vision correction surgery.',
          'displayOrder': 5,
          'isActive': true,
        },
        {
          'id': 6,
          'name': 'Knee Replacement',
          'slug': 'knee-replacement',
          'image':
              'https://placehold.co/400x300/2563eb/ffffff?text=Knee+Replacement',
          'description':
              'Replacing worn knee joint surfaces with artificial parts.',
          'displayOrder': 6,
          'isActive': true,
        },
      ],
    };
  }
}
