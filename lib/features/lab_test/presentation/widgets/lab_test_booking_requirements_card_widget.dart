import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Requirements card on lab booking details when fasting is required.
///
/// Same two-tone layout as the test summary card: grey header
/// (title + Fasting badge) and white body with numbered lines.
class LabTestBookingRequirementsCardWidget extends StatelessWidget {
  const LabTestBookingRequirementsCardWidget({
    super.key,
    required this.heading,
    required this.badgeLabel,
    required this.lines,
  });

  final String heading;
  final String badgeLabel;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.clrF1F1F1,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrEDEDED),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    heading,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.clr061E40,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.clrB7EAC3,
                    borderRadius: BorderRadius.circular(59.r),
                  ),
                  child: Text(
                    badgeLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.clr198733,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (lines.isNotEmpty)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.clrWhite,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(14.r),
                ),
              ),
              padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 13.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < lines.length; i++) ...[
                    if (i > 0) SizedBox(height: 8.h),
                    Text(
                      '${i + 1}. ${lines[i]}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr061E40,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
