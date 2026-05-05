import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/di/dependency_injection.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/mock/consultation_doctors_mock_api.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/consultation_booking_confirmation_dialog_widget.dart';
import '../widgets/results_doctor_item.dart';
import '../widgets/consultation_hero_banner_widget.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../widgets/doctor_consultation_booking_body_widget.dart';
import '../widgets/consultation_upload_document_sheet_widget.dart';

class DoctorConsultationBookDoctorScreen extends StatefulWidget {
  final String? doctorId;
  final String doctorName;
  final String specialty;
  final String fee;
  final String imageUrl;

  const DoctorConsultationBookDoctorScreen({
    super.key,
    this.doctorId,
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
  final ConsultationDoctorsMockApi _doctorsApi = sl<ConsultationDoctorsMockApi>();
  final ImagePicker _imagePicker = ImagePicker();
  ResultsDoctorItem? _doctorDetail;
  bool _isLoading = true;
  String? _attachedMediaName;

  @override
  void initState() {
    super.initState();
    _loadDoctorDetail();
  }

  Future<void> _loadDoctorDetail() async {
    final doctorId = widget.doctorId;
    if (doctorId == null || doctorId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final response = await _doctorsApi.getDoctorDetailResponse(doctorId);
      final rawDoctor = response['doctor'];
      if (rawDoctor is Map<String, dynamic> && mounted) {
        setState(() {
          _doctorDetail = ResultsDoctorItem.fromMap(rawDoctor);
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return _buildFullScreenShimmer(context);
    }

    final textTheme = Theme.of(context).textTheme;
    final doctorName = _doctorDetail?.name ?? widget.doctorName;
    final specialty = _doctorDetail?.specialty ?? widget.specialty;
    final imageUrl = _doctorDetail?.imageUrl ?? widget.imageUrl;
    final qualification = _doctorDetail?.qualification ?? 'MBBS';
    final verifiedPatientsCount = _doctorDetail?.verifiedPatientsCount ?? '35';
    final experience = _doctorDetail?.experience ?? '2 Years';
    final satisfiedText = _doctorDetail?.satisfiedText ?? '4% (35)';
    final description = (_doctorDetail?.description ?? '').isNotEmpty
        ? _doctorDetail!.description
        : 'Doctor details are currently unavailable.';
    final ratingValue =
        double.tryParse((_doctorDetail?.rating ?? '4.5').split('/').first.trim()) ??
            4.5;
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
              ConsultationScreenHeaderWidget(
                title: ConsultationUiConfig.screenTitle,
                onBackTap: context.pop,
              ),
              ConsultationHeroBannerWidget(
                doctorImage: _buildDoctorHeroImage(imageUrl),
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
                      DoctorConsultationBookingBodyWidget(
                        doctorName: doctorName,
                        specialty: specialty,
                        imageUrl: imageUrl,
                        qualification: qualification,
                        verifiedPatientsCount: verifiedPatientsCount,
                        experience: experience,
                        satisfiedText: satisfiedText,
                        rating: ratingValue,
                        description: description,
                        textTheme: textTheme,
                        attachedMediaName: _attachedMediaName,
                        onBrowseTap: _openUploadDocumentSheet,
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
                              l10n.consultationGetAppointmentCta,
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
    final doctorName = _doctorDetail?.name ?? widget.doctorName;
    showDialog<void>(
      context: context,
      builder: (context) =>
          ConsultationBookingConfirmationDialogWidget(doctorName: doctorName),
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
        return ConsultationUploadDocumentSheetWidget(
          onCameraTap: () {
            sheetContext.pop();
            _pickFromCamera();
          },
          onGalleryTap: () {
            sheetContext.pop();
            _pickFromGallery();
          },
          onFileTap: () {
            sheetContext.pop();
            _pickFromFile();
          },
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
      _showSnackBar(AppLocalizations.of(context)!.consultationCameraUnavailable);
    } catch (_) {
      _showSnackBar(AppLocalizations.of(context)!.consultationCaptureMediaFailed);
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
      _showSnackBar(AppLocalizations.of(context)!.consultationGalleryUnavailable);
    } catch (_) {
      _showSnackBar(AppLocalizations.of(context)!.consultationPickGalleryFailed);
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
      _showSnackBar(AppLocalizations.of(context)!.consultationPickFileFailed);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDoctorHeroImage(String imageUrl) {
    final width = 188.w;
    final height = 177.h;
    final trimmed = imageUrl.trim();
    if (trimmed.isEmpty) {
      return Image.asset(
        ConsultationUiConfig.heroDoctorAsset,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
    final isNetwork =
        trimmed.startsWith('http://') || trimmed.startsWith('https://');
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: trimmed,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) => _heroFallback(width, height),
        errorWidget: (_, _, _) => _heroFallback(width, height),
      );
    }
    return Image.asset(
      trimmed,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _heroFallback(width, height),
    );
  }

  Widget _heroFallback(double width, double height) {
    return Image.asset(
      ConsultationUiConfig.heroDoctorAsset,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Widget _buildFullScreenShimmer(BuildContext context) {
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
                      onTap: () => context.pop(),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              SizedBox(height: 8.h),
              AppShimmerCard(
                width: 240.w,
                height: 178.h,
                borderRadius: 14.r,
              ),
              SizedBox(height: 10.h),
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
                            children: [
                              AppShimmerCard(
                                height: 300.h,
                                borderRadius: 12.r,
                              ),
                              SizedBox(height: 14.h),
                              AppShimmerCard(
                                height: 74.h,
                                borderRadius: 12.r,
                              ),
                              SizedBox(height: 14.h),
                              AppShimmerCard(
                                height: 116.h,
                                borderRadius: 10.r,
                              ),
                              SizedBox(height: 14.h),
                              AppShimmerCard(
                                height: 52.h,
                                borderRadius: 10.r,
                              ),
                              SizedBox(height: 14.h),
                              AppShimmerCard(
                                height: 78.h,
                                borderRadius: 10.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                        child: AppShimmerCard(
                          height: 58.h,
                          borderRadius: 18.r,
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
}
