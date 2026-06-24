import 'package:apnaclinic/components/shimmer/app_shimmer.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../cubit/free_doctor_state.dart';

class FreeDoctorConsultationInfoCardWidget extends StatelessWidget {
  const FreeDoctorConsultationInfoCardWidget({
    super.key,
    required this.state,
    required this.defaultTitle,
    required this.defaultPoints,
  });

  final FreeDoctorState state;
  final String defaultTitle;
  final List<String> defaultPoints;

  static const String _watermarkAsset = Assets.imgPartner;
  static const double _cardTopRadius = 32;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.vertical(top: Radius.circular(_cardTopRadius));
    final points = state.content?.bulletPoints ?? defaultPoints;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.clrF4F6F8,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.clrBlack.withValues(alpha: 0.07),
            blurRadius: 24.r,
            offset: Offset(0, -6.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 0.08,
                    child: Image.asset(
                      _watermarkAsset,
                      width: 260.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            if (state.loadingStateStatus == StateStatus.loading)
              const _ConsultationInfoShimmer()
            else
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(18.w, 28.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imgFreedoctorTitleIcon,
                          height: 16.h,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            defaultTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.clr0B2239,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    for (int i = 0; i < points.length; i++) ...[
                      _Bullet(
                        text: points[i],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.clr43,
                          height: 1,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (i != points.length - 1) SizedBox(height: 6.h),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationInfoShimmer extends StatelessWidget {
  const _ConsultationInfoShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmerCircle(diameter: 48.r),
              SizedBox(width: 14.w),
              Expanded(
                child: AppShimmerText(height: 20.h, borderRadius: 8.r),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 260.w),
          SizedBox(height: 18.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 240.w),
          SizedBox(height: 18.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r),
          SizedBox(height: 8.h),
          AppShimmerText(height: 14.h, borderRadius: 6.r, width: 220.w),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 7.h),
          child: Container(
            width: 5.r,
            height: 5.r,
            decoration: const BoxDecoration(
              color: AppColors.clr111827,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}
