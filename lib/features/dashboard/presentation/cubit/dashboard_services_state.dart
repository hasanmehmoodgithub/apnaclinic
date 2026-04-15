import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/our_service_entity.dart';

part 'dashboard_services_state.freezed.dart';

@freezed
abstract class DashboardServicesState with _$DashboardServicesState {
  const factory DashboardServicesState({
    // Loading status
    @Default(StateStatus.idle) StateStatus ourServicesLoadingStateStatus,

    // Data
    @Default([]) List<OurServiceEntity> servicesList,
    String? servicesErrorMessage,
  }) = _DashboardServicesState;
}

