import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import 'doctor_consultation_booking_status_pill_widget.dart';

class DoctorConsultationBookingDetailsHeaderWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsHeaderWidget({
    super.key,
    required this.data,
  });

  final DoctorConsultationBookingDetailsModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final statusLabel = switch (data.status) {
      DoctorConsultationBookingStatus.pending => l10n.bookingsStatusPending,
      DoctorConsultationBookingStatus.confirmed => l10n.bookingsStatusConfirmed,
      DoctorConsultationBookingStatus.cancel => l10n.bookingsStatusCancel,
      DoctorConsultationBookingStatus.completed => l10n.bookingsStatusCompleted,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.doctorName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 20.sp,
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w500,
                  height: 1.05,
                ),
              ),
              Text(
                data.specialty,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr3C4A58,
                  fontSize: 16.sp,
                  height: 1.12,
                ),
              ),
              Text(
                data.qualification,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.clr60789A,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5.h),
              Divider(
                color: AppColors.clrAEB8C1,
                thickness: 0.7,
                height: 1.h,
              ),
              SizedBox(height: 6.h),
              Text(
                '${l10n.bookingsStatusLabel}:',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.clr667B99,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 4.h),
              DoctorConsultationBookingStatusPillWidget(
                status: data.status,
                label: statusLabel,
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        _AppointmentDateCard(data: data),
      ],
    );
  }
}

class _AppointmentDateCard extends StatelessWidget {
  const _AppointmentDateCard({required this.data});

  final DoctorConsultationBookingDetailsModel data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 120.w,
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 5.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.clrE9F9FC,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 2.h,
            right: 2.w,
            child: IgnorePointer(
              child: SvgPicture.asset(
                Assets.consultationTimeDateAsset,
                width: 80.w,
                height: 70.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.appointmentMonth,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.clr4C5E76,
                ),
              ),
              Text(
                data.appointmentDay,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.clr4D627F,
                  fontWeight: FontWeight.w500,
                  fontSize: 28.sp,
                ),
              ),
              Text(
                data.appointmentWeekday,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.clr4C5E76,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Divider(color: AppColors.clrC8DAE1, height: 1.h),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 20.r,
                    color: AppColors.clr4D627F,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      data.appointmentTime,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.clr4D627F,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
