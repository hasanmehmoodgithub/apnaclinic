import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryPatientDetailsShimmerViewWidget extends StatelessWidget {
  const SurgeryPatientDetailsShimmerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 20.h),
            children: [
              AppShimmerText(height: 16.h, width: 120.w),
              SizedBox(height: 14.h),
              AppShimmerCard(height: 190.h, borderRadius: 10.r),
              SizedBox(height: 20.h),
              AppShimmerCard(height: 84.h, borderRadius: 12.r),
              SizedBox(height: 14.h),
              AppShimmerCard(height: 84.h, borderRadius: 12.r),
              SizedBox(height: 14.h),
              AppShimmerCard(height: 84.h, borderRadius: 12.r),
              SizedBox(height: 14.h),
              AppShimmerCard(height: 84.h, borderRadius: 12.r),
              SizedBox(height: 14.h),
              AppShimmerText(height: 16.h, width: 72.w),
              SizedBox(height: 10.h),
              AppShimmerCard(height: 52.h, borderRadius: 10.r),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
          child: AppShimmerCard(height: 54.h, borderRadius: 10.r),
        ),
      ],
    );
  }
}
