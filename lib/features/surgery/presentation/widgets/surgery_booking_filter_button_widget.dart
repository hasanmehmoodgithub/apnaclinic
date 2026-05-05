import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryBookingFilterButtonWidget extends StatelessWidget {
  const SurgeryBookingFilterButtonWidget({
    super.key,
    required this.onTap,
    required this.isActive,
  });

  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 44.5.h,
        width: 72.w,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEFFCF9) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive ? const Color(0xFF0FAA9A) : const Color(0xFF9BA6A7),
            width: 0.3,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_outlined,
              size: 14.r,
              color: const Color(0xFF667B99),
            ),
            SizedBox(width: 6.w),
            Text(
              'Filter',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF667B99),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
