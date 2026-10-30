import 'package:equatable/equatable.dart';

import 'our_service_entity.dart';

/// Home CMS panel: service tiles plus the Pro promo banner.
class HomePanelEntity extends Equatable {
  const HomePanelEntity({
    required this.services,
    this.bannerUrl,
    this.aiEnabled = false,
  });

  final List<OurServiceEntity> services;
  final String? bannerUrl;

  /// `data.aiEnabled` from the home API.
  final bool aiEnabled;

  @override
  List<Object?> get props => [services, bannerUrl, aiEnabled];
}
