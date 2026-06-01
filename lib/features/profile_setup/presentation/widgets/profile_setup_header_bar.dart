import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/di/dependency_injection.dart';

class ProfileSetupHeaderBar extends StatelessWidget {
  const ProfileSetupHeaderBar({
    super.key,
    required this.topInset,
    this.onBack,
    this.showBackButton = true,
  });

  final double topInset;
  final VoidCallback? onBack;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isProfileCompleted = sl<AppPref>().isProfileCompleted();
    final title = isProfileCompleted
        ? l10n.profileTitle
        : l10n.profileSetupHeaderTitle;
    return SizedBox(
      height: topInset + 48.h,
      child: Padding(
        padding: EdgeInsets.only(top: topInset + 4.h),
        child: Row(
          children: [
            if (showBackButton)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: onBack,
                  child: SizedBox(
                    width: 40.r,
                    height: 40.r,
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.clr060,
                        size: 22.r,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.clr060,
                  ),
                ),
              ),
            ),
            if (showBackButton) SizedBox(width: 40.w),
          ],
        ),
      ),
    );
  }
}
