import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/consultation_ui_config.dart';
import '../../domain/entities/consultation_booking_attachment_entity.dart';
import '../../domain/entities/consultation_selected_slot_entity.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import 'availability_section.dart';
import 'doctor_profile_section.dart';
import 'documents_section.dart';
import 'issue_section.dart';
import 'patient_section.dart';

class DoctorConsultationBookingBodyWidget extends StatelessWidget {
  const DoctorConsultationBookingBodyWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
    required this.qualification,
    required this.verifiedPatientsCount,
    required this.experience,
    required this.satisfiedText,
    required this.rating,
    required this.description,
    required this.partner,
    required this.partnerLogoUrl,
    required this.textTheme,
    required this.attachments,
    required this.onBrowseTap,
    required this.onRemoveAttachment,
    required this.issueController,
    required this.onSlotChanged,
    required this.availabilityDays,
    required this.availabilityMonthLabel,
    required this.isAvailabilityLoading,
    this.availabilityErrorMessage,
  });

  final String doctorName;
  final String specialty;
  final String imageUrl;
  final String qualification;
  final String verifiedPatientsCount;
  final String experience;
  final String satisfiedText;
  final double rating;
  final String description;
  final String partner;
  final String partnerLogoUrl;
  final TextTheme textTheme;
  final List<ConsultationBookingAttachmentEntity> attachments;
  final VoidCallback onBrowseTap;
  final ValueChanged<int> onRemoveAttachment;
  final TextEditingController issueController;
  final ValueChanged<ConsultationSelectedSlotEntity?> onSlotChanged;
  final List<ConsultationAvailabilityDayEntity> availabilityDays;
  final String availabilityMonthLabel;
  final bool isAvailabilityLoading;
  final String? availabilityErrorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorProfileSection(
              doctorName: doctorName,
              specialty: specialty,
              imageUrl: imageUrl,
              qualification: qualification,
              verifiedPatientsCount: verifiedPatientsCount,
              experience: experience,
              satisfiedText: satisfiedText,
              rating: rating,
              description: description,
              partner: partner,
              partnerLogoUrl: partnerLogoUrl,
              textTheme: textTheme,
            ),
            SizedBox(height: 16.h),
            const Divider(color: Color(0xFFE4E8ED), thickness: 1),
            SizedBox(height: 14.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/img/consultation/video.svg',
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 6.w),
                Text(
                  l10n.consultationVideoBookingPrompt,
                  style: textTheme.titleMedium?.copyWith(
                    color: ConsultationUiConfig.primaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            AvailabilitySection(
              textTheme: textTheme,
              days: availabilityDays,
              monthLabel: availabilityMonthLabel,
              isLoading: isAvailabilityLoading,
              errorMessage: availabilityErrorMessage,
              onSlotChanged: onSlotChanged,
            ),
            SizedBox(height: 20.h),
            IssueSection(
              textTheme: textTheme,
              controller: issueController,
            ),
            SizedBox(height: 18.h),
            PatientSection(textTheme: textTheme),
            SizedBox(height: 18.h),
            DocumentsSection(
              textTheme: textTheme,
              onBrowseTap: onBrowseTap,
              attachments: attachments,
              onRemoveAttachment: onRemoveAttachment,
            ),
            SizedBox(height: 16.h),
            const Divider(color: Color(0xFFE4E8ED), thickness: 1),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
