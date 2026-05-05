import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class NotificationLoadingShimmerWidget extends StatelessWidget {
  const NotificationLoadingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(23.w, 12.h, 23.w, 8.h),
          child: AppShimmerText(
            width: 130.w,
            height: 18.h,
            borderRadius: 8.r,
          ),
        ),
        for (int i = 0; i < 4; i++)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: AppShimmerCircle(diameter: 8.r),
                ),
                SizedBox(width: 8.w),
                AppShimmerCircle(diameter: 46.r),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerText(
                        width: 180.w,
                        height: 16.h,
                        borderRadius: 6.r,
                      ),
                      SizedBox(height: 8.h),
                      AppShimmerText(
                        height: 12.h,
                        borderRadius: 6.r,
                      ),
                      SizedBox(height: 6.h),
                      AppShimmerText(
                        width: 220.w,
                        height: 12.h,
                        borderRadius: 6.r,
                      ),
                      SizedBox(height: 8.h),
                      AppShimmerText(
                        width: 65.w,
                        height: 10.h,
                        borderRadius: 6.r,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
