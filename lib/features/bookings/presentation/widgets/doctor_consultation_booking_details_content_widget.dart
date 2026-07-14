import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../data/mappers/doctor_consultation_booking_mapper.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import 'doctor_consultation_booking_feedback_form_widget.dart';
import 'doctor_consultation_booking_status_pill_widget.dart';

class DoctorConsultationBookingDetailsContentWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsContentWidget({
    super.key,
    required this.data,
  });

  final DoctorConsultationBookingDetailsModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final statusDisplayText = switch (data.status) {
      DoctorConsultationBookingStatus.pending => 'Pending',
      DoctorConsultationBookingStatus.confirmed => 'Confirmed',
      DoctorConsultationBookingStatus.cancel => 'Cancel',
      DoctorConsultationBookingStatus.completed => 'Completed',
    };
    final showJoinButton = data.status == DoctorConsultationBookingStatus.pending ||
        data.status == DoctorConsultationBookingStatus.confirmed;

    return Column(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: CachedNetworkImage(
              imageUrl: data.doctorImageUrl,
              width: 188.w,
              height: 160.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
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
                            Text(
                              data.doctorName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleLarge?.copyWith(
                                fontSize: 58.sp / 2,
                                color: const Color(0xFF061E40),
                                fontWeight: FontWeight.w500,
                                height: 1.05,
                              ),
                            ),
                            Text(
                              data.specialty,
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF3C4A58),
                                fontSize: 48.sp / 2,
                                height: 1.12,
                              ),
                            ),
                            Text(
                              data.qualification,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF60789A),
                                fontSize: 28.sp / 2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Divider(
                              color: const Color(0xFFAEB8C1),
                              thickness: 0.7,
                              height: 1.h,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              '${l10n.bookingsStatusLabel}:',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 20.sp / 2,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            DoctorConsultationBookingStatusPillWidget(
                              status: data.status,
                              label: statusDisplayText,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: 120.w,
                        padding: EdgeInsets.fromLTRB(12.w, 6.h, 5.w, 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F9FC),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 2.h,
                              right: 2.w,
                              child: IgnorePointer(
                                child: SvgPicture.asset(
                                  'assets/img/consultation/time_date_asset.svg',
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
                                    fontSize: 15.sp ,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4C5E76),
                                  ),
                                ),
                                Text(
                                  data.appointmentDay,
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: const Color(0xFF4D627F),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 56.sp / 2,
                                  ),
                                ),
                                Text(
                                  data.appointmentWeekday,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF4C5E76),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Divider(color: const Color(0xFFC8DAE1), height: 1.h),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size:20,
                                      color: Color(0xFF4D627F),
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        data.appointmentTime,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: const Color(0xFF4D627F),
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
                      ),
                    ],
                  ),
                  // SizedBox(height: 10.h),
                  SizedBox(height: 12.h),
                  _inputLike(textTheme, l10n.bookingsPatientLabel, data.patientValue),
                  SizedBox(height: 4.h),
                  _inputLike(textTheme, l10n.bookingsIssueLabel, data.issueValue),
                  if (data.patientReview != null) ...[
                    SizedBox(height: 14.h),
                    _PatientReviewSection(
                      textTheme: textTheme,
                      l10n: l10n,
                      review: data.patientReview!,
                    ),
                  ] else if (data.status !=
                      DoctorConsultationBookingStatus.cancel) ...[
                    SizedBox(height: 14.h),
                    const DoctorConsultationBookingFeedbackFormWidget(),
                  ],
                  if (data.attachments.isNotEmpty) ...[
                    SizedBox(height: 14.h),
                    _DocumentsSection(
                      textTheme: textTheme,
                      l10n: l10n,
                      attachments: data.attachments,
                    ),
                  ],
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Text(
                        l10n.bookingsBillingTitle,
                        style: textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.download_rounded,
                        color: const Color(0xFF52708E),
                        size: 17.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        l10n.bookingsEInvoiceLabel,
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF52708E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFE5E8EC)),
                    ),
                    child: Column(
                      children: [
                        _billRow(
                          textTheme,
                          l10n.bookingsConsultationFeeLabel,
                          'Rs.${data.originalFee}',
                        ),
                        _billRow(
                          textTheme,
                          l10n.bookingsDiscountLabel(
                            _percentLabel(data.discountPercent),
                          ),
                          'Rs.${data.discountAmount}',
                        ),
                        Container(
                          color: AppColors.clrF7F7F7,
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                          child: _billRow(
                            textTheme,
                            l10n.bookingsTotalLabel,
                            data.totalText,
                            isTotal: true,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  if (showJoinButton)
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: FilledButton(
                        onPressed: data.status ==
                                DoctorConsultationBookingStatus.confirmed
                            ? () {}
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1FAFA3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Text(
                          l10n.bookingsJoinNowCta,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputLike(TextTheme textTheme, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleSmall),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.clrF7F7F7,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(color: const Color(0xFF7A8798)),
          ),
        ),
      ],
    );
  }

  Widget _billRow(
    TextTheme textTheme,
    String label,
    String value, {
    bool isTotal = false,
    bool dense = false,
  }) {
    return Padding(
      padding: dense
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: isTotal ? const Color(0xFF061E40) : const Color(0xFF707D8F),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _percentLabel(double percent) {
    if (percent <= 0) return '0';
    if (percent % 1 == 0) return percent.toInt().toString();
    return percent.toStringAsFixed(1);
  }
}

class _PatientReviewSection extends StatelessWidget {
  const _PatientReviewSection({
    required this.textTheme,
    required this.l10n,
    required this.review,
  });

  final TextTheme textTheme;
  final AppLocalizations l10n;
  final DoctorConsultationBookingPatientReview review;

  @override
  Widget build(BuildContext context) {
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
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bookingsYourFeedbackLabel,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            if (review.dateLabel.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                review.dateLabel,
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF98A2B3),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
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
                      ? const Color(0xFFF5B301)
                      : const Color(0xFFD0D5DD),
                ),
              ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFF98E089)),
              ),
              child: Text(
                '$ratingLabel / 5',
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF667B99),
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
                color: const Color(0xFF667085),
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

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({
    required this.textTheme,
    required this.l10n,
    required this.attachments,
  });

  final TextTheme textTheme;
  final AppLocalizations l10n;
  final List<String> attachments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingsDocumentsTitle,
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE5E8EC)),
          ),
          child: Column(
            children: [
              for (var i = 0; i < attachments.length; i++) ...[
                if (i > 0) const Divider(height: 1, color: Color(0xFFE5E8EC)),
                InkWell(
                  onTap: () => AppUrlLauncher.open(
                    url: attachments[i],
                    lunchMode: LaunchMode.externalApplication,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 20.r,
                          color: const Color(0xFF52708E),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            DoctorConsultationBookingMapper.attachmentDisplayName(
                              attachments[i],
                              i,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF061E40),
                            ),
                          ),
                        ),
                        Text(
                          l10n.bookingsDownloadCta,
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF2F80ED),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
