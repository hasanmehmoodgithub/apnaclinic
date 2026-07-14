import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import 'doctor_consultation_booking_details_billing_widget.dart';
import 'doctor_consultation_booking_details_documents_widget.dart';
import 'doctor_consultation_booking_details_field_widget.dart';
import 'doctor_consultation_booking_details_header_widget.dart';
import 'doctor_consultation_booking_details_join_button_widget.dart';
import 'doctor_consultation_booking_details_review_widget.dart';
import 'doctor_consultation_booking_feedback_form_widget.dart';

class DoctorConsultationBookingDetailsContentWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsContentWidget({
    super.key,
    required this.data,
  });

  final DoctorConsultationBookingDetailsModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showJoinButton =
        data.status == DoctorConsultationBookingStatus.pending ||
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
              color: AppColors.clrWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorConsultationBookingDetailsHeaderWidget(data: data),
                  SizedBox(height: 12.h),
                  DoctorConsultationBookingDetailsFieldWidget(
                    title: l10n.bookingsPatientLabel,
                    value: data.patientValue,
                  ),
                  SizedBox(height: 4.h),
                  DoctorConsultationBookingDetailsFieldWidget(
                    title: l10n.bookingsIssueLabel,
                    value: data.issueValue,
                  ),
                  if (data.patientReview != null) ...[
                    SizedBox(height: 14.h),
                    DoctorConsultationBookingDetailsReviewWidget(
                      review: data.patientReview!,
                    ),
                  ] else if (data.status !=
                      DoctorConsultationBookingStatus.cancel) ...[
                    SizedBox(height: 14.h),
                    const DoctorConsultationBookingFeedbackFormWidget(),
                  ],
                  if (data.attachments.isNotEmpty) ...[
                    SizedBox(height: 14.h),
                    DoctorConsultationBookingDetailsDocumentsWidget(
                      attachments: data.attachments,
                    ),
                  ],
                  SizedBox(height: 14.h),
                  DoctorConsultationBookingDetailsBillingWidget(data: data),
                  SizedBox(height: 28.h),
                  if (showJoinButton)
                    DoctorConsultationBookingDetailsJoinButtonWidget(
                      status: data.status,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
