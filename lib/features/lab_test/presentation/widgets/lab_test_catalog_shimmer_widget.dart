import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Skeleton list while lab test catalog is loading.
class LabTestCatalogShimmerWidget extends StatelessWidget {
  const LabTestCatalogShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 10.h),
        AppShimmerCard(height: 126.h, borderRadius: 14.r),
        SizedBox(height: 14.h),
        AppShimmerCard(height: 126.h, borderRadius: 14.r),
        SizedBox(height: 14.h),
        AppShimmerCard(height: 126.h, borderRadius: 14.r),
      ],
    );
  }
}
