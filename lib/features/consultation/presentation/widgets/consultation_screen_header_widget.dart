import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class ConsultationScreenHeaderWidget extends StatelessWidget {
  const ConsultationScreenHeaderWidget({
    super.key,
    required this.title,
    required this.onBackTap,
    this.trailingWidth = 48,
  });

  final String title;
  final VoidCallback onBackTap;
  final double trailingWidth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.clr060,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.clr060,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(width: trailingWidth.w),
        ],
      ),
    );
  }
}
