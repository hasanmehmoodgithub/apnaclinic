import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryBookingShimmerViewWidget extends StatelessWidget {
  const SurgeryBookingShimmerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 16.h),
      children: [
        AppShimmerText(height: 16.h, width: 160.w),
        SizedBox(height: 12.h),
        AppShimmerCard(height: 62.h, borderRadius: 6.r),
        SizedBox(height: 12.h),
        AppShimmerText(height: 14.h, width: 120.w),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: AppShimmerCard(height: 44.h, borderRadius: 10.r),
            ),
            SizedBox(width: 8.w),
            AppShimmerCard(height: 44.h, width: 44.w, borderRadius: 10.r),
          ],
        ),
        SizedBox(height: 14.h),
        AppShimmerCard(height: 180.h, borderRadius: 16.r),
        SizedBox(height: 14.h),
        AppShimmerCard(height: 180.h, borderRadius: 16.r),
        SizedBox(height: 14.h),
        AppShimmerCard(height: 180.h, borderRadius: 16.r),
      ],
    );
  }
}
