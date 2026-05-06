import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/consultation_ui_config.dart';
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
    required this.textTheme,
    required this.attachedMediaName,
    required this.onBrowseTap,
    required this.issueController,
    required this.onTimeSlotChanged,
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
  final TextTheme textTheme;
  final String? attachedMediaName;
  final VoidCallback onBrowseTap;
  final TextEditingController issueController;
  final ValueChanged<String?> onTimeSlotChanged;

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
              onTimeSlotChanged: onTimeSlotChanged,
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
              attachedMediaName: attachedMediaName,
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
