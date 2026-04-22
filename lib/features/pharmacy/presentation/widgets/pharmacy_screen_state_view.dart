import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class PharmacyScreenStateView extends StatelessWidget {
  const PharmacyScreenStateView.loading({super.key})
      : type = _PharmacyScreenStateType.loading,
        message = null;

  const PharmacyScreenStateView.error({
    super.key,
    required this.message,
  }) : type = _PharmacyScreenStateType.error;

  const PharmacyScreenStateView.empty({super.key})
      : type = _PharmacyScreenStateType.empty,
        message = null;

  final _PharmacyScreenStateType type;
  final String? message;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _PharmacyScreenStateType.loading:
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
      case _PharmacyScreenStateType.error:
        return Center(
          child: Text(
            message ?? '',
            textAlign: TextAlign.center,
          ),
        );
      case _PharmacyScreenStateType.empty:
        return const Center(child: Text('No medicine found'));
    }
  }
}

enum _PharmacyScreenStateType { loading, error, empty }
