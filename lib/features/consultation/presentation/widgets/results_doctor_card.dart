import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../constants/consultation_ui_config.dart';
import '../doctor_consultation_book_doctor_args.dart';
import 'rating_progress_badge.dart';
import 'results_doctor_item.dart';
import 'results_doctor_thumb.dart';
import 'results_partner_badge.dart';

class ResultsDoctorCard extends StatelessWidget {
  const ResultsDoctorCard({
    super.key,
    required this.doctor,
    required this.textTheme,
  });

  final ResultsDoctorItem doctor;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14565C67),
            blurRadius: 8,
            spreadRadius: 0.6,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              width: 74.w,
              height: 84.h,
              child: ResultsDoctorThumb(imageUrl: doctor.imageUrl),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  doctor.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 15.sp,
                                    color: ConsultationUiConfig.primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 46.w,
                                height: 16.h,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: 72.w,
                                    height: 30.h,
                                    child: RatingProgressBadge(
                                      rating: double.tryParse(
                                            doctor.rating.split('/').first.trim(),
                                          ) ??
                                          0,
                                      maxRating: 5,
                                      textTheme: textTheme,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            doctor.specialty,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              color: ConsultationUiConfig.tertiaryText,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${doctor.experience} | ${doctor.qualification}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: ConsultationUiConfig.tertiaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    ResultsPartnerBadge(partner: doctor.partner, textTheme: textTheme),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fee',
                            style: textTheme.bodySmall?.copyWith(
                              color: ConsultationUiConfig.tertiaryText,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            doctor.fee,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              height: 1,
                              color: const Color(0xFF1A2533),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            doctor.oldFee,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF979797),
                              fontSize: 14.sp,
                              decoration: TextDecoration.lineThrough,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      height: 40.h,
                      width: 114.w,
                      child: ElevatedButton(
                        onPressed: () => context.pushNamed(
                          AppRoutes.consultationBookDoctor,
                          extra: DoctorConsultationBookDoctorArgs(doctor: doctor),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ConsultationUiConfig.ctaColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                        ),
                        child: Text(
                          'Book Now',
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
