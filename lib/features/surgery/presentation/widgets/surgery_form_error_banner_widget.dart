import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryFormErrorBannerWidget extends StatelessWidget {
  const SurgeryFormErrorBannerWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8F8),
        border: Border(
          top: BorderSide(color: Color(0xFFFFEBEA)),
          bottom: BorderSide(color: Color(0xFFFFEBEA)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.r,
            color: const Color(0xFFBA2025),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFBA2025),
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
