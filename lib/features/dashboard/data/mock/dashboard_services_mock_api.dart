import '../../../../core/config/mock_config.dart';

class DashboardServicesMockApi {
  static bool useMockResponses = MockConfig.enableDashboardMocks;

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
          'title': 'Online Consultation',
          'subtitle': 'PMDC certified doctors',
          'discount': 'Up to 20% off',
          'iconPath': 'assets/img/services/online_consultation.webp',
          'deepLink': 'consultation',
          'displayOrder': 1,
          'isActive': true,
        },
        {
          'id': 2,
          'title': 'Pharmacy',
          'subtitle': 'Authentic medicines at your doorstep',
          'discount': 'Up to 10% off',
          'iconPath': 'assets/img/services/pharmacy.webp',
          'deepLink': 'pharmacy',
          'displayOrder': 2,
          'isActive': true,
        },
        {
          'id': 3,
          'title': 'Laboratory Testing',
          'subtitle': 'Reliable lab tests with accurate results',
          'discount': 'Up to 40% off',
          'iconPath': 'assets/img/services/laboratory.webp',
          'deepLink': 'lab-testing',
          'displayOrder': 3,
          'isActive': true,
        },
        {
          'id': 4,
          'title': 'Surgery Booking',
          'subtitle': 'Hassle-free surgery scheduling',
          'discount': 'Up to 40% off',
          'iconPath': 'assets/img/services/surgery_booking.webp',
          'deepLink': 'surgery',
          'displayOrder': 4,
          'isActive': true,
        },
      ],
    };
  }
}
