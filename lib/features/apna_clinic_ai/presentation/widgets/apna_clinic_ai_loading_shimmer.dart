import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/apna_clinic_ai_ui_config.dart';

/// Soft teal shimmer used while the AI chat is still loading.
class ApnaClinicAiShimmerBar extends StatelessWidget {
  const ApnaClinicAiShimmerBar({
    super.key,
    this.width,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      width: width,
      height: height,
      borderRadius: radius,
      baseColor: ApnaClinicAiUiConfig.border,
      highlightColor: ApnaClinicAiUiConfig.panel,
    );
  }
}

/// Placeholder for the first assistant bubble while the session connects.
class ApnaClinicAiTopMessageShimmer extends StatelessWidget {
  const ApnaClinicAiTopMessageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApnaClinicAiShimmerBar(width: 32.r, height: 32.r, radius: 16.r),
            SizedBox(width: 8.w),
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 270.w),
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                decoration: BoxDecoration(
                  color: ApnaClinicAiUiConfig.botBubble,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: ApnaClinicAiUiConfig.border),
                  boxShadow: ApnaClinicAiUiConfig.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ApnaClinicAiShimmerBar(
                      width: 200.w,
                      height: 12.h,
                      radius: 6.r,
                    ),
                    SizedBox(height: 8.h),
                    ApnaClinicAiShimmerBar(
                      width: 150.w,
                      height: 12.h,
                      radius: 6.r,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        ApnaClinicAiShimmerBar(
                          width: 48.w,
                          height: 10.h,
                          radius: 5.r,
                        ),
                        const Spacer(),
                        ApnaClinicAiShimmerBar(
                          width: 22.r,
                          height: 22.r,
                          radius: 11.r,
                        ),
                        SizedBox(width: 8.w),
                        ApnaClinicAiShimmerBar(
                          width: 16.r,
                          height: 16.r,
                          radius: 4.r,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two starter pills, same shape as Find a doctor / Find medicines.
class ApnaClinicAiChipShimmer extends StatelessWidget {
  const ApnaClinicAiChipShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
        child: Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ApnaClinicAiShimmerBar(width: 148.w, height: 36.h, radius: 24.r),
            ApnaClinicAiShimmerBar(width: 164.w, height: 36.h, radius: 24.r),
          ],
        ),
      ),
    );
  }
}

/// Composer pill: hint line plus mic and send circles.
class ApnaClinicAiFieldShimmer extends StatelessWidget {
  const ApnaClinicAiFieldShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final action = 36.r;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 6.w, 6.h),
        decoration: BoxDecoration(
          color: ApnaClinicAiUiConfig.panel,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: ApnaClinicAiUiConfig.cta, width: 1.4),
        ),
        child: Row(
          children: [
            ApnaClinicAiShimmerBar(width: 120.w, height: 12.h, radius: 6.r),
            const Spacer(),
            ApnaClinicAiShimmerBar(
              width: action,
              height: action,
              radius: action / 2,
            ),
            SizedBox(width: 6.w),
            ApnaClinicAiShimmerBar(
              width: action,
              height: action,
              radius: action / 2,
            ),
          ],
        ),
      ),
    );
  }
}
