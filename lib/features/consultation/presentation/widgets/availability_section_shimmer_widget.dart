import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class AvailabilitySectionShimmerWidget extends StatelessWidget {
  const AvailabilitySectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 74.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (_, _) => AppShimmerCard(
              width: 56.w,
              height: 74.h,
              borderRadius: 10.r,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 30.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (_, _) => AppShimmerCard(
              width: 96.w,
              height: 30.h,
              borderRadius: 16.r,
            ),
          ),
        ),
      ],
    );
  }
}
