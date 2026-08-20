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
    final pad = DashboardUiConfig.instantDoctorCardPadding;

    return Material(
      color: AppColors.clrWhite,
      borderRadius: BorderRadius.circular(
        DashboardUiConfig.instantDoctorCardBorderRadius.r,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: DashboardUiConfig.instantDoctorCardWidth.w,
          // Use width-scale so height stays 98.35 relative to Figma, not stretched by .h.
          height: DashboardUiConfig.instantDoctorCardHeight.w,
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad.w, pad.w, pad.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: (DashboardUiConfig.instantDoctorCardPaddingLeft - pad)
                          .w,
                      right: DashboardUiConfig.instantDoctorTextImageGap.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                l10n.instantDoctorTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  color: AppColors.clr09,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: DashboardUiConfig
                                  .instantDoctorTitleArrowGap.w,
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18.r,
                              color: AppColors.clr09,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: DashboardUiConfig.instantDoctorTitleBodyGap.w,
                        ),
                        Text(
                          l10n.dashboardInstantDoctorDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.clr8A8A8A,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  Assets.imgInstantDocBanner,
                  width: DashboardUiConfig.instantDoctorArtworkWidth.w,
                  height: DashboardUiConfig.instantDoctorArtworkHeight.w,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
