import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';

/// Rounded shimmer used while a promo banner URL or image is loading.
class PromotionalBannerShimmer extends StatelessWidget {
  const PromotionalBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = DashboardUiConfig.promotionalBannerBorderRadius.r;
    return Opacity(
      opacity: DashboardUiConfig.promotionalBannerShimmerOpacity,
      child: AspectRatio(
        aspectRatio: DashboardUiConfig.promotionalBannerPlaceholderAspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AppShimmer(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                borderRadius: radius,
                shape: ShimmerShape.roundedRectangle,
                baseColor: AppColors.clrD8D8D8,
                highlightColor: AppColors.clrWhite,
              );
            },
          ),
        ),
      ),
    );
  }
}
