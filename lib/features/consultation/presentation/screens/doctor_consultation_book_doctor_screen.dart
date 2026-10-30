import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../data/models/doctor_consultation_checkout_model.dart';
import '../../domain/entities/consultation_booking_attachment_entity.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../../domain/entities/consultation_selected_slot_entity.dart';
import '../../domain/use_cases/get_consultation_doctor_detail_use_case.dart';
import '../../domain/use_cases/get_consultation_doctor_slots_use_case.dart';
import '../../domain/use_cases/get_payment_providers_use_case.dart';
import '../consultation_analytics.dart';
import '../constants/consultation_booking_attachment_config.dart';
import '../constants/consultation_system_ui.dart';
import '../constants/consultation_ui_config.dart';
import '../doctor_consultation_checkout_args.dart';
import '../mappers/consultation_doctor_detail_mapper.dart';
import '../widgets/consultation_hero_banner_widget.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../widgets/consultation_upload_document_sheet_widget.dart';
import '../widgets/doctor_consultation_booking_body_widget.dart';
import '../widgets/results_doctor_item.dart';

class DoctorConsultationBookDoctorScreen extends StatefulWidget {
  final ResultsDoctorItem doctor;
  final String? moduleSource;
  final ConsultationSelectedSlotEntity? initialSelectedSlot;
  final bool hydrateDoctorFromDetailApi;

  const DoctorConsultationBookDoctorScreen({
    super.key,
    required this.doctor,
    this.moduleSource,
    this.initialSelectedSlot,
    this.hydrateDoctorFromDetailApi = false,
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
  late ConsultationSelectedSlotEntity? _selectedSlot =
      widget.initialSelectedSlot;
  late ResultsDoctorItem _doctor = widget.doctor;
  String? _validationErrorMessage;
  bool _isAvailabilityLoading = true;
  String? _availabilityErrorMessage;
  List<ConsultationAvailabilityDayEntity> _availabilityDays = const [];
  ConsultationDoctorSlotsDoctorInfoEntity? _slotsDoctorInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.moduleSource == AnalyticsConsultancySourceKeys.search) {
        ConsultationAnalytics.logModule(widget.moduleSource!);
      }
      ConsultationAnalytics.logProfileScreen(_doctor);
      _loadDoctorSlots();
    });
  }

  Future<void> _loadDoctorSlots() async {
    setState(() {
      _isAvailabilityLoading = true;
      _availabilityErrorMessage = null;
    });

    final doctor = _doctor;
    final doctorId = doctor.partnerDoctorId.trim().isNotEmpty
        ? doctor.partnerDoctorId
        : (doctor.apiDoctorId.trim().isNotEmpty ? doctor.apiDoctorId : doctor.id);
    final hospitalId =
        doctor.hospitalId.trim().isNotEmpty ? doctor.hospitalId : null;

    // AI deep link only — dedicated web detail API for missing profile fields.
    final detailFuture = widget.hydrateDoctorFromDetailApi
        ? sl<GetConsultationDoctorDetailUseCase>()(
            GetConsultationDoctorDetailParams(doctorId: doctorId),
          )
        : null;

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
        _slotsDoctorInfo = null;
      }),
      (schedule) => setState(() {
        _isAvailabilityLoading = false;
        _availabilityErrorMessage = null;
        _availabilityDays = schedule.days;
        _slotsDoctorInfo = schedule.doctorInfo;
      }),
    );

    if (detailFuture == null || !mounted) return;
    final detailResult = await detailFuture;
    if (!mounted) return;
    detailResult.fold(
      (_) {},
      (profile) => setState(() {
        _doctor = profile.toResultsDoctorItem();
      }),
    );
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  bool get _hasAvailableSlots =>
      _availabilityDays.any((day) => day.slots.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final doctor = _doctor;
    final qualification = doctor.qualification.trim();
    final experience = doctor.experience.trim();
    final description = doctor.description.trim();
    final slotsInfo = _slotsDoctorInfo;
    final verifiedPatientsCount = slotsInfo?.verifiedPatientsCount.toString();
    final satisfiedText = slotsInfo == null
        ? null
        : '${_formatPercentage(slotsInfo.patientsSatisfiedPercentage)}% (${slotsInfo.verifiedPatientsCount})';
    final ratingValue =
        slotsInfo?.ratings ?? _parseDoctorRating(doctor.rating);
    final showPmdcVerified = slotsInfo?.pmdcVerified == true;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: consultationSystemUiOverlay,
      child: Scaffold(
      backgroundColor: AppColors.clrWhite,
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
          bottom: false,
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
                  child: SafeArea(
                    top: false,
                    bottom: false,
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
                        showPmdcVerified: showPmdcVerified,
                        description: description,
                        partner: doctor.partner,
                        partnerLogoUrl: doctor.partnerLogoUrl,
                        textTheme: textTheme,
                        patientReviews: slotsInfo?.patientReviews,
                        attachments: _attachments,
                        onBrowseTap: _openUploadDocumentSheet,
                        onRemoveAttachment: _removeAttachment,
                        issueController: _issueController,
                        onSlotChanged: (value) {
                          setState(() {
                            _selectedSlot = value;
                            _validationErrorMessage = null;
                          });
                        },
                        availabilityDays: _availabilityDays,
                        isAvailabilityLoading: _isAvailabilityLoading,
                        availabilityErrorMessage: _availabilityErrorMessage,
                        initialSelectedSlot: widget.initialSelectedSlot,
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
                            onPressed: _hasAvailableSlots
                                ? () => _onGetAppointmentPressed(
                                      context: context,
                                      l10n: l10n,
                                      doctor: doctor,
                                    )
                                : null,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: ConsultationUiConfig.ctaColor,
                              disabledBackgroundColor: ConsultationUiConfig
                                  .ctaColor
                                  .withValues(alpha: 0.28),
                              disabledForegroundColor:
                                  AppColors.clrWhite.withValues(alpha: 0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                            ),
                            child: Text(
                              l10n.consultationGetAppointmentCta,
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.clrWhite.withValues(
                                  alpha: _hasAvailableSlots ? 1 : 0.35,
                                ),
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
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Future<void> _onGetAppointmentPressed({
    required BuildContext context,
    required AppLocalizations l10n,
    required ResultsDoctorItem doctor,
  }) async {
    if (_selectedSlot == null) {
      setState(() {
        _validationErrorMessage = l10n.consultationSelectSlotError;
      });
      return;
    }
    setState(() => _validationErrorMessage = null);

    const loaderId = 'consultation_payment_providers_prefetch';
    showHeartLoaderDialog(context, id: loaderId);

    final result = await sl<GetPaymentProvidersUseCase>()(
      const GetPaymentProvidersParams(module: PaymentProviderModule.consultation),
    );

    if (!mounted) {
      HeartLoaderDialogController.close(loaderId);
      return;
    }
    HeartLoaderDialogController.close(loaderId);

    final paymentOptions = result.fold(
      (error) {
        ScaffoldMessenger.of(this.context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error)));
        return null;
      },
      (providers) => providers
          .map(DoctorConsultationPaymentOptionModel.fromProvider)
          .toList(growable: false),
    );

    if (paymentOptions == null || !mounted) return;

    if (paymentOptions.isEmpty) {
      ScaffoldMessenger.of(this.context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.consultationBookingFailed)),
        );
      return;
    }

    ConsultationAnalytics.logConsultationConfirm(
      doctor: doctor,
      slot: _selectedSlot!,
    );

    this.context.pushNamed(
      AppRoutes.consultationCheckout,
      extra: DoctorConsultationCheckoutArgs(
        doctor: doctor,
        issueDescription: _issueController.text.trim(),
        selectedSlot: _selectedSlot!,
        attachments: List<ConsultationBookingAttachmentEntity>.unmodifiable(
          _attachments,
        ),
        paymentOptions: paymentOptions,
      ),
    );
  }

  Future<void> _openUploadDocumentSheet() async {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;
    if (_attachments.length >=
        ConsultationBookingAttachmentConfig.maxFileCount) {
      _showSnackBar(l10n.consultationMaxFilesReached);
      return;
    }

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

  Future<void> _addAttachments(
    Iterable<ConsultationBookingAttachmentEntity> items,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final remainingSlots =
        ConsultationBookingAttachmentConfig.maxFileCount - _attachments.length;
    if (remainingSlots <= 0) {
      if (mounted) {
        _showSnackBar(l10n.consultationMaxFilesReached);
      }
      return;
    }

    final accepted = <ConsultationBookingAttachmentEntity>[];
    var hitFileCountLimit = false;
    var hitUnsupportedType = false;

    for (final item in items) {
      if (accepted.length >= remainingSlots) {
        hitFileCountLimit = true;
        break;
      }

      final path = item.path.trim();
      final name = item.name.trim();
      if (path.isEmpty || name.isEmpty) continue;

      if (!ConsultationBookingAttachmentConfig.isAllowedFile(
        name: name,
        path: path,
      )) {
        hitUnsupportedType = true;
        continue;
      }

      final file = File(path);
      if (!await file.exists()) continue;

      final sizeBytes = await file.length();
      if (sizeBytes > ConsultationBookingAttachmentConfig.maxFileSizeBytes) {
        if (mounted) {
          _showSnackBar(l10n.consultationFileTooLarge(name));
        }
        continue;
      }

      accepted.add(item);
    }

    if (!mounted) return;

    if (hitUnsupportedType) {
      _showSnackBar(l10n.consultationUnsupportedFileType);
    }
    if (hitFileCountLimit) {
      _showSnackBar(l10n.consultationMaxFilesReached);
    }

    if (accepted.isEmpty) return;

    setState(() {
      _attachments.addAll(accepted);
    });
    ConsultationAnalytics.logDocumentUploaded();
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
      await _addAttachments([
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
      await _addAttachments(
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
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions:
            ConsultationBookingAttachmentConfig.allowedExtensions.toList(),
      );
      if (result == null || result.files.isEmpty || !mounted) return;
      await _addAttachments(
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

  String _formatPercentage(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  double? _parseDoctorRating(String rating) {
    final part = rating.split('/').first.trim();
    if (part.isEmpty) return null;
    return double.tryParse(part);
  }
}
