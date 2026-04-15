import 'package:flutter/foundation.dart';

class PromotionalBannerMockApi {
  static bool useMockResponses = kDebugMode & true;

  Future<Map<String, dynamic>> getPromotionalBannerSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Promotional banner fetched successfully',
      'data': {
        'showBanner': true,
        'url': 'assets/img/banner.png',
        'route': '',
      },
    };
  }
}

