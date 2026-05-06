import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class DoctorConsultationBookingDetailsShimmerWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppShimmerCard(width: 188.w, height: 160.h, borderRadius: 14.r),
        SizedBox(height: 10.h),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
              child: Column(
                children: [
                  AppShimmerCard(height: 170.h, borderRadius: 10.r),
                  SizedBox(height: 12.h),
                  AppShimmerCard(height: 46.h, borderRadius: 6.r),
                  SizedBox(height: 10.h),
                  AppShimmerCard(height: 46.h, borderRadius: 6.r),
                  SizedBox(height: 14.h),
                  AppShimmerCard(height: 148.h, borderRadius: 8.r),
                  SizedBox(height: 28.h),
                  AppShimmerCard(height: 56.h, borderRadius: 16.r),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
