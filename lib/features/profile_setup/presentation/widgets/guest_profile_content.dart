import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class GuestProfileContent extends StatelessWidget {
  const GuestProfileContent({super.key, required this.onLoginTap});

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
          child: Container(
            height: 100.h,
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 10.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDE5EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Guest User',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF1A2A4A),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: onLoginTap,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 40.h),
                    side: const BorderSide(
                      color: Color(0xFF8C949C),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                    ),
                  ),
                  child: Text(
                    'Sign Up / Login',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF3A4557),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
