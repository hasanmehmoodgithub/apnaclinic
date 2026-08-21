import 'package:apnaclinic/components/widgets/action_option_card.dart';
import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/user_profile_avatar.dart';

class MenuProfileCard extends StatelessWidget {
  const MenuProfileCard({
    super.key,
    required this.isLoggedIn,
    required this.name,
    required this.phone,
    required this.onActionTap,
    this.imageUrl,
    this.imageCacheKey,
  });

  final bool isLoggedIn;
  final String name;
  final String phone;
  final String? imageUrl;
  final String? imageCacheKey;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final subtitleText = phone.trim();

    return ActionOptionCard(
      title: name,
      subtitle: subtitleText.isEmpty ? null : subtitleText,
      onTap: onActionTap,
      onTrailingTap: onActionTap,
      height: 100.h,
      curveOverlayColor: AppColors.clrEBDFFF.withValues(alpha: 0.4),
      trailingOverlayWidth: 124.w,
      contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      titleSpacing: 4,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: AppColors.clr0E2D55,
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
        height: 1.15,
      ),
      subtitleStyle: theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.clr4A4A4A,
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        height: 1.15,
      ),
      leading: UserProfileAvatar(
        key: ValueKey(imageCacheKey ?? imageUrl ?? 'menu-avatar'),
        imageUrl: imageUrl,
        cacheKey: imageCacheKey,
        size: 52,
      ),
      trailing: OutlinedButton(
        onPressed: onActionTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.clr9BA6A7,
            width: 0.8,
          ),
          foregroundColor: AppColors.clr0E2D55,
          minimumSize: Size(72.w, 24.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.5.w,
            vertical: 9.h,
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          isLoggedIn
              ? l10n.dashboardMenuEditProfile
              : l10n.dashboardMenuLoginSignup,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 9.sp,
            color: AppColors.clr0E2D55,
          ),
        ),
      ),
    );
  }
}
