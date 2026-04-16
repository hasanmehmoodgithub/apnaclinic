import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class ProfileHeaderBar extends StatelessWidget {
  const ProfileHeaderBar({
    super.key,
    required this.showBackButton,
    required this.onBack,
  });

  final bool showBackButton;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 6.h),
      child: Row(
        children: [
          showBackButton
              ? IconButton(
                  onPressed: onBack,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF061E40),
                  ),
                )
              : SizedBox(width: 48.w),
          Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr060,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
