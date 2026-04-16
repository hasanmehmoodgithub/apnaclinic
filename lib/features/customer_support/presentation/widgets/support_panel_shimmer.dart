import 'package:apnaclinic/components/shimmer/app_shimmer.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class SupportPanelShimmer extends StatelessWidget {
  const SupportPanelShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerText(height: 18.h, borderRadius: 8.r, width: 120.w),
          SizedBox(height: 10.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 6.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 260.w),
          SizedBox(height: 24.h),
          for (int i = 0; i < 3; i++) ...[
            AppShimmerText(height: 96.h, borderRadius: 2.r),
            if (i != 2) SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }
}
