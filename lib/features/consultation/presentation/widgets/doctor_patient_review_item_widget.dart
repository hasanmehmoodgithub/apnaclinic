import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_rounded_rating_widget.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../constants/consultation_ui_config.dart';

class DoctorPatientReviewItemWidget extends StatelessWidget {
  const DoctorPatientReviewItemWidget({
    super.key,
    required this.review,
    required this.textTheme,
    this.showBottomDivider = false,
  });

  final ConsultationPatientReviewEntity review;
  final TextTheme textTheme;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    final ratingText = AppRoundedRatingWidget.formatScore(review.rating);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 16.r,
              color: AppColors.clrFFFFDB61,
            ),
            SizedBox(width: 4.w),
            Text(
              ratingText,
              style: textTheme.titleSmall?.copyWith(
                color: ConsultationUiConfig.primaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (review.dateLabel.isNotEmpty) ...[
              SizedBox(width: 8.w),
              Text(
                review.dateLabel,
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF8A97A8),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            const Spacer(),
            AppRoundedRatingWidget(
              rating: review.rating,
              maxRating: review.maxRating > 0 ? review.maxRating : 5,
              textTheme: textTheme,
              width: 64.w,
              height: 28.h,
            ),
          ],
        ),
        if (review.comment.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Text(
            review.comment,
            style: textTheme.bodyMedium?.copyWith(
              color: ConsultationUiConfig.primaryText,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (review.patientName.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            review.patientName,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF8A97A8),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        if (showBottomDivider) ...[
          SizedBox(height: 12.h),
          const Divider(color: Color(0xFFE4E8ED), thickness: 1, height: 1),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}
