import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_cases/get_notifications_use_case.dart';
import '../../domain/use_cases/mark_notification_read_use_case.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  }) : super(const NotificationState());

  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  Future<void> loadNotifications({bool refresh = false}) async {
    if (!AuthGuard.isLoggedIn()) {
      emit(const NotificationState());
      return;
    }

    emit(
      state.copyWith(
        loadingStateStatus:
            refresh ? StateStatus.refreshing : StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getNotificationsUseCase(
      const GetNotificationsParams(),
    );
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
          loadingStateStatus:
              data.isEmpty ? StateStatus.empty : StateStatus.success,
          notifications: _sortUnreadFirst(data),
          errorMessage: null,
        ),
      ),
    );
  }

  /// Marks the notification read on the server, then updates local state.
  /// Returns `null` on success (or if already read), or an error message on failure.
  Future<String?> markAsRead(String notificationId) async {
    if (!AuthGuard.isLoggedIn()) return null;
    final trimmedId = notificationId.trim();
    if (trimmedId.isEmpty) return 'Missing notification id.';

    final existing = state.notifications
        .where((item) => item.id == trimmedId)
        .firstOrNull;
    if (existing?.isRead == true) return null;

    final result = await markNotificationReadUseCase(
      MarkNotificationReadParams(publicId: trimmedId),
    );
    if (isClosed) return 'Unable to update notification right now.';

    return result.fold(
      (error) => error,
      (_) {
        final updated = state.notifications
            .map(
              (item) => item.id == trimmedId && !item.isRead
                  ? item.copyWith(isRead: true)
                  : item,
            )
            .toList(growable: false);
        emit(state.copyWith(notifications: _sortUnreadFirst(updated)));
        return null;
      },
    );
  }

  List<NotificationEntity> _sortUnreadFirst(List<NotificationEntity> source) {
    final copy = [...source];
    copy.sort((a, b) {
      if (a.isRead == b.isRead) {
        final aCreated = a.createdAt;
        final bCreated = b.createdAt;
        if (aCreated != null && bCreated != null) {
          return bCreated.compareTo(aCreated);
        }
        return 0;
      }
      return a.isRead ? 1 : -1;
    });
    return copy;
  }
}
