import '../../../../core/config/mock_config.dart';

class DashboardServicesMockApi {
  static bool get useMockResponses => MockConfig.enableDashboardMocks;

  Future<Map<String, dynamic>> getGuestFallbackServicesResponse() async {
    return getDashboardServicesSuccessResponse();
  }

  Future<Map<String, dynamic>> getDashboardServicesSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return {
      'success': true,
      'message': 'Services retrieved',
      'code': 200,
      'data': [
        {
          'id': 1,
          'title': 'Doctor Consultation',
          'subtitle': 'PMDC certified doctors',
          'discount': '20% OFF',
          'iconPath': '',
          'deepLink': 'consultation',
          'displayOrder': 1,
          'isActive': true,
        },
        {
          'id': 2,
          'title': 'Online Pharmacy',
          'subtitle': 'Authentic medicines at your doorstep',
          'discount': '',
          'iconPath': '',
          'deepLink': 'pharmacy',
          'displayOrder': 2,
          'isActive': true,
        },
        {
          'id': 3,
          'title': 'Book Lab Test',
          'subtitle': 'Reliable lab tests with accurate results',
          'discount': '40% OFF',
          'iconPath': '',
          'deepLink': 'lab-testing',
          'displayOrder': 3,
          'isActive': true,
        },
        {
          'id': 4,
          'title': 'Book Surgery',
          'subtitle': 'Hassle-free surgery scheduling',
          'discount': '40% OFF',
          'iconPath': '',
          'deepLink': 'surgery',
          'displayOrder': 4,
          'isActive': true,
        },
      ],
    };
  }
}
