import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/availability_section.dart';
import '../widgets/doctor_profile_section.dart';
import '../widgets/documents_section.dart';
import '../widgets/issue_section.dart';
import '../widgets/patient_section.dart';
import '../widgets/upload_option_tile.dart';

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
                              DoctorProfileSection(
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
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18.h),
                              AvailabilitySection(textTheme: textTheme),
                              SizedBox(height: 20.h),
                              IssueSection(textTheme: textTheme),
                              SizedBox(height: 18.h),
                              PatientSection(textTheme: textTheme),
                              SizedBox(height: 18.h),
                              DocumentsSection(
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
                UploadOptionTile(
                  icon: Icons.camera_alt_outlined,
                  label: 'Use camera',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFromCamera();
                  },
                ),
                UploadOptionTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Upload from gallery',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFromGallery();
                  },
                ),
                UploadOptionTile(
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
