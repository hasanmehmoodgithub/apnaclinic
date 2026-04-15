class OurServiceModel {
  const OurServiceModel({
    required this.title,
    required this.subtitle,
    required this.offerUpto,
    required this.thumb,
    required this.route,
    required this.visibility,
  });

  final String title;
  final String subtitle;
  final String offerUpto;
  final String thumb;
  final String route;
  final bool visibility;

  factory OurServiceModel.fromJson(Map<String, dynamic> json) {
    final dynamic visibilityRaw =
        json['visibility'] ?? json['isVisible'] ?? json['visible'];

    final bool visibility = switch (visibilityRaw) {
      bool value => value,
      int value => value == 1,
      String value => value.toLowerCase() == 'true' || value == '1',
      _ => true,
    };

    return OurServiceModel(
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      offerUpto: (json['offerUpto'] ?? json['offer_upto'] ?? '').toString(),
      thumb: (json['thumb'] ?? json['thumbnail'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      visibility: visibility,
    );
  }
}

class OurServicesModel {
  const OurServicesModel({
    required this.success,
    required this.message,
    required this.services,
  });

  final bool success;
  final String message;
  final List<OurServiceModel> services;

  factory OurServicesModel.fromJson(Map<String, dynamic> json) {
    final dynamic servicesRaw = json['services'] ?? json['data'] ?? [];
    final list = (servicesRaw is List ? servicesRaw : <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(OurServiceModel.fromJson)
        .toList();

    return OurServicesModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      services: list,
    );
  }
}

