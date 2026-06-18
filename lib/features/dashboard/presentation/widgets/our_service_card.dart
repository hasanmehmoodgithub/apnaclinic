import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';
import 'service_card_image.dart';
import 'service_discount_badge.dart';

/// Home grid service tile matching the dashboard 2x2 card design.
class OurServiceCardWidget extends StatelessWidget {
  const OurServiceCardWidget({
    super.key,
    required this.title,
    required this.discountLabel,
    required this.imageAsset,
    this.route,
    this.onTap,
  });

  final String title;
  final String discountLabel;
  final String imageAsset;
  final String? route;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showDiscount = formatServiceDiscountBadge(discountLabel).isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        DashboardUiConfig.serviceCardBorderRadius.r,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(
            DashboardUiConfig.serviceCardBorderRadius.r,
          ),
          border: Border.all(color: AppColors.clrE3E8EE),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                DashboardUiConfig.serviceCardTitleHorizontalPadding.w,
                DashboardUiConfig.serviceCardTopPadding.h,
                DashboardUiConfig.serviceCardTitleHorizontalPadding.w,
                DashboardUiConfig.serviceCardBottomPadding.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ServiceCardImage(
                      imageUrl: imageAsset,
                      fallbackRoute: route,
                      width: DashboardUiConfig.serviceIconWidth.w,
                      height: DashboardUiConfig.serviceIconHeight.h,
                    ),
                  ),
                  SizedBox(height: DashboardUiConfig.serviceCardIconTitleGap.h),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.clr09,
                          fontSize: 13.sp,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showDiscount)
              Positioned(
                top: DashboardUiConfig.serviceDiscountBadgeTop.h,
                right: DashboardUiConfig.serviceDiscountBadgeRight.w,
                child: ServiceDiscountBadge(label: discountLabel),
              ),
          ],
        ),
      ),
    );
  }
}
