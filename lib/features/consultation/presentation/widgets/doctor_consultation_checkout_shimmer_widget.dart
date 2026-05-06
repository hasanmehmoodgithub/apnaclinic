import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class DoctorConsultationCheckoutShimmerWidget extends StatelessWidget {
  const DoctorConsultationCheckoutShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Column(
        children: [
          AppShimmerCard(height: 190.h, borderRadius: 10.r),
          SizedBox(height: 14.h),
          AppShimmerCard(height: 84.h, borderRadius: 12.r),
          SizedBox(height: 12.h),
          AppShimmerCard(height: 84.h, borderRadius: 12.r),
        ],
      ),
    );
  }
}
