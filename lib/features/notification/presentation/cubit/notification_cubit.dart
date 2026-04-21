import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_cases/get_notifications_use_case.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({required this.getNotificationsUseCase})
      : super(const NotificationState()) {
    loadNotifications();
  }

  final GetNotificationsUseCase getNotificationsUseCase;

  Future<void> loadNotifications({bool refresh = false}) async {
    emit(
      state.copyWith(
        loadingStateStatus: refresh ? StateStatus.refreshing : StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getNotificationsUseCase(const GetNotificationsParams());
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (data) => emit(
        state.copyWith(
          loadingStateStatus: data.isEmpty ? StateStatus.empty : StateStatus.success,
          notifications: _sortUnreadFirst(data),
          errorMessage: null,
        ),
      ),
    );
  }

  List<NotificationEntity> _sortUnreadFirst(List<NotificationEntity> source) {
    final copy = [...source];
    copy.sort((a, b) {
      if (a.isRead == b.isRead) return 0;
      return a.isRead ? 1 : -1;
    });
    return copy;
  }

  void markAsRead(String notificationId) {
    final updated = state.notifications
        .map(
          (item) => item.id == notificationId && !item.isRead
              ? item.copyWith(isRead: true)
              : item,
        )
        .toList();
    emit(state.copyWith(notifications: updated));
  }
}
