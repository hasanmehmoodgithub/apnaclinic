import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

/// Promotional pharmacy artwork card shown above the scan picker.
class PharmacyScanBannerCard extends StatelessWidget {
  const PharmacyScanBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.clrE8F8F5,
            AppColors.clrF0FAFB,
            AppColors.clrWhite,
          ],
        ),
        border: Border.all(color: AppColors.clrC8EEF2),
        boxShadow: [
          BoxShadow(
            color: AppColors.clr00897B.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 11,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.clrE0F7F6,
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                      child: Text(
                        l10n.pharmacyScreenTitle,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.clr00897B,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      l10n.pharmacyScanBannerTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.clr0B2239,
                        fontWeight: FontWeight.w800,
                        fontSize: 17.sp,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      l10n.pharmacyScanBannerSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.clr4A4A4A,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10.h, 10.w, 10.h),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.clr0B2239,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.asset(
                      Assets.imgPharmacyBanner,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
