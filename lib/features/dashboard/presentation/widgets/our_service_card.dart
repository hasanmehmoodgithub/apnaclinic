import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';
import 'service_card_image.dart';
import 'service_discount_badge.dart';

/// Home grid service tile — height follows icon + title content.
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
    final showDiscount = discountLabel.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        DashboardUiConfig.serviceCardBorderRadius.r,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(
            DashboardUiConfig.serviceCardBorderRadius.r,
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          DashboardUiConfig.serviceCardTitleHorizontalPadding.w,
          DashboardUiConfig.serviceCardTopPadding.h,
          DashboardUiConfig.serviceCardTitleHorizontalPadding.w,
          DashboardUiConfig.serviceCardBottomPadding.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDiscount)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: ServiceDiscountBadge(label: discountLabel),
                  ),
                ],
              ),
            if (showDiscount)
              SizedBox(height: DashboardUiConfig.serviceCardIconTitleGap.h),
            Center(
              child: ServiceCardImage(

                imageUrl: imageAsset,
              ),
            ),
            SizedBox(height: DashboardUiConfig.serviceCardIconTitleGap.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.clr09,
                  fontSize: DashboardUiConfig.serviceCardTitleFontSize.h,
                  height: 1,
                ),
              ),
            ),
            SizedBox(height: 2,),
          ],
        ),
      ),
    );
  }
}
