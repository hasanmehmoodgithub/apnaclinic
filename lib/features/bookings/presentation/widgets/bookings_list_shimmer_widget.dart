import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Skeleton list for My Bookings tabs while data is loading.
class BookingsListShimmerWidget extends StatelessWidget {
  const BookingsListShimmerWidget({
    super.key,
    this.itemCount = 4,
    this.cardHeight,
    this.padding,
    this.separatorHeight,
  });

  final int itemCount;
  final double? cardHeight;
  final EdgeInsetsGeometry? padding;
  final double? separatorHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: separatorHeight ?? 14.h),
      itemBuilder: (_, _) => AppShimmerCard(
        height: cardHeight ?? 172.h,
        borderRadius: 16.r,
      ),
    );
  }
}
