import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingDetailsReviewWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsReviewWidget({
    super.key,
    required this.review,
  });

  final DoctorConsultationBookingPatientReview review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final rating = review.rating.clamp(0.0, 5.0);
    final filled = rating.floor();
    final hasHalf = (rating - filled) >= 0.5;
    final ratingLabel =
        rating % 1 == 0 ? rating.toInt().toString() : rating.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingsPatientsReviewTitle,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          l10n.bookingsYourFeedbackLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        if (review.dateLabel.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            review.dateLabel,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.clr98A2B3,
              fontSize: 12.sp,
            ),
          ),
        ],
        SizedBox(height: 10.h),
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  i <= filled
                      ? Icons.star_rounded
                      : (i == filled + 1 && hasHalf
                          ? Icons.star_half_rounded
                          : Icons.star_border_rounded),
                  size: 22.r,
                  color: i <= filled || (i == filled + 1 && hasHalf)
                      ? AppColors.clrF5B301
                      : AppColors.clrD0D5DD,
                ),
              ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.clr98E089),
              ),
              child: Text(
                '$ratingLabel / 5',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.clr667B99,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        if (review.review.trim().isNotEmpty) ...[
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.clrF7F7F7,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              review.review,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.clr667085,
                fontSize: 14.sp,
                height: 1.35,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
