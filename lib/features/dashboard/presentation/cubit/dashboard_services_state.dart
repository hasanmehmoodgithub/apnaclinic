import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/app_update_prompt_entity.dart';
import '../../domain/entities/promotional_banner_entity.dart';
import '../../domain/entities/our_service_entity.dart';

part 'dashboard_services_state.freezed.dart';

@freezed
abstract class DashboardServicesState with _$DashboardServicesState {
  const factory DashboardServicesState({
    // Loading status
    @Default(StateStatus.idle) StateStatus ourServicesLoadingStateStatus,
    @Default(StateStatus.idle) StateStatus promotionalBannerLoadingStateStatus,
    @Default(StateStatus.idle) StateStatus appVersionLoadingStateStatus,

    /// Incremented after a successful user-profile sync so the home header can rebuild.
    @Default(0) int profileSyncNonce,

    // Data
    @Default([]) List<OurServiceEntity> servicesList,
    String? servicesErrorMessage,

    /// Pro promo image from the home panel. Empty when the API omits it.
    String? proBannerUrl,

    /// Home `data.aiEnabled`. The floating bot is shown only when this is true.
    @Default(false) bool aiEnabled,
    PromotionalBannerEntity? promotionalBanner,
    String? promotionalBannerErrorMessage,
    AppUpdatePromptEntity? appUpdatePrompt,
  }) = _DashboardServicesState;
}
