import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class ResultsFilterButton extends StatelessWidget {
  const ResultsFilterButton({
    super.key,
    required this.textTheme,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final TextTheme textTheme;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11.r),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive
                  ? ConsultationUiConfig.ctaColor
                  : const Color(0xFFD9DEE4),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(11.r),
            color: isActive ? const Color(0xFFEFFCF9) : Colors.white,
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    ConsultationUiConfig.filterIconAsset,
                    width: 16.w,
                    height: 16.h,
                    fit: BoxFit.contain,
                  ),
                  if (isActive)
                    Positioned(
                      top: -2.h,
                      right: -2.w,
                      child: Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
