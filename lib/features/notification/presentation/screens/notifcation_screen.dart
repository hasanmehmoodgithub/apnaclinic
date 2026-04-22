import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffoldGradient(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6.h, 14.w, 14.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF08294D),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Notifications',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF0E2D55),
                      fontWeight: FontWeight.w700,
                      fontSize: (31 / 1.6).sp,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, color: Color(0xFF08294D)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF4F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
              ),
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return switch (state.loadingStateStatus) {
                    StateStatus.loading => const _NotificationLoadingShimmer(),
                    StateStatus.error => _NotificationErrorState(
                      message:
                      state.errorMessage ?? AppStrings.notificationsLoadError,
                      onRetry: () => context.read<NotificationCubit>().loadNotifications(),
                    ),
                    StateStatus.empty => const _NotificationEmptyState(),
                    _ => RefreshIndicator(
                      color: AppColors.clr09,
                      onRefresh: () => context
                          .read<NotificationCubit>()
                          .loadNotifications(refresh: true),
                      child: _NotificationList(
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

class _NotificationLoadingShimmer extends StatelessWidget {
  const _NotificationLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(23.w, 12.h, 23.w, 8.h),
          child: AppShimmerText(
            width: 130.w,
            height: 18.h,
            borderRadius: 8.r,
          ),
        ),
        for (int i = 0; i < 4; i++)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: AppShimmerCircle(diameter: 8.r),
                ),
                SizedBox(width: 8.w),
                AppShimmerCircle(diameter: 46.r),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerText(
                        width: 180.w,
                        height: 16.h,
                        borderRadius: 6.r,
                      ),
                      SizedBox(height: 8.h),
                      AppShimmerText(
                        height: 12.h,
                        borderRadius: 6.r,
                      ),
                      SizedBox(height: 6.h),
                      AppShimmerText(
                        width: 220.w,
                        height: 12.h,
                        borderRadius: 6.r,
                      ),
                      SizedBox(height: 8.h),
                      AppShimmerText(
                        width: 65.w,
                        height: 10.h,
                        borderRadius: 6.r,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({required this.groupedItems});

  final Map<String, List<NotificationEntity>> groupedItems;

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
                color: const Color(0xFF0E2D55),
                fontWeight: FontWeight.w700,
                fontSize: (30 / 1.6).sp,
              ),
            ),
          ),
          for (int i = 0; i < entry.value.length; i++) ...[
            NotificationTile(
              item: entry.value[i],
              isLast: i == entry.value.length - 1,
              onTap: () => context.read<NotificationCubit>().markAsRead(
                entry.value[i].id,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _NotificationErrorState extends StatelessWidget {
  const _NotificationErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 30.r, color: const Color(0xFF8A97A8)),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4A5568),
              ),
            ),
            SizedBox(height: 14.h),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationEmptyState extends StatelessWidget {
  const _NotificationEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.imgEmptyBox,
            width: 120.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 14.h),
          Text(
            'No Notifications Yet!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8A97A8),
            ),
          ),
        ],
      ),
    );
  }
}

typedef NotifcationScreen = NotificationScreen;
