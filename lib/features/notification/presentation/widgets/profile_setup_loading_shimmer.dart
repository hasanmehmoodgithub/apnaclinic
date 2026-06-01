import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class ProfileSetupLoadingShimmer extends StatelessWidget {
  const ProfileSetupLoadingShimmer({super.key, this.omitTopInset = false});

  /// When true, a parent header already accounts for the status-bar inset.
  final bool omitTopInset;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: omitTopInset ? 8.h : topInset + 8.h),
          SizedBox(height: 18.h),
          AppShimmerCircle(diameter: 112.r),
          SizedBox(height: 14.h),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerText(height: 24.h, width: 170.w, borderRadius: 8.r),
                SizedBox(height: 8.h),
                AppShimmerText(height: 14.h, width: 230.w, borderRadius: 6.r),
                SizedBox(height: 20.h),
                for (int i = 0; i < 6; i++) ...[
                  AppShimmerText(height: 12.h, width: 100.w, borderRadius: 6.r),
                  SizedBox(height: 8.h),
                  AppShimmerText(height: 18.h, borderRadius: 6.r),
                  SizedBox(height: 22.h),
                ],
                SizedBox(height: 40.h),
                AppShimmerText(height: 52.h, borderRadius: 12.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
