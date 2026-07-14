import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../constants/consultation_ui_config.dart';
import 'doctor_patient_review_item_widget.dart';
import 'doctor_patient_reviews_feedback_sheet_widget.dart';

class DoctorPatientReviewsSection extends StatelessWidget {
  const DoctorPatientReviewsSection({
    super.key,
    required this.patientReviews,
    required this.textTheme,
    this.previewCount = 1,
  });

  final ConsultationPatientReviewsEntity patientReviews;
  final TextTheme textTheme;
  final int previewCount;

  @override
  Widget build(BuildContext context) {
    if (!patientReviews.hasReviews) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final reviews = patientReviews.reviews;
    final preview = reviews.take(previewCount).toList(growable: false);
    final total =
        patientReviews.totalCount > 0 ? patientReviews.totalCount : reviews.length;
    final canSeeMore = reviews.length > previewCount || total > previewCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              '($total)',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF8A97A8),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        const Divider(color: Color(0xFFE4E8ED), thickness: 1, height: 1),
        SizedBox(height: 12.h),
        ...preview.map(
          (review) => DoctorPatientReviewItemWidget(
            review: review,
            textTheme: textTheme,
          ),
        ),
        if (canSeeMore) ...[
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton(
              onPressed: () => DoctorPatientReviewsFeedbackSheetWidget.show(
                context,
                reviews: reviews,
                totalCount: total,
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD0D5DD)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                l10n.consultationSeeMoreReviews,
                style: textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF5F6C7C),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
