import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class NotificationErrorStateWidget extends StatelessWidget {
  const NotificationErrorStateWidget({
    super.key,
    required this.message,
    required this.retryText,
    required this.onRetry,
  });

  final String message;
  final String retryText;
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
            Icon(
              Icons.error_outline_rounded,
              size: 30.r,
              color: AppColors.clr8A97A8,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr4A5568,
              ),
            ),
            SizedBox(height: 14.h),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(retryText),
            ),
          ],
        ),
      ),
    );
  }
}
