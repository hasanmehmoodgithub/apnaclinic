import 'package:equatable/equatable.dart';

class PromotionalBannerEntity extends Equatable {
  const PromotionalBannerEntity({
    required this.showBanner,
    required this.url,
    required this.route,
  });

  final bool showBanner;
  final String url;
  final String route;

  @override
  List<Object?> get props => [showBanner, url, route];
}

