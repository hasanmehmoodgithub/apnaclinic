import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../instant_doctor/domain/entities/instant_doctor_booking_entity.dart';
import '../../../lab_test/domain/use_cases/download_lab_report_use_case.dart';
import '../../../lab_test/presentation/lab_test_route_args.dart';
import '../../data/mappers/doctor_consultation_booking_mapper.dart';
import '../bookings_analytics.dart';
import 'booking_invoice_tile_widget.dart';

class InstantDoctorBookingPrescriptionSheet extends StatelessWidget {
  const InstantDoctorBookingPrescriptionSheet({
    super.key,
    required this.booking,
  });

  final InstantDoctorBookingEntity booking;

  static const _pdfLoaderId = 'instant_doctor_prescription_pdf';

  static Future<void> show(
    BuildContext context, {
    required InstantDoctorBookingEntity booking,
  }) {
    BookingsAnalytics.logInstantDocBookingOpened(
      bookingId: booking.orderId,
      partnerName: booking.partnerName,
    );
    BookingsAnalytics.logBookingViewed(AnalyticsBookingTypeKeys.instantDoctor);
    if (booking.hasPrescription) {
      BookingsAnalytics.logInstantDocPrescriptionView(
        bookingId: booking.orderId,
        partnerName: booking.partnerName,
      );
    }
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InstantDoctorBookingPrescriptionSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.85;
    final lines = booking.prescriptionLines;
    final showPdf = booking.hasPrescriptionUrl;

    return SizedBox(
      height: sheetHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            child: Column(
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (lines.isNotEmpty)
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: showPdf ? 0 : sheetHeight * 0.7,
                            ),
                            padding: EdgeInsets.all(16.w),
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
                        if (showPdf) ...[
                          if (lines.isNotEmpty) SizedBox(height: 12.h),
                          BookingInvoiceTileWidget(
                            fileName:
                                DoctorConsultationBookingMapper.prescriptionDisplayName(
                                  booking.prescriptionUrl,
                                  0,
                                ),
                            onDownload: () => _openPrescriptionPdf(context),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openPrescriptionPdf(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final url = booking.prescriptionUrl.trim();
    if (url.isEmpty) return;

    BookingsAnalytics.logInstantDocPrescriptionDownload(
      bookingId: booking.orderId,
      partnerName: booking.partnerName,
    );

    showHeartLoaderDialog(context, id: _pdfLoaderId, size: 120);
    final result = await sl<DownloadLabReportUseCase>()(
      DownloadLabReportParams.fromUrl(url: url, orderId: booking.orderId),
    );
    HeartLoaderDialogController.close(_pdfLoaderId);
    if (!context.mounted) return;

    result.fold(
      (error) {
        final message = error.trim().isNotEmpty
            ? error.trim()
            : l10n.pdfViewerDownloadFailed;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      (path) {
        final router = GoRouter.of(context);
        final title = l10n.bookingsPrescriptionsTitle;
        context.pop();
        router.pushNamed(
          AppRoutes.labTestReportViewer,
          extra: LabTestReportViewerArgs(filePath: path, title: title),
        );
      },
    );
  }
}
