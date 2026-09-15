import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import 'lab_test_booking_vendor_grid_widget.dart';

/// Skeleton matching [LabTestBookingVendorGridWidget] (3-column logo + name).
class LabTestLabsGridShimmerWidget extends StatelessWidget {
  const LabTestLabsGridShimmerWidget({super.key});

  static const _itemCount = 6;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      physics: const NeverScrollableScrollPhysics(),
      child: AppShimmer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const spacing = LabTestBookingVendorGridWidget.spacing;
            final w = LabTestBookingVendorGridWidget.tileWidth(
              constraints.maxWidth,
            );
            final radius = LabTestBookingVendorGridWidget.tileRadius.r;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.start,
              children: List.generate(
                _itemCount,
                (_) => SizedBox(
                  width: w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: w,
                        height: w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(radius),
                        ),
                      ),
                      SizedBox(height: 9.h),
                      Container(
                        width: w * 0.72,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
