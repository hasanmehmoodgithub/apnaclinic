import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_state.freezed.dart';

@freezed
abstract class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    @Default([]) List<NotificationEntity> notifications,
    String? errorMessage,
  }) = _NotificationState;
}
