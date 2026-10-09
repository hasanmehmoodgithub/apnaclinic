import '../../../../core/router/app_routes.dart';

class OurServiceModel {
  const OurServiceModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.offerUpto,
    required this.thumb,
    required this.route,
    required this.visibility,
    required this.displayOrder,
  });

  final int id;
  final String title;
  final String subtitle;
  final String offerUpto;
  final String thumb;
  final String route;
  final bool visibility;
  final int displayOrder;

  static String mapDeepLinkToRoute(String deepLink) {
    final key = deepLink.trim().toLowerCase();
    return switch (key) {
      'consultation' => AppRoutes.consultation,
      'pharmacy' => AppRoutes.pharmacyMain,
      'lab-testing' => AppRoutes.labTest,
      'lab_testing' => AppRoutes.labTest,
      'labtest' => AppRoutes.labTest,
      'surgery' => AppRoutes.surgery,
      _ => deepLink.trim().replaceFirst(RegExp(r'^/'), ''),
    };
  }

  factory OurServiceModel.fromJson(Map<String, dynamic> json) {
    final dynamic visibilityRaw =
        json['visibility'] ??
        json['isVisible'] ??
        json['visible'] ??
        json['isActive'];

    final bool visibility = switch (visibilityRaw) {
      bool value => value,
      int value => value == 1,
      String value => value.toLowerCase() == 'true' || value == '1',
      _ => true,
    };

    final deepLink = (json['deepLink'] ?? json['route'] ?? '').toString();

    return OurServiceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      offerUpto:
          (json['discount'] ?? json['offerUpto'] ?? json['offer_upto'] ?? '')
              .toString(),
      thumb: (json['iconPath'] ?? json['thumb'] ?? json['thumbnail'] ?? '')
          .toString(),
      route: mapDeepLinkToRoute(deepLink),
      visibility: visibility,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class OurServicesModel {
  const OurServicesModel({
    required this.success,
    required this.message,
    required this.services,
    this.bannerUrl,
  });

  final bool success;
  final String message;
  final List<OurServiceModel> services;

  /// Pro promo artwork from the home panel. Null when the API omits it.
  final String? bannerUrl;

  factory OurServicesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final panel = data is Map<String, dynamic> ? data : null;
    final dynamic servicesRaw = panel != null
        ? (panel['services'] ?? [])
        : (data is List ? data : json['services'] ?? []);
    final list =
        (servicesRaw is List ? servicesRaw : <dynamic>[])
            .whereType<Map>()
            .map(
              (item) =>
                  OurServiceModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .where((service) => service.visibility)
            .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return OurServicesModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      services: list,
      bannerUrl: _nullableUrl(panel?['bannerUrl'] ?? panel?['banner_url']),
    );
  }

  static String? _nullableUrl(dynamic raw) {
    final value = raw?.toString().trim() ?? '';
    if (value.isEmpty || value.toLowerCase() == 'null') return null;
    return value;
  }
}
