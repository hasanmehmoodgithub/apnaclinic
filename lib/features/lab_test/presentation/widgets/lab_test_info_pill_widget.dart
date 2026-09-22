import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Small pill used for requirement and sample type on browse cards.
class LabTestInfoPillWidget extends StatelessWidget {
  const LabTestInfoPillWidget({
    super.key,
    required this.value,
    this.highlight = false,
  });

  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: highlight ? AppColors.clrB7EAC3 : AppColors.clrWhite,
        borderRadius: BorderRadius.circular(59.r),
        border: highlight
            ? null
            : Border.all(color: AppColors.clrE7E7E7, width: 1.0),
      ),
      child: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          color: highlight ? AppColors.clr198733 : AppColors.clrA1A1A1,
          fontSize: 13.sp,
          height: 1.1,
        ),
      ),
    );
  }
}
