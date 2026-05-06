import '../../../../core/config/mock_config.dart';

class PromotionalBannerMockApi {
  static bool useMockResponses = MockConfig.enableMocks;

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

