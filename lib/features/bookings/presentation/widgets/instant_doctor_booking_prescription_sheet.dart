import 'package:flutter/material.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../instant_doctor/domain/entities/instant_doctor_booking_entity.dart';
import '../bookings_analytics.dart';

class InstantDoctorBookingPrescriptionSheet extends StatelessWidget {
  const InstantDoctorBookingPrescriptionSheet({
    super.key,
    required this.prescription,
  });

  final String prescription;

  static Future<void> show(
    BuildContext context, {
    required InstantDoctorBookingEntity booking,
  }) {
    BookingsAnalytics.logBookingViewed(AnalyticsBookingTypeKeys.instantDoctor);
    if (booking.hasPrescription) {
      BookingsAnalytics.logPrescriptionAvailable(
        bookingId: booking.orderId,
        service: AnalyticsBookingTypeKeys.instantDoctor,
      );
    }
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InstantDoctorBookingPrescriptionSheet(
        prescription: booking.prescription,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.6;
    final lines = prescription
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.clrD0D5DD,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                l10n.bookingsPrescriptionsTitle,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.clr060,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.4,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.clrF7F7F7,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      lines.join('\n'),
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr060,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
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
