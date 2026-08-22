import '../../../../core/router/app_routes.dart';
import 'our_service_model.dart';

class PromotionalBannerModel {
  const PromotionalBannerModel({
    required this.showBanner,
    required this.url,
    required this.routeType,
    required this.route,
    this.tabIndex,
  });

  final bool showBanner;
  final String url;

  /// CMS `route.type`: `bottomsheet`, `screen`, `url`.
  final String routeType;

  /// Mapped in-app destination (`AppRoutes.*`) or an http(s) URL.
  final String route;

  /// Bottom-nav tab when `routeType` is `bottomsheet` (`0`–`3`).
  final int? tabIndex;

  factory PromotionalBannerModel.empty() {
    return const PromotionalBannerModel(
      showBanner: false,
      url: '',
      routeType: '',
      route: '',
    );
  }

  factory PromotionalBannerModel.fromJson(Map<String, dynamic> json) {
    final isActive = _toBool(
      json['isActive'] ?? json['is_active'],
      defaultValue: true,
    );
    final imagePath = _nonEmpty(
      json['imagePath'] ??
          json['image_path'] ??
          json['imageUrl'] ??
          json['image_url'] ??
          json['url'],
    );
    final parsedRoute = _parseRoute(json['route'] ?? json['deepLink']);
    final ctaRaw = _nonEmpty(json['ctaUrl'] ?? json['cta_url']);

    final withinSchedule = _isWithinSchedule(
      startDate: json['startDate'] ?? json['start_date'],
      endDate: json['endDate'] ?? json['end_date'],
    );

    final destination = _resolveDestination(
      routeType: parsedRoute.type,
      routeName: parsedRoute.name,
      tabIndex: parsedRoute.index,
      ctaRaw: ctaRaw,
    );
    final showBanner = isActive && imagePath.isNotEmpty && withinSchedule;

    return PromotionalBannerModel(
      showBanner: showBanner,
      url: imagePath,
      routeType: destination.type,
      route: destination.name,
      tabIndex: destination.index,
    );
  }

  /// CMS `route` is `"type/value"` split on `/`, e.g. `bottomsheet/1` or
  /// `screen/instant-doctor`. Object `{ type, Index|route }` still works.
  static ({String type, String name, int? index}) _parseRoute(dynamic raw) {
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      return (
        type: _nonEmpty(_mapValue(map, const ['type', 'routeType'])),
        name: _nonEmpty(
          _mapValue(map, const [
            'route',
            'routerName',
            'routeName',
            'name',
            'path',
            'screen',
          ]),
        ),
        index: _parseIndex(_mapValue(map, const ['index'])),
      );
    }
    if (raw is String) {
      return _parseRouteString(raw);
    }
    return (type: '', name: '', index: null);
  }

  static ({String type, String name, int? index}) _parseRouteString(
    String raw,
  ) {
    final text = raw.trim().replaceFirst(RegExp(r'^/+'), '');
    if (text.isEmpty) return (type: '', name: '', index: null);
    if (_isHttpUrl(text)) return (type: 'url', name: text, index: null);

    final slash = text.indexOf('/');
    if (slash <= 0) return (type: '', name: text, index: null);

    final type = text.substring(0, slash).trim();
    final value = text.substring(slash + 1).trim();
    return (type: type, name: value, index: _parseIndex(value));
  }

  static dynamic _mapValue(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final direct = map[key];
      if (direct != null) return direct;
    }
    final lowerKeys = {for (final key in keys) key.toLowerCase(): true};
    for (final entry in map.entries) {
      if (lowerKeys.containsKey(entry.key.toLowerCase()) &&
          entry.value != null) {
        return entry.value;
      }
    }
    return null;
  }

  static ({String type, String name, int? index}) _resolveDestination({
    required String routeType,
    required String routeName,
    required int? tabIndex,
    required String ctaRaw,
  }) {
    if (_isHttpUrl(ctaRaw)) {
      return (type: 'url', name: ctaRaw, index: null);
    }

    final type = _normalizeType(routeType);
    if (type == 'bottomsheet' && _isValidTabIndex(tabIndex)) {
      return (type: type, name: '', index: tabIndex);
    }
    if (routeName.isNotEmpty) {
      return (type: type, name: _mapRouterName(routeName), index: null);
    }
    if (ctaRaw.isNotEmpty) {
      return (type: '', name: _mapRouterName(ctaRaw), index: null);
    }
    return (type: '', name: '', index: null);
  }

  static String _normalizeType(String type) {
    final key = type.trim().toLowerCase().replaceAll(RegExp(r'[-_\s]'), '');
    return switch (key) {
      'bottomsheet' => 'bottomsheet',
      'screen' || 'page' || 'sheet' => 'screen',
      'tab' => 'tab',
      'url' || 'external' || 'link' => 'url',
      _ => type.trim().toLowerCase(),
    };
  }

  static String _mapRouterName(String raw) {
    if (raw.isEmpty) return '';
    if (_isHttpUrl(raw)) return raw;
    final key = _normalizeKey(raw);
    if (_isInstantDoctorRoute(key)) return AppRoutes.instantDoctor;
    return OurServiceModel.mapDeepLinkToRoute(raw);
  }

  static String _normalizeKey(String raw) {
    return raw
        .trim()
        .toLowerCase()
        .replaceFirst(RegExp(r'^/'), '')
        .replaceAll(RegExp(r'[-_\s]'), '');
  }

  static bool _isHttpUrl(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  static bool _isInstantDoctorRoute(String key) {
    return switch (key) {
      'intantdoctor' || 'instantdoctor' || 'filterbottomsheet' => true,
      _ => false,
    };
  }

  static int? _parseIndex(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static bool _isValidTabIndex(int? index) {
    return index != null && index >= 0 && index <= 3;
  }

  static String _nonEmpty(dynamic value) {
    if (value == null || value is Map || value is List) return '';
    return value.toString().trim();
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
    required this.banners,
  });

  final bool success;
  final String message;
  final List<PromotionalBannerModel> banners;

  factory PromotionalBannerResponseModel.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'] ?? json['banner'] ?? json['banners'];
    final List<Map<String, dynamic>> items;
    if (dataRaw is List) {
      items = dataRaw.whereType<Map>().map(Map<String, dynamic>.from).toList();
    } else if (dataRaw is Map) {
      items = [Map<String, dynamic>.from(dataRaw)];
    } else {
      items = const [];
    }

    final sortedEntries =
        items
            .map(
              (item) => (
                order:
                    (item['displayOrder'] as num?)?.toInt() ??
                    (item['display_order'] as num?)?.toInt() ??
                    0,
                banner: PromotionalBannerModel.fromJson(item),
              ),
            )
            .where((entry) => entry.banner.showBanner)
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    final code = json['code'];
    final success =
        json['success'] == true || (code is num && code.toInt() == 200);

    return PromotionalBannerResponseModel(
      success: success,
      message: (json['message'] ?? '').toString(),
      banners: sortedEntries.map((e) => e.banner).toList(growable: false),
    );
  }
}
