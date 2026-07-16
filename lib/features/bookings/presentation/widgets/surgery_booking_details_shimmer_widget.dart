import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryBookingDetailsShimmerWidget extends StatelessWidget {
  const SurgeryBookingDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        children: [
          AppShimmerCard(height: 150.h, borderRadius: 14.r),
          SizedBox(height: 14.h),
          AppShimmerCard(height: 120.h, borderRadius: 12.r),
          SizedBox(height: 10.h),
          AppShimmerCard(height: 56.h, borderRadius: 10.r),
          SizedBox(height: 14.h),
          AppShimmerCard(height: 160.h, borderRadius: 12.r),
          SizedBox(height: 14.h),
          AppShimmerCard(height: 140.h, borderRadius: 12.r),
        ],
      ),
    );
  }
}
