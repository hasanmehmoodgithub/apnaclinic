import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

/// Empty catalog / search results for the lab test browse list.
class LabTestCatalogEmptyWidget extends StatelessWidget {
  const LabTestCatalogEmptyWidget({
    super.key,
    required this.message,
    this.showIllustration = true,
  });

  final String message;
  final bool showIllustration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIllustration) ...[
              Image.asset(
                Assets.imgEmptyBox,
                width: 120.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 14.h),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr8A97A8,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
