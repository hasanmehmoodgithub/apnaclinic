import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';

/// Pill-shaped discount tag for home service grid cards (top-right).
/// Shows [label] as provided (no reformatting); long text wraps fully.
class ServiceDiscountBadge extends StatelessWidget {
  const ServiceDiscountBadge({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final text = label.trim();
    if (text.isEmpty) return const SizedBox.shrink();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: DashboardUiConfig.serviceDiscountBadgeMaxWidth.w,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DashboardUiConfig.serviceDiscountBadgeHorizontalPadding.w,
          vertical: DashboardUiConfig.serviceDiscountBadgeVerticalPadding.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.clrE0F7F6.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Text(
          text,
          softWrap: true,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.clr00897B,
            fontSize: DashboardUiConfig.serviceDiscountBadgeFontSize.sp,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
