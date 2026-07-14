import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';
import 'consultation_partner_logo_widget.dart';
import 'rating_progress_badge.dart';

class DoctorProfileSection extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;
  final String qualification;
  final String? verifiedPatientsCount;
  final String experience;
  final String? satisfiedText;
  final double? rating;
  final bool showPmdcVerified;
  final String description;
  final String partner;
  final String partnerLogoUrl;
  final TextTheme textTheme;

  const DoctorProfileSection({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
    required this.qualification,
    this.verifiedPatientsCount,
    required this.experience,
    this.satisfiedText,
    this.rating,
    this.showPmdcVerified = false,
    required this.description,
    required this.partner,
    required this.partnerLogoUrl,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final showRating = rating != null;
    final showSideBadges = showPmdcVerified || showRating;
    final statCards = <Widget>[
      if (verifiedPatientsCount != null)
        Expanded(
          child: _StatCard(
            title: 'Verified Patients\nCount',
            value: verifiedPatientsCount!,
            textTheme: textTheme,
          ),
        ),
      if (experience.isNotEmpty) ...[
        if (verifiedPatientsCount != null) SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(
            title: 'Experience',
            value: experience,
            textTheme: textTheme,
          ),
        ),
      ],
      if (satisfiedText != null) ...[
        if (verifiedPatientsCount != null || experience.isNotEmpty)
          SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(
            title: 'Satisfied',
            value: satisfiedText!,
            textTheme: textTheme,
          ),
        ),
      ],
    ];

    return Column(
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
                    doctorName,
                    style: textTheme.titleMedium?.copyWith(
                      color: ConsultationUiConfig.primaryText,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  if (specialty.isNotEmpty) ...[
                    Text(
                      specialty,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ConsultationUiConfig.tertiaryText,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                  if (qualification.isNotEmpty)
                    Text(
                      qualification,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ConsultationUiConfig.tertiaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                ],
              ),
            ),
            if (showSideBadges) ...[
              SizedBox(width: 10.w),
              Column(
                children: [
                  if (showPmdcVerified)
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE1E5EA)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/img/consultation/verified.svg',
                                  width: 17.w,
                                  height: 17.h,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'PMC',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF2E3A4B),
                                    fontSize: 14.sp,
                                    height: 1.05,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Verified',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF2E3A4B),
                                fontSize: 14.sp,
                                height: 1.05,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (showPmdcVerified && showRating) SizedBox(height: 8.h),
                  if (showRating)
                    SizedBox(
                      width: 72.w,
                      height: 30.h,
                      child: RatingProgressBadge(
                        rating: rating!,
                        maxRating: 5,
                        textTheme: textTheme,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
        if (statCards.isNotEmpty) ...[
          SizedBox(height: 14.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: statCards,
            ),
          ),
        ],
        if (partner.trim().isNotEmpty || partnerLogoUrl.trim().isNotEmpty) ...[
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E6EB), width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E6EB), width: 1),
                  ),
                  alignment: Alignment.center,
                  child: ConsultationPartnerLogoWidget(
                    logoUrl: partnerLogoUrl,
                    width: 24.w,
                    height: 24.h,
                    compact: true,
                  ),
                ),
                if (partner.trim().isNotEmpty) ...[
                  SizedBox(width: 8.w),
                  Text(
                    partner,
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF1E2D3F),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (description.isNotEmpty) ...[
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E6EB), width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF1E2D3F),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                _DoctorDescription(
                  textTheme: textTheme,
                  fullDescription: description,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _DoctorDescription extends StatefulWidget {
  const _DoctorDescription({
    required this.textTheme,
    required this.fullDescription,
  });

  final TextTheme textTheme;
  final String fullDescription;

  @override
  State<_DoctorDescription> createState() => _DoctorDescriptionState();
}

class _DoctorDescriptionState extends State<_DoctorDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fullDescription,
          maxLines: _expanded ? null : 3,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: widget.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF5A687A),
            fontSize: 14.sp,
            height: 1.35,
          ),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Read less' : 'Read more...',
            style: widget.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF356E9B),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.textTheme,
  });

  final String title;
  final String value;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E6EB), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7A8797),
              fontSize: 13.sp,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF1E2D3F),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
