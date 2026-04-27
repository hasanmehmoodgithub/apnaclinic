import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../../../lab_test/presentation/widgets/lab_test_figma_image.dart';
import '../constants/consultation_ui_config.dart';

class DoctorConsultationBookDoctorScreen extends StatefulWidget {
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
  State<DoctorConsultationBookDoctorScreen> createState() =>
      _DoctorConsultationBookDoctorScreenState();
}

class _DoctorConsultationBookDoctorScreenState
    extends State<DoctorConsultationBookDoctorScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _attachedMediaName;

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
                                doctorName: widget.doctorName,
                                specialty: widget.specialty,
                                imageUrl: widget.imageUrl,
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
                              _DocumentsSection(
                                textTheme: textTheme,
                                onBrowseTap: _openUploadDocumentSheet,
                                attachedMediaName: _attachedMediaName,
                              ),
                              SizedBox(height: 16.h),
                              const Divider(
                                color: Color(0xFFE4E8ED),
                                thickness: 1,
                              ),
                              SizedBox(height: 16.h),
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
            'Your consultation has been booked with ${widget.doctorName}. You can join the call from Appointments.',
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

  Future<void> _openUploadDocumentSheet() async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5D9DE),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Upload Document',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 14.h),
                _UploadOptionTile(
                  icon: Icons.camera_alt_outlined,
                  label: 'Use camera',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFromCamera();
                  },
                ),
                _UploadOptionTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Upload from gallery',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFromGallery();
                  },
                ),
                _UploadOptionTile(
                  icon: Icons.folder_open_outlined,
                  label: 'Upload from File',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFromFile();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() {
        _attachedMediaName = p.basename(picked.path);
      });
    } on PlatformException {
      _showSnackBar('Camera access is unavailable right now.');
    } catch (_) {
      _showSnackBar('Could not capture media. Please try again.');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() {
        _attachedMediaName = p.basename(picked.path);
      });
    } on PlatformException {
      _showSnackBar('Gallery access is unavailable right now.');
    } catch (_) {
      _showSnackBar('Could not pick media from gallery.');
    }
  }

  Future<void> _pickFromFile() async {
    try {
      final result = await FilePicker.pickFiles();
      if (result == null || result.files.isEmpty || !mounted) return;
      final selected = result.files.first;
      setState(() {
        _attachedMediaName = selected.name;
      });
    } catch (_) {
      _showSnackBar('Could not pick file. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
                SizedBox(height: 8.h),
                SizedBox(
                  width: 72.w,
                  height: 30.h,
                  child: _RatingProgressBadge(
                    rating: 4.5,
                    maxRating: 5,
                    textTheme: textTheme,
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

class _RatingProgressBadge extends StatelessWidget {
  const _RatingProgressBadge({
    required this.rating,
    required this.maxRating,
    required this.textTheme,
  });

  final double rating;
  final double maxRating;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final progress = (rating / maxRating).clamp(0.0, 1.0);
    return CustomPaint(
      painter: _RatingBorderPainter(progress: progress),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: rating.toStringAsFixed(1),
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF87D47A),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' / ',
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6E84A5),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: maxRating.toStringAsFixed(0),
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6E84A5),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingBorderPainter extends CustomPainter {
  const _RatingBorderPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final borderRect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final borderRRect = RRect.fromRectAndRadius(borderRect, Radius.circular(6.r));
    final borderPath = Path()..addRRect(borderRRect);

    final trackPaint = Paint()
      ..color = const Color(0xFF60789C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = const Color(0xFF8DD97E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(borderPath, trackPaint);
    for (final metric in borderPath.computeMetrics()) {
      final progressPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(progressPath, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RatingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
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
  int? _selectedTimeSlotIndex;

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
                onTap: () => setState(() {
                  _selectedDateIndex = index;
                  _selectedTimeSlotIndex = null;
                }),
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
                isSelected: _selectedTimeSlotIndex == index,
                onTap: () => setState(() => _selectedTimeSlotIndex = index),
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
  const _TimeSlotChip({
    required this.textTheme,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final TextTheme textTheme;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? ConsultationUiConfig.ctaColor
                : const Color(0xFFE1E5EA),
            width: 1,
          ),
          color: isSelected
              ? ConsultationUiConfig.ctaColor.withValues(alpha: 0.12)
              : Colors.white,
        ),
        child: Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected
                ? ConsultationUiConfig.ctaColor
                : const Color(0xFF5F6C7C),
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
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
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextField(
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF3C4858),
              fontSize: 13.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Explain How are You Feeling..',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF727F90),
                fontSize: 13.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
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
  const _DocumentsSection({
    required this.textTheme,
    required this.onBrowseTap,
    required this.attachedMediaName,
  });

  final TextTheme textTheme;
  final VoidCallback onBrowseTap;
  final String? attachedMediaName;

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
          child: SizedBox(
            height: 46.h,
            child: CustomPaint(
              painter: _DashedRoundedBorderPainter(
                color: const Color(0xFFD7DDE5),
                strokeWidth: 1,
                radius: 6,
                dashWidth: 3,
                dashSpace: 3,
              ),
              child: InkWell(
                onTap: onBrowseTap,
                borderRadius: BorderRadius.circular(6.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/consultation/upload.svg',
                      width: 19.w,
                      height: 16.h,
                      fit: BoxFit.contain,
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
          ),
        ),
        if ((attachedMediaName ?? '').isNotEmpty) ...[
          SizedBox(height: 8.h),
          Text(
            'Attached: $attachedMediaName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF5F6C7C),
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }
}

class _UploadOptionTile extends StatelessWidget {
  const _UploadOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
      dense: true,
      minLeadingWidth: 28.w,
      leading: Icon(icon, color: const Color(0xFF4D5869), size: 22.r),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF2E3A4B),
          fontSize: 14.sp,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius.r));
    final path = Path()..addRRect(rRect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}

