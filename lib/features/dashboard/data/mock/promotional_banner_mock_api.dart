import '../../../../core/config/mock_config.dart';

class PromotionalBannerMockApi {
  static bool get useMockResponses => MockConfig.enableDashboardMocks;

  Future<Map<String, dynamic>> getPromotionalBannerSuccessResponse() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {
      'success': true,
      'message': 'Banners retrieved',
      'code': 200,
      'data': [
        {
          'id': 1,
          'title': 'Promo',
          'imagePath': 'assets/img/banner.png',
          'ctaUrl': 'consultation',
          'displayOrder': 1,
          'isActive': true,
        },
      ],
    };
  }
}
