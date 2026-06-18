import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';
import 'service_card_image.dart';
import 'service_discount_badge.dart';

/// Home grid service tile — Figma 195×122 card, 63×72 icon.
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
        width: double.infinity,
        height: DashboardUiConfig.serviceCardHeight.h,
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(
            DashboardUiConfig.serviceCardBorderRadius.r,
          ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ServiceCardImage(
                      imageUrl: imageAsset,
                      fallbackRoute: route,
                      width: DashboardUiConfig.serviceIconWidth.w,
                      height: DashboardUiConfig.serviceIconHeight.h,
                    ),
                  ),
                  SizedBox(
                    height: DashboardUiConfig.serviceCardIconTitleGap.h,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.clr09,
                      fontSize: 12.sp,
                      height: 1.2,
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
