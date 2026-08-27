import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../constants/consultation_partner_filter_defaults.dart';
import 'consultation_partner_logo_widget.dart';
import 'doctor_consultation_summary_card_shell_widget.dart';

class DoctorConsultationSummaryDoctorCardWidget extends StatelessWidget {
  const DoctorConsultationSummaryDoctorCardWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.experience,
    required this.qualification,
    required this.dateLabel,
    required this.timeLabel,
    required this.partnerLogoUrl,
    this.partnerTenantId = '',
  });

  final String doctorName;
  final String specialty;
  final String experience;
  final String qualification;
  final String dateLabel;
  final String timeLabel;
  final String partnerLogoUrl;

  /// `partner.tenantId` — fallback logo when API omits `logoUrl`.
  final String partnerTenantId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final experienceLine = _experienceLine();
    final known =
        ConsultationPartnerFilterDefaults.knownById(partnerTenantId);
    final logo = partnerLogoUrl.trim().isNotEmpty
        ? partnerLogoUrl.trim()
        : (known?.resolvedLogo ?? '');

    return DoctorConsultationSummaryCardShell(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              right: -16.w,
              top: -4.h,
              child: Image.asset(
                Assets.consultationSummaryDoctorCardVector,
                width: 150.w,
                height: 125.h,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 88.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Image.asset(
                          Assets.consultationSummaryHeartEcg,
                          width: 25.r,
                          height: 25.r,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              specialty,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (experienceLine.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                experienceLine,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF667B99),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w300,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      _InfoPill(label: dateLabel, textTheme: textTheme),
                      _InfoPill(label: timeLabel, textTheme: textTheme),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10.w,
              top: 14.h,
              child: ConsultationPartnerLogoWidget(
                logoUrl: logo,
                width: 88.w,
                height: 40.h,
                compact: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _experienceLine() {
    final experienceText = experience.trim();
    final qualificationText = qualification.trim();
    if (experienceText.isEmpty && qualificationText.isEmpty) return '';
    if (experienceText.isEmpty) return qualificationText;
    if (qualificationText.isEmpty) return experienceText;
    return '$experienceText , $qualificationText';
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.textTheme,
  });

  final String label;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF667B99),
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
