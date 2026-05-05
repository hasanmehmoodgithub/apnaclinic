import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryShimmerViewWidget extends StatelessWidget {
  const SurgeryShimmerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 12.h),
      children: [
        AppShimmerCard(height: 62.h, borderRadius: 6.r),
        SizedBox(height: 22.h),
        AppShimmerText(height: 14.h, width: 120.w),
        SizedBox(height: 10.h),
        AppShimmerCard(height: 44.h, borderRadius: 10.r),
        SizedBox(height: 16.h),
        AppShimmerGrid(
          itemCount: 10,
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 2.32,
          borderRadius: 10.7.r,
        ),
      ],
    );
  }
}
