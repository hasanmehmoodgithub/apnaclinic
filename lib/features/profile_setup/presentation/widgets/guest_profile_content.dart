import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class GuestProfileContent extends StatelessWidget {
  const GuestProfileContent({super.key, required this.onLoginTap});

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    color: AppColors.clrDDE5EF,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.clr6B7280,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    l10n.profileGuestUserTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.clr1A2A4A,
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
                      color: AppColors.clr8C949C,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                    ),
                  ),
                  child: Text(
                    l10n.profileSignupLoginCta,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.clr3A4557,
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
