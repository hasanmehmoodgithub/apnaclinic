import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../../../lab_test/presentation/widgets/lab_test_figma_image.dart';
import '../constants/consultation_ui_config.dart';
import 'rating_progress_badge.dart';

class DoctorProfileSection extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;
  final TextTheme textTheme;

  const DoctorProfileSection({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 24.sp,
                      height: 1.05,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    specialty,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ConsultationUiConfig.tertiaryText,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'MBBS',
                    style: textTheme.bodyMedium?.copyWith(
                      color: ConsultationUiConfig.tertiaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              children: [
                SizedBox(
                  // width: 90.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
                SizedBox(height: 8.h),
                SizedBox(
                  width: 72.w,
                  height: 30.h,
                  child: RatingProgressBadge(
                    rating: 4.5,
                    maxRating: 5,
                    textTheme: textTheme,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 14.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Verified Patients\nCount',
                  value: '35',
                  textTheme: textTheme,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatCard(
                  title: 'Experience',
                  value: '2 Years',
                  textTheme: textTheme,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatCard(
                  title: 'Satisfied',
                  value: '4% (35)',
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
        ),
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
                child: LabTestFigmaImage(
                  url: Assets.labTestMedIQLogo,
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'MedIQ',
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF1E2D3F),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
              _DoctorDescription(textTheme: textTheme),
            ],
          ),
        ),
      ],
    );
  }
}

class _DoctorDescription extends StatefulWidget {
  const _DoctorDescription({required this.textTheme});

  final TextTheme textTheme;

  @override
  State<_DoctorDescription> createState() => _DoctorDescriptionState();
}

class _DoctorDescriptionState extends State<_DoctorDescription> {
  static const String _fullDescription =
      'Dr. Saadiya, a graduate of Fauji Foundation Medical College, has gained '
      'extensive clinical experience through roles at FFH Rawalpindi, Asia '
      'General Hospital, and Fatima Medicare. She currently serves as a '
      'post-graduate trainee in the Department of Medicine at Fauji Foundation '
      'Hospital Rawalpindi, demonstrating a commitment to continuous learning '
      'and excellence in patient care. She is known for conducting thorough '
      'evaluations, offering accurate diagnoses, and ensuring effective '
      'treatment tailored to each patient\'s needs. Her patient-centered '
      'approach emphasizes clear communication, empathy, and personalized '
      'attention. Dedicated to providing modern healthcare solutions, she '
      'ensures that patients receive safe, reliable, and holistic care.';

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _fullDescription,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7A8797),
              fontSize: 14.sp,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF1E2D3F),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
