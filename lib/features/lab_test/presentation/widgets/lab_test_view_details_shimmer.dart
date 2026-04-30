import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';

class LabTestViewDetailsShimmer extends StatelessWidget {
  const LabTestViewDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldGradient(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 18.h),
            child: Row(
              children: [
                AppShimmerCircle(diameter: 30.r),
                Expanded(
                  child: Center(
                    child: AppShimmerText(
                      width: 84.w,
                      height: 22.h,
                      borderRadius: 8.r,
                    ),
                  ),
                ),
                SizedBox(width: 30.w),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerText(width: 90.w, height: 18.h, borderRadius: 6.r),
                    SizedBox(height: 10.h),
                    AppShimmerCard(height: 146.h, borderRadius: 12.r),
                    SizedBox(height: 18.h),
                    AppShimmerText(width: 90.w, height: 18.h, borderRadius: 6.r),
                    SizedBox(height: 10.h),
                    AppShimmerCard(height: 190.h, borderRadius: 12.r),
                    SizedBox(height: 16.h),
                    AppShimmerCard(height: 58.h, borderRadius: 10.r),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
