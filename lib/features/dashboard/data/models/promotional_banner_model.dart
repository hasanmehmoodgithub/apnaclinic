class PromotionalBannerModel {
  const PromotionalBannerModel({
    required this.showBanner,
    required this.url,
    required this.route,
  });

  final bool showBanner;
  final String url;
  final String route;

  factory PromotionalBannerModel.fromJson(Map<String, dynamic> json) {
    final dynamic showRaw =
        json['showBanner'] ?? json['show_banner'] ?? json['show'];

    final bool showBanner = switch (showRaw) {
      bool value => value,
      int value => value == 1,
      String value => value.toLowerCase() == 'true' || value == '1',
      _ => false,
    };

    return PromotionalBannerModel(
      showBanner: showBanner,
      url: (json['url'] ?? json['imageUrl'] ?? json['image_url'] ?? '')
          .toString(),
      route: (json['route'] ?? '').toString(),
    );
  }
}

class PromotionalBannerResponseModel {
  const PromotionalBannerResponseModel({
    required this.success,
    required this.message,
    required this.banner,
  });

  final bool success;
  final String message;
  final PromotionalBannerModel banner;

  factory PromotionalBannerResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic bannerRaw = json['data'] ?? json['banner'] ?? json;
    final bannerJson = bannerRaw is Map<String, dynamic>
        ? bannerRaw
        : <String, dynamic>{};

    return PromotionalBannerResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      banner: PromotionalBannerModel.fromJson(bannerJson),
    );
  }
}

