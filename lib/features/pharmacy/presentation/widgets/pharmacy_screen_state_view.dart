import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Loading / error / empty placeholders for pharmacy lists (no extra route enums).
class PharmacyScreenStateView extends StatelessWidget {
  const PharmacyScreenStateView.loading({super.key})
    : type = PharmacyScreenStateViewKind.loading,
      message = null;

  const PharmacyScreenStateView.error({super.key, required this.message})
    : type = PharmacyScreenStateViewKind.error;

  const PharmacyScreenStateView.empty({super.key, required this.message})
    : type = PharmacyScreenStateViewKind.empty;

  final PharmacyScreenStateViewKind type;
  final String? message;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PharmacyScreenStateViewKind.loading:
        return ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            AppShimmerCard(height: 220.h, borderRadius: 20.r),
            SizedBox(height: 12.h),
            AppShimmerText(height: 18.h, width: 230.w),
            SizedBox(height: 8.h),
            AppShimmerText(height: 14.h),
            SizedBox(height: 14.h),
            AppShimmerGrid(
              itemCount: 4,
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              borderRadius: 16.r,
            ),
          ],
        );
      case PharmacyScreenStateViewKind.error:
        return Center(child: Text(message ?? '', textAlign: TextAlign.center));
      case PharmacyScreenStateViewKind.empty:
        return Center(child: Text(message ?? '', textAlign: TextAlign.center));
    }
  }
}

enum PharmacyScreenStateViewKind { loading, error, empty }
