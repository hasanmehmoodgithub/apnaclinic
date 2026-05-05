import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryBookingLocationRowWidget extends StatelessWidget {
  const SurgeryBookingLocationRowWidget({
    super.key,
    required this.city,
    required this.onChangeTap,
  });

  final String city;
  final VoidCallback onChangeTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  city,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF110844),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onChangeTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              child: Row(
                children: [
                  Text(
                    'Change',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14.r,
                    color: const Color(0xFF667B99),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
