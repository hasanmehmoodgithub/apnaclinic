import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class DoctorConsultationBookDoctorScreen extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String fee;
  final String imageUrl;

  const DoctorConsultationBookDoctorScreen({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.fee,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConsultationUiConfig.pageTopGradient,
              ConsultationUiConfig.pageBottomGradient,
            ],
            stops: [0.09, 0.36],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 8.h, 22.w, 8.h),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Center(
                          child: SvgPicture.asset(
                            ConsultationUiConfig.backArrowAsset,
                            width: 18.w,
                            height: 18.h,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              ConsultationUiConfig.primaryText,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ConsultationUiConfig.screenTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          color: ConsultationUiConfig.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                  ],
                ),
              ),
              SizedBox(
                height: 178.h,
                child: Center(
                  child: SizedBox(
                    width: 240.w,
                    height: 178.h,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: 2.h,
                          child: SvgPicture.asset(
                            ConsultationUiConfig.heroVectorAsset,
                            width: 238.w,
                            height: 172.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Image.asset(
                            ConsultationUiConfig.heroDoctorAsset,
                            width: 188.w,
                            height: 177.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(42.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DoctorProfileSection(
                                doctorName: doctorName,
                                specialty: specialty,
                                imageUrl: imageUrl,
                                textTheme: textTheme,
                              ),
                              SizedBox(height: 16.h),
                              const Divider(color: Color(0xFFE4E8ED), thickness: 1),
                              SizedBox(height: 14.h),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.videocam_rounded,
                                    color: Color(0xFF1E2D3F),
                                    size: 16,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Book your video consultation here!',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: ConsultationUiConfig.primaryText,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18.h),
                              _AvailabilitySection(textTheme: textTheme),
                              SizedBox(height: 20.h),
                              _IssueSection(textTheme: textTheme),
                              SizedBox(height: 18.h),
                              _PatientSection(textTheme: textTheme),
                              SizedBox(height: 18.h),
                              _DocumentsSection(textTheme: textTheme),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                        child: SizedBox(
                          width: double.infinity,
                          height: 58.h,
                          child: ElevatedButton(
                            onPressed: () => _showConfirmation(context),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: ConsultationUiConfig.ctaColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                            ),
                            child: Text(
                              'Get Appointment',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Appointment Confirmed!',
            style: textTheme.titleLarge?.copyWith(
              color: ConsultationUiConfig.primaryText,
              fontWeight: FontWeight.w700,
              fontSize: 22.sp,
            ),
          ),
          content: Text(
            'Your consultation has been booked with $doctorName. You can join the call from Appointments.',
            style: textTheme.bodyMedium?.copyWith(
              color: ConsultationUiConfig.tertiaryText,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _DoctorProfileSection extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;
  final TextTheme textTheme;

  const _DoctorProfileSection({
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
              child: Text(
                doctorName,
                style: textTheme.titleMedium?.copyWith(
                  color: ConsultationUiConfig.primaryText,
                  fontSize: 24.sp,
                  height: 1.05,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE1E5EA)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: ConsultationUiConfig.ctaColor,
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'PMC\nVerified',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF2E3A4B),
                          fontSize: 14.sp,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFDAEFCF), width: 1),
                    color: const Color(0xFFF5FBEF),
                  ),
                  child: Text(
                    '4.5  /  5',
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF87B074),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
        SizedBox(height: 14.h),
        Row(
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
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E6EB), width: 1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Med',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6D49B9),
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w700,
                  ),
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
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF1E2D3F),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilitySection extends StatefulWidget {
  final TextTheme textTheme;

  const _AvailabilitySection({required this.textTheme});

  @override
  State<_AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<_AvailabilitySection> {
  int? _selectedDateIndex;

  static const List<_AvailabilityDay> _days = [
    _AvailabilityDay(
      weekDay: 'Thu',
      dayOfMonth: '23',
      timeSlots: ['6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM', '7:00 PM - 7:30 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Fri',
      dayOfMonth: '24',
      timeSlots: ['5:30 PM - 6:00 PM', '6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Sat',
      dayOfMonth: '25',
      timeSlots: ['4:30 PM - 5:00 PM', '5:00 PM - 5:30 PM', '5:30 PM - 6:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Sun',
      dayOfMonth: '26',
      timeSlots: ['6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Mon',
      dayOfMonth: '27',
      timeSlots: ['7:00 PM - 7:30 PM', '7:30 PM - 8:00 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Tue',
      dayOfMonth: '28',
      timeSlots: ['6:00 PM - 6:30 PM', '6:30 PM - 7:00 PM', '7:00 PM - 7:30 PM'],
    ),
    _AvailabilityDay(
      weekDay: 'Wed',
      dayOfMonth: '29',
      timeSlots: ['5:30 PM - 6:00 PM', '6:00 PM - 6:30 PM'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedDay = _selectedDateIndex == null
        ? null
        : _days[_selectedDateIndex!];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Availability',
              style: widget.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF1E2D3F),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE1E5EA), width: 1),
              ),
              child: Text(
                'April 2026',
                style: widget.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF5F6C7C),
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 74.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final item = _days[index];
              final selected = _selectedDateIndex == index;
              return InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => setState(() => _selectedDateIndex = index),
                child: Container(
                  width: 56.w,
                  decoration: BoxDecoration(
                    color: selected
                        ? ConsultationUiConfig.ctaColor
                        : const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.weekDay,
                        style: widget.textTheme.bodySmall?.copyWith(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.9)
                              : const Color(0xFF778395),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.dayOfMonth,
                        style: widget.textTheme.titleMedium?.copyWith(
                          color: selected ? Colors.white : const Color(0xFF545F70),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (selectedDay != null) ...[
          SizedBox(height: 10.h),
          SizedBox(
            height: 30.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedDay.timeSlots.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) => _TimeSlotChip(
                textTheme: widget.textTheme,
                text: selectedDay.timeSlots[index],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AvailabilityDay {
  const _AvailabilityDay({
    required this.weekDay,
    required this.dayOfMonth,
    required this.timeSlots,
  });

  final String weekDay;
  final String dayOfMonth;
  final List<String> timeSlots;
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({required this.textTheme, required this.text});

  final TextTheme textTheme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE1E5EA), width: 1),
        color: Colors.white,
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF5F6C7C),
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _IssueSection extends StatelessWidget {
  const _IssueSection({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Issue',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1E2D3F),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 116.h,
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Explain How are You Feeling..',
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF727F90),
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientSection extends StatelessWidget {
  const _PatientSection({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1E2D3F),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(0),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            'Self',
            style: textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF3C4858),
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documents',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1E2D3F),
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E6EB), width: 1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: const Color(0xFFD7DDE5),
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF627084),
                  size: 18,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Browse',
                  style: textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF3C4858),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

