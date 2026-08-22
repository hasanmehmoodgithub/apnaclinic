import 'package:equatable/equatable.dart';

class PromotionalBannerEntity extends Equatable {
  const PromotionalBannerEntity({
    required this.showBanner,
    required this.url,
    this.routeType = '',
    required this.route,
    this.tabIndex,
  });

  final bool showBanner;
  final String url;
  final String routeType;
  final String route;
  final int? tabIndex;

  @override
  List<Object?> get props => [showBanner, url, routeType, route, tabIndex];
}
