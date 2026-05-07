import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class AccountDetailsLoadingShimmerWidget extends StatelessWidget {
  const AccountDetailsLoadingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
      itemBuilder: (_, _) => AppShimmerCard(height: 96.h, borderRadius: 6.r),
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemCount: 4,
    );
  }
}
