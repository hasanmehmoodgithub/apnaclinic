import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Skeleton for the booking white panel body (below city box).
class LabTestBookingContentShimmerWidget extends StatelessWidget {
  const LabTestBookingContentShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppShimmerText(width: 160.w, height: 16.h, borderRadius: 6.r),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: AppShimmerCard(height: 72.h, borderRadius: 12.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppShimmerCard(height: 72.h, borderRadius: 12.r),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        AppShimmerCard(height: 120.h, borderRadius: 14.r),
        SizedBox(height: 16.h),
        AppShimmerCard(height: 36.h, borderRadius: 8.r),
        SizedBox(height: 12.h),
        AppShimmerGrid(
          itemCount: 6,
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 9.w,
          mainAxisSpacing: 24.h,
          borderRadius: 17.r,
        ),
      ],
    );
  }
}
