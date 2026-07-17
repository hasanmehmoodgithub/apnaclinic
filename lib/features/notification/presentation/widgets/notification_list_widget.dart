import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_cubit.dart';
import '../notification_navigation.dart';
import 'notification_tile.dart';

class NotificationListWidget extends StatelessWidget {
  const NotificationListWidget({
    super.key,
    required this.groupedItems,
  });

  final Map<String, List<NotificationEntity>> groupedItems;

  static const _heartLoaderId = 'notification_mark_read';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
      children: [
        for (final entry in groupedItems.entries) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(23.w, 16.h, 23.w, 8.h),
            child: Text(
              entry.key,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.clr0E2D55,
                fontWeight: FontWeight.w700,
                fontSize: (30 / 1.6).sp,
              ),
            ),
          ),
          for (int i = 0; i < entry.value.length; i++) ...[
            NotificationTile(
              item: entry.value[i],
              isLast: i == entry.value.length - 1,
              onTap: () => _onNotificationTap(context, entry.value[i]),
            ),
          ],
        ],
      ],
    );
  }

  Future<void> _onNotificationTap(
    BuildContext context,
    NotificationEntity item,
  ) async {
    if (item.isRead) {
      openNotificationDeepLink(context, item);
      return;
    }

    final cubit = context.read<NotificationCubit>();

    showHeartLoaderDialog(context, id: _heartLoaderId);
    final error = await cubit.markAsRead(item.id);
    if (!context.mounted) {
      HeartLoaderDialogController.close(_heartLoaderId);
      return;
    }
    HeartLoaderDialogController.close(_heartLoaderId);

    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    openNotificationDeepLink(context, item);
  }
}
