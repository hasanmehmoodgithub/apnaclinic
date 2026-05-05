import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class NotificationEmptyStateWidget extends StatelessWidget {
  const NotificationEmptyStateWidget({
    super.key,
    required this.title,
  });

  final String title;

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
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr8A97A8,
            ),
          ),
        ],
      ),
    );
  }
}
