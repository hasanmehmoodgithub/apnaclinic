import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/consultation_booking_attachment_entity.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../../domain/entities/consultation_selected_slot_entity.dart';
import '../../domain/use_cases/get_consultation_doctor_slots_use_case.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/results_doctor_item.dart';
import '../widgets/consultation_hero_banner_widget.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../widgets/doctor_consultation_booking_body_widget.dart';
import '../widgets/consultation_upload_document_sheet_widget.dart';
import '../doctor_consultation_checkout_args.dart';

class DoctorConsultationBookDoctorScreen extends StatefulWidget {
  final ResultsDoctorItem doctor;

  const DoctorConsultationBookDoctorScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorConsultationBookDoctorScreen> createState() =>
      _DoctorConsultationBookDoctorScreenState();
}

class _DoctorConsultationBookDoctorScreenState
    extends State<DoctorConsultationBookDoctorScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _issueController = TextEditingController();
  final List<ConsultationBookingAttachmentEntity> _attachments = [];
  ConsultationSelectedSlotEntity? _selectedSlot;
  String? _validationErrorMessage;
  bool _isAvailabilityLoading = true;
  String? _availabilityErrorMessage;
  List<ConsultationAvailabilityDayEntity> _availabilityDays = const [];
  String _availabilityMonthLabel = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadDoctorSlots();
    });
  }

  Future<void> _loadDoctorSlots() async {
    setState(() {
      _isAvailabilityLoading = true;
      _availabilityErrorMessage = null;
    });

    final doctor = widget.doctor;
    final doctorId = doctor.partnerDoctorId.trim().isNotEmpty
        ? doctor.partnerDoctorId
        : (doctor.apiDoctorId.trim().isNotEmpty ? doctor.apiDoctorId : doctor.id);
    final hospitalId =
        doctor.hospitalId.trim().isNotEmpty ? doctor.hospitalId : null;

    final result = await sl<GetConsultationDoctorSlotsUseCase>()(
      GetConsultationDoctorSlotsParams(
        doctorId: doctorId,
        hospitalId: hospitalId,
      ),
    );

    if (!mounted) return;

    result.fold(
      (error) => setState(() {
        _isAvailabilityLoading = false;
        _availabilityErrorMessage = error;
        _availabilityDays = const [];
        _availabilityMonthLabel = '';
      }),
      (schedule) => setState(() {
        _isAvailabilityLoading = false;
        _availabilityErrorMessage = null;
        _availabilityDays = schedule.days;
        _availabilityMonthLabel = schedule.monthLabel;
      }),
    );
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final doctor = widget.doctor;
    final qualification =
        doctor.qualification.isNotEmpty ? doctor.qualification : 'MBBS';
    final verifiedPatientsCount = doctor.verifiedPatientsCount != '0'
        ? doctor.verifiedPatientsCount
        : '35';
    final experience =
        doctor.experience.isNotEmpty ? doctor.experience : '2 Years';
    final satisfiedText =
        doctor.satisfiedText != '0' ? doctor.satisfiedText : '4% (35)';
    final ratingValue =
        double.tryParse(doctor.rating.split('/').first.trim()) ?? 4.5;
    final description = doctor.description.isNotEmpty
        ? doctor.description
        : 'Doctor details are currently unavailable.';

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
            stops: [0.5, 1.0],
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
                doctorImage: _buildDoctorHeroImage(doctor.imageUrl),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      DoctorConsultationBookingBodyWidget(
                        doctorName: doctor.name,
                        specialty: doctor.specialty,
                        imageUrl: doctor.imageUrl,
                        qualification: qualification,
                        verifiedPatientsCount: verifiedPatientsCount,
                        experience: experience,
                        satisfiedText: satisfiedText,
                        rating: ratingValue,
                        description: description,
                        partner: doctor.partner,
                        partnerLogoUrl: doctor.partnerLogoUrl,
                        textTheme: textTheme,
                        attachments: _attachments,
                        onBrowseTap: _openUploadDocumentSheet,
                        onRemoveAttachment: _removeAttachment,
                        issueController: _issueController,
                        onSlotChanged: (value) {
                          setState(() {
                            _selectedSlot = value;
                            if (_validationErrorMessage != null) {
                              _validationErrorMessage = null;
                            }
                          });
                        },
                        availabilityDays: _availabilityDays,
                        availabilityMonthLabel: _availabilityMonthLabel,
                        isAvailabilityLoading: _isAvailabilityLoading,
                        availabilityErrorMessage: _availabilityErrorMessage,
                      ),
                      if (_validationErrorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          margin: EdgeInsets.only(bottom: 12.h),
                          color: const Color(0xFFFDECEC),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 18.r,
                                color: const Color(0xFFD72222),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  _validationErrorMessage!,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFFD72222),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                        child: SizedBox(
                          width: double.infinity,
                          height: 58.h,
                          child: ElevatedButton(
                            onPressed: () {
                              final trimmedIssue = _issueController.text.trim();
                              if (trimmedIssue.isEmpty) {
                                setState(() {
                                  _validationErrorMessage =
                                      l10n.consultationRequiredFieldsError;
                                });
                                return;
                              }
                              if (_selectedSlot == null) {
                                setState(() {
                                  _validationErrorMessage =
                                      l10n.consultationSelectSlotError;
                                });
                                return;
                              }
                              setState(() {
                                _validationErrorMessage = null;
                              });
                              context.pushNamed(
                                AppRoutes.consultationCheckout,
                                extra: DoctorConsultationCheckoutArgs(
                                  doctor: doctor,
                                  issueDescription: trimmedIssue,
                                  selectedSlot: _selectedSlot!,
                                  attachments:
                                      List<ConsultationBookingAttachmentEntity>.unmodifiable(
                                    _attachments,
                                  ),
                                ),
                              );
                            },
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

  void _addAttachments(Iterable<ConsultationBookingAttachmentEntity> items) {
    final next = items
        .where((item) => item.path.trim().isNotEmpty && item.name.trim().isNotEmpty)
        .toList();
    if (next.isEmpty) return;
    setState(() {
      _attachments.addAll(next);
    });
  }

  void _removeAttachment(int index) {
    if (index < 0 || index >= _attachments.length) return;
    setState(() {
      _attachments.removeAt(index);
    });
  }

  Future<void> _pickFromCamera() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      _addAttachments([
        ConsultationBookingAttachmentEntity(
          name: p.basename(picked.path),
          path: picked.path,
        ),
      ]);
    } on PlatformException {
      _showSnackBar(AppLocalizations.of(context)!.consultationCameraUnavailable);
    } catch (_) {
      _showSnackBar(AppLocalizations.of(context)!.consultationCaptureMediaFailed);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picked = await _imagePicker.pickMultiImage(imageQuality: 85);
      if (picked.isEmpty || !mounted) return;
      _addAttachments(
        picked.map(
          (file) => ConsultationBookingAttachmentEntity(
            name: p.basename(file.path),
            path: file.path,
          ),
        ),
      );
    } on PlatformException {
      _showSnackBar(AppLocalizations.of(context)!.consultationGalleryUnavailable);
    } catch (_) {
      _showSnackBar(AppLocalizations.of(context)!.consultationPickGalleryFailed);
    }
  }

  Future<void> _pickFromFile() async {
    try {
      final result = await FilePicker.pickFiles(allowMultiple: true);
      if (result == null || result.files.isEmpty || !mounted) return;
      _addAttachments(
        result.files
            .where((file) => (file.path ?? '').trim().isNotEmpty)
            .map(
              (file) => ConsultationBookingAttachmentEntity(
                name: file.name,
                path: file.path!,
              ),
            ),
      );
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
    final Widget image;
    if (trimmed.isEmpty) {
      image = _heroFallback(width, height);
    } else if (trimmed.startsWith('http://') ||
        trimmed.startsWith('https://')) {
      image = CachedNetworkImage(
        imageUrl: trimmed,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) => _heroFallback(width, height),
        errorWidget: (_, _, _) => _heroFallback(width, height),
      );
    } else {
      image = Image.asset(
        trimmed,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _heroFallback(width, height),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: image,
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
}
