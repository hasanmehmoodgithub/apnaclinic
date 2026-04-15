import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/promotional_banner_entity.dart';
import '../../domain/entities/our_service_entity.dart';

part 'dashboard_services_state.freezed.dart';

@freezed
abstract class DashboardServicesState with _$DashboardServicesState {
  const factory DashboardServicesState({
    // Loading status
    @Default(StateStatus.idle) StateStatus ourServicesLoadingStateStatus,
    @Default(StateStatus.idle) StateStatus promotionalBannerLoadingStateStatus,

    // Data
    @Default([]) List<OurServiceEntity> servicesList,
    String? servicesErrorMessage,
    PromotionalBannerEntity? promotionalBanner,
    String? promotionalBannerErrorMessage,
  }) = _DashboardServicesState;
}

