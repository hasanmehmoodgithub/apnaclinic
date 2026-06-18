import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

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

/// Light-teal discount tag for home service grid cards (top-right).
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.clrB8EDE5,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        formatted,
        style: TextStyle(
          color: AppColors.clr40AFA2,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          height: 1.0,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
