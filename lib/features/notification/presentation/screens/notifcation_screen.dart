import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../widgets/notification_empty_state_widget.dart';
import '../widgets/notification_error_state_widget.dart';
import '../widgets/notification_header_widget.dart';
import '../widgets/notification_list_widget.dart';
import '../widgets/notification_loading_shimmer_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffoldGradient(
      child: Column(
        children: [
          NotificationHeaderWidget(title: l10n.notificationsTitle),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.clrF4F6F8,
                borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
              ),
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return switch (state.loadingStateStatus) {
                    StateStatus.loading =>
                      const NotificationLoadingShimmerWidget(),
                    StateStatus.error => NotificationErrorStateWidget(
                      message: state.errorMessage ?? l10n.notificationsLoadError,
                      retryText: l10n.notificationsRetryCta,
                      onRetry: () =>
                          context.read<NotificationCubit>().loadNotifications(),
                    ),
                    StateStatus.empty => NotificationEmptyStateWidget(
                      title: l10n.notificationsEmptyTitle,
                    ),
                    _ => RefreshIndicator(
                      color: AppColors.clr09,
                      onRefresh: () => context
                          .read<NotificationCubit>()
                          .loadNotifications(refresh: true),
                      child: NotificationListWidget(
                        groupedItems: _groupByDate(state.notifications),
                      ),
                    ),
                  };
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<NotificationEntity>> _groupByDate(
    List<NotificationEntity> list,
  ) {
    final grouped = <String, List<NotificationEntity>>{};
    for (final item in list) {
      final date = item.dateLabel;
      grouped.putIfAbsent(date, () => <NotificationEntity>[]).add(item);
    }
    return grouped;
  }
}

typedef NotifcationScreen = NotificationScreen;
