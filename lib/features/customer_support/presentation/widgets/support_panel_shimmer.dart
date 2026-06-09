import 'package:apnaclinic/components/shimmer/app_shimmer.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class SupportPanelShimmer extends StatelessWidget {
  const SupportPanelShimmer({super.key, this.showHeader = true});

  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          AppShimmerText(height: 18.h, borderRadius: 8.r, width: 120.w),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 280.w),
          SizedBox(height: 20.h),
        ],
        AppShimmerText(height: 84.h, borderRadius: 4.r),
      ],
    );
  }
}
