import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class ProfileUserHeaderWidget extends StatelessWidget {
  const ProfileUserHeaderWidget({
    super.key,
    required this.fullName,
    required this.phone,
    required this.onEditTap,
  });

  final String fullName;
  final String phone;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final displayName =
        fullName.isEmpty ? l10n.profileGuestUserTitle : fullName;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w500,
                  fontSize: 24.sp,
                  height: 1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                phone.isEmpty ? '--' : phone,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr4A4A4A,
                  fontSize: 16.sp,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onEditTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.svgEditRounded,
                  width: 22.r,
                  height: 22.r,
                ),
                SizedBox(width: 6.w),
                Text(
                  l10n.profileEditCta,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontSize: 15.sp,
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
