import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class AiScreeningShimmerWidget extends StatelessWidget {
  const AiScreeningShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.clrWhite,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmerText(width: 160.w, height: 20.h, borderRadius: 6.r),
            SizedBox(height: 10.h),
            AppShimmerText(height: 14.h, borderRadius: 6.r),
            SizedBox(height: 6.h),
            AppShimmerText(width: 220.w, height: 14.h, borderRadius: 6.r),
            SizedBox(height: 18.h),
            AppShimmerCard(height: 180.h, borderRadius: 12.r),
            SizedBox(height: 14.h),
            AppShimmerCard(height: 56.h, borderRadius: 12.r),
            SizedBox(height: 12.h),
            AppShimmerCard(height: 120.h, borderRadius: 12.r),
            SizedBox(height: 12.h),
            AppShimmerCard(height: 120.h, borderRadius: 12.r),
            SizedBox(height: 12.h),
            AppShimmerCard(height: 80.h, borderRadius: 12.r),
          ],
        ),
      ),
    );
  }
}
