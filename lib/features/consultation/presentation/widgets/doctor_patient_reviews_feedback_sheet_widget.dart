import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../constants/consultation_ui_config.dart';
import 'doctor_patient_review_item_widget.dart';

class DoctorPatientReviewsFeedbackSheetWidget extends StatelessWidget {
  const DoctorPatientReviewsFeedbackSheetWidget({
    super.key,
    required this.reviews,
    required this.totalCount,
  });

  final List<ConsultationPatientReviewEntity> reviews;
  final int totalCount;

  static Future<void> show(
    BuildContext context, {
    required List<ConsultationPatientReviewEntity> reviews,
    required int totalCount,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DoctorPatientReviewsFeedbackSheetWidget(
        reviews: reviews,
        totalCount: totalCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;
    final displayCount = totalCount > 0 ? totalCount : reviews.length;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D5DD),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                l10n.consultationFeedbackTitle,
                style: textTheme.titleLarge?.copyWith(
                  color: ConsultationUiConfig.primaryText,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 18.r,
                    color: AppColors.clr061E40,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    l10n.consultationPatientsReviewsTitle,
                    style: textTheme.titleMedium?.copyWith(
                      color: ConsultationUiConfig.primaryText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '($displayCount)',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr0B77C5,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(color: Color(0xFFE4E8ED), thickness: 1, height: 1),
              SizedBox(height: 12.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return DoctorPatientReviewItemWidget(
                      review: reviews[index],
                      textTheme: textTheme,
                      showBottomDivider: index != reviews.length - 1,
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    l10n.consultationShowLessReviews,
                    style: textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF5F6C7C),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
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
