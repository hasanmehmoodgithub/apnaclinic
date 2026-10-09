import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Placeholder layout while Pro details are loading.
class ProSheetShimmerWidget extends StatelessWidget {
  const ProSheetShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerHeight = MediaQuery.sizeOf(context).height / 3.5;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: AppShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _block(height: bannerHeight, radius: 0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _block(width: 180.w, height: 22.h),
                        SizedBox(height: 10.h),
                        _block(height: 14.h),
                        SizedBox(height: 6.h),
                        _block(width: 220.w, height: 14.h),
                        SizedBox(height: 20.h),
                        _block(height: 1.h, radius: 0),
                        SizedBox(height: 16.h),
                        _block(width: 90.w, height: 16.h),
                        SizedBox(height: 12.h),
                        for (var i = 0; i < 5; i++) ...[
                          _block(height: 36.h, radius: 8.r),
                          SizedBox(height: 8.h),
                        ],
                        SizedBox(height: 8.h),
                        Center(child: _block(width: 110.w, height: 16.h)),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            for (var i = 0; i < 3; i++) ...[
                              if (i > 0) SizedBox(width: 8.w),
                              Expanded(
                                child: _block(height: 72.h, radius: 12.r),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            8.h,
            20.w,
            16.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: AppShimmer(
            child: _block(height: 52.h, radius: 12.r),
          ),
        ),
      ],
    );
  }

  Widget _block({
    double? width,
    required double height,
    double? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(radius ?? 8.r),
      ),
    );
  }
}
