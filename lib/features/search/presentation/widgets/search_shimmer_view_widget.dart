import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SearchShimmerViewWidget extends StatelessWidget {
  const SearchShimmerViewWidget({
    super.key,
    required this.showResultsStyle,
  });

  final bool showResultsStyle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 20.h),
      children: [
        AppShimmerText(height: 22.h, width: 170.w, borderRadius: 6.r),
        SizedBox(height: 12.h),
        if (!showResultsStyle) ...[
          AppShimmer(
            layout: ShimmerLayout.list,
            direction: ShimmerDirection.vertical,
            itemCount: 3,
            spacing: 14.h,
            itemBuilder: (_, _) => Row(
              children: [
                AppShimmerCircle(diameter: 24.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerText(height: 16.h, width: 110.w, borderRadius: 5.r),
                      SizedBox(height: 6.h),
                      AppShimmerText(height: 14.h, width: 160.w, borderRadius: 5.r),
                    ],
                  ),
                ),
                AppShimmerCircle(diameter: 18.r),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          AppShimmerText(height: 22.h, width: 175.w, borderRadius: 6.r),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: List.generate(
              4,
              (_) => AppShimmerCard(width: 96.w, height: 38.h, borderRadius: 100.r),
            ),
          ),
        ] else ...[
          AppShimmer(
            layout: ShimmerLayout.list,
            direction: ShimmerDirection.vertical,
            itemCount: 3,
            spacing: 14.h,
            itemBuilder: (_, _) => Column(
              children: [
                AppShimmerCard(height: 48.h, borderRadius: 12.r),
                SizedBox(height: 8.h),
                AppShimmerCard(height: 142.h, borderRadius: 16.r),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
