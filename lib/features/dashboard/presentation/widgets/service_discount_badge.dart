import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';

/// Normalizes API/mock copy (e.g. `Up to 20% off`) to `20% OFF`.
String formatServiceDiscountBadge(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';

  final percentMatch =
      RegExp(r'(\d+)\s*%', caseSensitive: false).firstMatch(trimmed);
  if (percentMatch != null) {
    return '${percentMatch.group(1)}% OFF';
  }

  final upper = trimmed.toUpperCase();
  if (upper.contains('OFF')) return upper;
  return trimmed;
}

/// Pill-shaped discount tag for home service grid cards (top-right).
class ServiceDiscountBadge extends StatelessWidget {
  const ServiceDiscountBadge({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final formatted = formatServiceDiscountBadge(label);
    if (formatted.isEmpty) return const SizedBox.shrink();

    final verticalPadding =
        DashboardUiConfig.serviceDiscountBadgeVerticalPadding.h;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DashboardUiConfig.serviceDiscountBadgeHorizontalPadding.w,
        vertical: verticalPadding,
      ),
      decoration: const ShapeDecoration(
        color: AppColors.clrE0F7F6,
        shape: StadiumBorder(),
      ),
      child: Text(
        formatted,
        style: TextStyle(
          color: AppColors.clr00897B,
          fontSize: DashboardUiConfig.serviceDiscountBadgeFontSize.sp,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
      ),
    );
  }
}
