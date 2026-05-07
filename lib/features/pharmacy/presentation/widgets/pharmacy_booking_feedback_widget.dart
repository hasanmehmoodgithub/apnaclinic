import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class PharmacyBookingFeedbackWidget extends StatelessWidget {
  const PharmacyBookingFeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pharmacyBookingFeedbackTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.clrBlack,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            l10n.pharmacyBookingFeedbackSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF78828A),
              fontSize: 14.sp,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  Icons.star_rounded,
                  size: 25.r,
                  color: index < 3 ? const Color(0xFFFFC554) : const Color(0xFFD0D5DD),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: AppColors.clrF7F7F7,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              l10n.pharmacyBookingFeedbackHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.clr4A555F,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
