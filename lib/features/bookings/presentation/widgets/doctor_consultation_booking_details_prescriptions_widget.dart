import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../../../generated/assets.dart';
import '../../data/mappers/doctor_consultation_booking_mapper.dart';
import '../bookings_analytics.dart';

/// Doctor prescriptions list (`doctorPerscriptions`) — distinct from Documents.
class DoctorConsultationBookingDetailsPrescriptionsWidget
    extends StatelessWidget {
  const DoctorConsultationBookingDetailsPrescriptionsWidget({
    super.key,
    required this.urls,
    required this.bookingId,
  });

  final List<String> urls;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingsDoctorsFeedbackTitle,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Column(
          children: [
            for (var i = 0; i < urls.length; i++) ...[
              if (i > 0) SizedBox(height: 8.h),
              _PrescriptionRow(
                url: urls[i],
                index: i,
                bookingId: bookingId,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PrescriptionRow extends StatelessWidget {
  const _PrescriptionRow({
    required this.url,
    required this.index,
    required this.bookingId,
  });

  final String url;
  final int index;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final name = DoctorConsultationBookingMapper.prescriptionDisplayName(
      url,
      index,
    );

    return Material(
      color: AppColors.clrF7F7F7,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: () {
          BookingsAnalytics.logPrescriptionDownloaded(
            bookingId: bookingId,
            service: AnalyticsBookingTypeKeys.consultancy,
          );
          AppUrlLauncher.open(
            url: url,
            lunchMode: LaunchMode.externalApplication,
          );
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Image.asset(
                DoctorConsultationBookingMapper.fileTypeIconAsset(url),
                width: 28.w,
                height: 32.h,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr024886,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Image.asset(
                Assets.consultationEInvoiceDownload,
                width: 18.w,
                height: 18.h,
                fit: BoxFit.contain,
                color: AppColors.clr061E40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
