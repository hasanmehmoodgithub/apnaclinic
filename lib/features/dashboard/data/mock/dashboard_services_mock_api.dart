import '../../../../core/config/mock_config.dart';

class DashboardServicesMockApi {
  /// Toggle mock responses for dashboard services API.
  static bool useMockResponses = MockConfig.enableMocks;

  Future<Map<String, dynamic>> getDashboardServicesSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return {
      'success': true,
      'message': 'Services fetched successfully',
      'services': [
        {
          'title': 'Online Consultation',
          'subtitle': 'PMDC certified doctors',
          'offerUpto': 'Up to 20% off',
          'thumb': 'assets/img/services/online_consultation.webp',
          'route': 'consultation',
          'visibility': true,
        },
        {
          'title': 'Pharmacy',
          'subtitle': 'Authentic medicines at your doorstep',
          'offerUpto': 'Up to 10% off',
          'thumb': 'assets/img/services/pharmacy.webp',
          'route': 'pharmacyMain',
          'visibility': true,
        },
        {
          'title': 'Laboratory Testing',
          'subtitle': 'Reliable lab tests with accurate results',
          'offerUpto': 'Up to 40% off',
          'thumb': 'assets/img/services/laboratory.webp',
          'route': 'labTest',
          'visibility': true,
        },
        {
          'title': 'Surgery Booking',
          'subtitle': 'Hassle-free surgery scheduling',
          'offerUpto': 'Up to 40% off',
          'thumb': 'assets/img/services/surgery_booking.webp',
          'route': 'surgery',
          'visibility': true,
        },
      ],
    };
  }
}

