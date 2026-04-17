import 'package:flutter/foundation.dart';

class DashboardServicesMockApi {
  /// Toggle mock responses for dashboard services API.
  static bool useMockResponses = kDebugMode & true;

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
          'thumb': 'assets/img/services/online_consultation.png',
          'route': 'consultation',
          'visibility': true,
        },
        {
          'title': 'Pharmacy',
          'subtitle': 'Authentic medicines at your doorstep',
          'offerUpto': 'Up to 10% off',
          'thumb': 'assets/img/services/pharmacy.png',
          'route': 'pharmacy',
          'visibility': true,
        },
        {
          'title': 'Laboratory Testing',
          'subtitle': 'Reliable lab tests with accurate results',
          'offerUpto': 'Up to 40% off',
          'thumb': 'assets/img/services/laboratory.png',
          'route': '',
          'visibility': true,
        },
        {
          'title': 'Surgery Booking',
          'subtitle': 'Hassle-free surgery scheduling',
          'offerUpto': 'Up to 40% off',
          'thumb': 'assets/img/services/surgery_booking.png',
          'route': 'surgery',
          'visibility': true,
        },
      ],
    };
  }
}

