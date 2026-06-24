import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';

class InstantDoctorHomeBanner extends StatelessWidget {
  const InstantDoctorHomeBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Material(
      color: AppColors.clrWhite,
      borderRadius: BorderRadius.circular(
        DashboardUiConfig.instantDoctorCardBorderRadius.r,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            DashboardUiConfig.instantDoctorCardPaddingLeft.w,
            DashboardUiConfig.instantDoctorCardPaddingVertical.h,
            0,
            0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            l10n.instantDoctorTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              color: AppColors.clr09,
                              height: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: DashboardUiConfig.instantDoctorTitleArrowGap.w,
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20.r,
                          color: AppColors.clr09,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: DashboardUiConfig.instantDoctorTitleBodyGap.h,
                    ),
                    Text(
                      l10n.dashboardInstantDoctorDescription,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.clr8A8A8A,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: DashboardUiConfig.instantDoctorTextImageGap.w),
              Image.asset(
                Assets.imgInstantDocBanner,
                width: DashboardUiConfig.instantDoctorArtworkWidth.w,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
