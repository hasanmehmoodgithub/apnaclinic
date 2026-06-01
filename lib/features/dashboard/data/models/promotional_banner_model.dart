import 'our_service_model.dart';

class PromotionalBannerModel {
  const PromotionalBannerModel({
    required this.showBanner,
    required this.url,
    required this.route,
  });

  final bool showBanner;
  final String url;
  final String route;

  factory PromotionalBannerModel.empty() {
    return const PromotionalBannerModel(
      showBanner: false,
      url: '',
      route: '',
    );
  }

  factory PromotionalBannerModel.fromJson(Map<String, dynamic> json) {
    final isActive = _toBool(json['isActive'] ?? json['is_active'], defaultValue: true);
    final imagePath = (json['imagePath'] ??
            json['image_path'] ??
            json['imageUrl'] ??
            json['image_url'] ??
            json['url'] ??
            '')
        .toString()
        .trim();
    final ctaRaw =
        (json['ctaUrl'] ?? json['cta_url'] ?? json['deepLink'] ?? json['route'] ?? '')
            .toString()
            .trim();

    final withinSchedule = _isWithinSchedule(
      startDate: json['startDate'] ?? json['start_date'],
      endDate: json['endDate'] ?? json['end_date'],
    );

    final route = _mapCtaToRoute(ctaRaw);
    final showBanner = isActive && imagePath.isNotEmpty && withinSchedule;

    return PromotionalBannerModel(
      showBanner: showBanner,
      url: imagePath,
      route: route,
    );
  }

  static String _mapCtaToRoute(String cta) {
    if (cta.isEmpty) return '';
    final lower = cta.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return cta;
    }
    return OurServiceModel.mapDeepLinkToRoute(cta);
  }

  static bool _isWithinSchedule({
    required dynamic startDate,
    required dynamic endDate,
  }) {
    final now = DateTime.now().toUtc();
    final start = _tryParseDate(startDate);
    final end = _tryParseDate(endDate);
    if (start != null && now.isBefore(start)) return false;
    if (end != null && now.isAfter(end)) return false;
    return true;
  }

  static DateTime? _tryParseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text)?.toUtc();
  }

  static bool _toBool(dynamic value, {required bool defaultValue}) {
    return switch (value) {
      bool v => v,
      int v => v == 1,
      String v =>
        v.toLowerCase() == 'true' || v == '1'
            ? true
            : v.toLowerCase() == 'false' || v == '0'
            ? false
            : defaultValue,
      _ => defaultValue,
    };
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
    final dataRaw = json['data'] ?? json['banner'] ?? json['banners'];
    final List<Map<String, dynamic>> items;
    if (dataRaw is List) {
      items = dataRaw.whereType<Map<String, dynamic>>().toList();
    } else if (dataRaw is Map<String, dynamic>) {
      items = [dataRaw];
    } else {
      items = const [];
    }

    final sortedEntries = items
        .map(
          (item) => (
            order: (item['displayOrder'] as num?)?.toInt() ?? 0,
            banner: PromotionalBannerModel.fromJson(item),
          ),
        )
        .where((entry) => entry.banner.showBanner)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    final selected = sortedEntries.isNotEmpty
        ? sortedEntries.first.banner
        : PromotionalBannerModel.empty();

    final code = json['code'];
    final success = json['success'] == true || (code is num && code.toInt() == 200);

    return PromotionalBannerResponseModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      banner: selected,
    );
  }
}
