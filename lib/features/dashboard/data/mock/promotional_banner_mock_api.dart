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
          'title': 'Promo 1',
          'imagePath': 'assets/img/banner.png',
          'ctaUrl': 'consultation',
          'displayOrder': 1,
          'isActive': true,
        },
        {
          'id': 2,
          'title': 'Promo 2',
          'imagePath': 'assets/img/banner.png',
          'ctaUrl': 'pharmacyMain',
          'displayOrder': 2,
          'isActive': true,
        },
        {
          'id': 3,
          'title': 'Promo 3',
          'imagePath': 'assets/img/banner.png',
          'ctaUrl': 'https://apnaclinic.ecnstg.com/',
          'displayOrder': 3,
          'isActive': true,
        },
      ],
    };
  }
}
