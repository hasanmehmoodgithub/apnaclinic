import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Section title + mint card promoting FikrFree (insurance / health).
class FikrfreeHealthBanner extends StatelessWidget {
  const FikrfreeHealthBanner({super.key, this.onTap});

  final VoidCallback? onTap;



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardSecureHealthTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: AppColors.clr111827,
          ),
        ),
        SizedBox(height: 12.h),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Material(
            color: AppColors.clrEAF6F1,
            borderRadius: BorderRadius.circular(16.r),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FikrFree',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              color: AppColors.clr09,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            l10n.dashboardFikrfreeTagline,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.clr43,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 76.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.clr0D9488,
                            size: 22.r,
                          ),
                          SizedBox(height: 12.h),
                          Image.asset(
                            Assets.imgFikarFree,
                            height: 51.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
