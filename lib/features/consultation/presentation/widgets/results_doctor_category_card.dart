import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class ResultsDoctorCategoryCard extends StatelessWidget {
  const ResultsDoctorCategoryCard({
    super.key,
    required this.category,
    required this.textTheme,
    required this.onChangeTap,
  });

  final String category;
  final TextTheme textTheme;
  final VoidCallback onChangeTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 62.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9DEE4), width: 1),
        borderRadius: BorderRadius.circular(11.r),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Doctor’s Category',
                style: textTheme.bodySmall?.copyWith(
                  color: ConsultationUiConfig.tertiaryText,
                  fontSize: 12.sp,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF1A2533),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: onChangeTap,
            iconAlignment: IconAlignment.end,
            style: TextButton.styleFrom(
              foregroundColor: ConsultationUiConfig.tertiaryText,
              padding: EdgeInsets.zero,
              minimumSize: Size(10.w, 10.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: Text(
              'Change',
              style: textTheme.bodySmall?.copyWith(
                color: ConsultationUiConfig.tertiaryText,
                fontSize: 12.sp,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.w,
              color: ConsultationUiConfig.tertiaryText,
            ),
          ),
        ],
      ),
    );
  }
}
