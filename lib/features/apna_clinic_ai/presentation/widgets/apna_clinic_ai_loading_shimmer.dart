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

/// Compact greeting-bubble placeholder (fixed 120) while the session connects.
class ApnaClinicAiTopMessageShimmer extends StatelessWidget {
  const ApnaClinicAiTopMessageShimmer({super.key});

  static const double height = 120;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: height,
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
                  padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                  decoration: BoxDecoration(
                    color: ApnaClinicAiUiConfig.botBubble,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: ApnaClinicAiUiConfig.border),
                    boxShadow: ApnaClinicAiUiConfig.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                      ApnaClinicAiShimmerBar(
                        width: 48.w,
                        height: 10.h,
                        radius: 5.r,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
