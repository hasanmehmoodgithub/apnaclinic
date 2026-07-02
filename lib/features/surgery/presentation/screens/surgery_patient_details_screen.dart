import 'package:apnaclinic/core/widgets/app_scaffold_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../cubit/surgery_cubit.dart';
import '../widgets/surgery_doctor_summary_widget.dart';
import '../widgets/surgery_form_error_banner_widget.dart';
import '../widgets/surgery_gender_field_widget.dart';
import '../widgets/surgery_option.dart';
import '../widgets/surgery_text_input_field_widget.dart';
import '../widgets/surgery_type_dialog_widget.dart';

class SurgeryPatientDetailsScreen extends StatefulWidget {
  const SurgeryPatientDetailsScreen({
    super.key,
    required this.surgeryId,
    required this.cityId,
    required this.doctorId,
    required this.doctorName,
    required this.speciality,
    required this.experience,
    required this.qualifications,
    required this.hospitalName,
    required this.procedureName,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.partnerLogoUrl,
  });

  final String surgeryId;
  final String cityId;
  final String doctorId;
  final String doctorName;
  final String speciality;
  final String experience;
  final String qualifications;
  final String hospitalName;
  final String procedureName;
  final String price;
  final String oldPrice;
  final String imageUrl;
  final String partnerLogoUrl;

  @override
  State<SurgeryPatientDetailsScreen> createState() =>
      _SurgeryPatientDetailsScreenState();
}

class _SurgeryPatientDetailsScreenState
    extends State<SurgeryPatientDetailsScreen> {
  final AppPref _appPref = sl<AppPref>();

  SurgeryOption? selectedSurgery;
  String? selectedGender;
  bool showNameError = false;
  bool showAgeError = false;
  bool showContactError = false;
  bool showEmergencyError = false;
  bool showGenderError = false;
  String? validationBannerMessage;
  bool isSubmittingBooking = false;
  bool isLoadingSurgeryTypes = false;

  late final TextEditingController patientNameController;
  late final TextEditingController ageController;
  late final TextEditingController contactNumberController;
  late final TextEditingController emergencyContactController;

  @override
  void initState() {
    super.initState();
    patientNameController = TextEditingController();
    ageController = TextEditingController();
    contactNumberController = TextEditingController();
    emergencyContactController = TextEditingController();
    _prefillPatientDetailsFromSavedProfile();
    selectedSurgery = SurgeryOption(
      id: '',
      name: widget.procedureName,
      price: widget.price,
      oldPrice: widget.oldPrice,
      hospitalName: widget.hospitalName,
    );
  }

  @override
  void dispose() {
    patientNameController.dispose();
    ageController.dispose();
    contactNumberController.dispose();
    emergencyContactController.dispose();
    super.dispose();
  }

  void _prefillPatientDetailsFromSavedProfile() {
    final userLocal = _appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final phone = userLocal?.phone.trim() ?? '';

    if (fullName.isNotEmpty) {
      patientNameController.text = fullName;
    }
    if (phone.isNotEmpty) {
      contactNumberController.text = phone;
    }

    final gender = _normalizeGender(userLocal?.gender ?? '');
    if (gender != null) {
      selectedGender = gender;
    }

    final age = _ageFromDateOfBirth(userLocal?.dateOfBirth ?? '');
    if (age != null && age > 0) {
      ageController.text = age.toString();
    }
  }

  String? _normalizeGender(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'male' || normalized == 'm') return 'male';
    if (normalized == 'female' || normalized == 'f') return 'female';
    return null;
  }

  int? _ageFromDateOfBirth(String rawDob) {
    final value = rawDob.trim();
    if (value.isEmpty) return null;
    final dob = DateTime.tryParse(value);
    if (dob == null) return null;
    final now = DateTime.now();
    var age = now.year - dob.year;
    final hasHadBirthday =
        now.month > dob.month ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hasHadBirthday) age -= 1;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSelection = selectedSurgery;

    return AppScaffoldGradient(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 8.h, 12.w, 16.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF061E40),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Surgery Booking',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 40.w),
              ],
            ),
          ),
          AppScaffoldGradientPanel(
            topBorderRadius: 28.r,
            child: Column(
              children: [
                Expanded(
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 20.h),
                          children: [
                            Text(
                              'Patient Details',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 14.h),
                            SurgeryDoctorSummaryWidget(
                              doctorName: widget.doctorName,
                              speciality: widget.speciality,
                              experience: widget.experience,
                              qualifications: widget.qualifications,
                              hospitalName: widget.hospitalName,
                              procedureName: widget.procedureName,
                              price: widget.price,
                              oldPrice: widget.oldPrice,
                              imageUrl: widget.imageUrl,
                              partnerLogoUrl: widget.partnerLogoUrl,
                            ),
                            SizedBox(height: 20.h),
                            SurgeryTextInputFieldWidget(
                              title: 'Patient Name',
                              hintText: 'Patient Name',
                              controller: patientNameController,
                              keyboardType: TextInputType.name,
                              hasError: showNameError,
                              errorText: 'Enter patient name',
                            ),
                            SizedBox(height: 14.h),
                            SurgeryTextInputFieldWidget(
                              title: 'Age',
                              hintText: 'Patient Age',
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              hasError: showAgeError,
                              errorText: 'Enter patient age',
                            ),
                            SizedBox(height: 14.h),
                            SurgeryGenderFieldWidget(
                              selectedGender: selectedGender,
                              hasError: showGenderError,
                              onTap: _showGenderPicker,
                            ),
                            SizedBox(height: 14.h),
                            SurgeryTextInputFieldWidget(
                              title: 'Contact Number',
                              hintText: 'Patient Contact Number',
                              controller: contactNumberController,
                              keyboardType: TextInputType.phone,
                              hasError: showContactError,
                              errorText: 'Enter contact number',
                            ),
                            SizedBox(height: 14.h),
                            SurgeryTextInputFieldWidget(
                              title: 'Emergency Contact',
                              hintText: 'Patient Emergency Contact',
                              controller: emergencyContactController,
                              keyboardType: TextInputType.phone,
                              hasError: showEmergencyError,
                              errorText: 'Enter Phone Number',
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              'Surgery',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            if (currentSelection != null)
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: isLoadingSurgeryTypes
                                    ? null
                                    : _openSurgeryTypeDialog,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Color(0xFFF1F1F1),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          currentSelection.name,
                                          style:
                                              theme.textTheme.bodyLarge?.copyWith(
                                            color: const Color(0xFF061E40),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (isLoadingSurgeryTypes)
                                        SizedBox(
                                          width: 16.r,
                                          height: 16.r,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else ...[
                                        Text(
                                          currentSelection.price,
                                          style:
                                              theme.textTheme.bodyLarge?.copyWith(
                                            color: const Color(0xFF061E40),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Transform.scale(
                                          scale: 1.2,
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: const Color(0xFFB6BDC8),
                                            size: 14.r,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 20,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (validationBannerMessage != null)
                              SurgeryFormErrorBannerWidget(
                                message: validationBannerMessage!,
                              ),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: isSubmittingBooking ||
                                        currentSelection == null
                                    ? null
                                    : _onProceedCheckoutPressed,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF0FAA9A),
                                  minimumSize: Size.fromHeight(44.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: isSubmittingBooking
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Proceed Checkout',
                                        style:
                                            theme.textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showGenderPicker() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.commonMale),
                onTap: () => Navigator.of(sheetContext).pop('male'),
              ),
              ListTile(
                title: Text(l10n.commonFemale),
                onTap: () => Navigator.of(sheetContext).pop('female'),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedGender = picked;
        showGenderError = false;
        validationBannerMessage = null;
      });
    }
  }

  Future<void> _openSurgeryTypeDialog() async {
    if (selectedSurgery == null || isLoadingSurgeryTypes) return;

    FocusScope.of(context).unfocus();
    setState(() => isLoadingSurgeryTypes = true);

    final result = await context.read<SurgeryCubit>().loadSurgeryProviderDetails(
      surgeryId: widget.surgeryId,
      cityId: widget.cityId,
      doctorId: widget.doctorId,
    );

    if (!mounted) return;
    setState(() => isLoadingSurgeryTypes = false);

    final options = result.fold(
      (_) => <SurgeryOption>[],
      (details) => details.packages
          .map(
            (item) => SurgeryOption(
              id: item.packageId,
              name: item.packageName,
              price: item.price,
              oldPrice: item.oldPrice,
              hospitalName: item.hospitalName,
            ),
          )
          .toList(),
    );

    if (options.isEmpty) {
      _showSurgeryTypesLoadFailedSnackbar();
      return;
    }

    final picked = await showDialog<SurgeryOption>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return SurgeryTypeDialogWidget(
          options: options,
          selected: selectedSurgery!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedSurgery = picked);
    }
  }

  void _showSurgeryTypesLoadFailedSnackbar() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Unable to load surgery types. Please try again.'),
        ),
      );
  }

  Future<void> _onProceedCheckoutPressed() async {
    final l10n = AppLocalizations.of(context)!;
    final name = patientNameController.text.trim();
    final age = ageController.text.trim();
    final contact = contactNumberController.text.trim();
    final emergency = emergencyContactController.text.trim();
    final gender = selectedGender ?? '';

    final nameMissing = name.isEmpty;
    final ageMissing = age.isEmpty;
    final genderMissing = gender.isEmpty;
    final contactMissing = contact.isEmpty;
    final emergencyMissing = emergency.isEmpty;

    if (nameMissing ||
        ageMissing ||
        genderMissing ||
        contactMissing ||
        emergencyMissing) {
      setState(() {
        showNameError = nameMissing;
        showAgeError = ageMissing;
        showGenderError = genderMissing;
        showContactError = contactMissing;
        showEmergencyError = emergencyMissing;
        validationBannerMessage = emergencyMissing
            ? l10n.surgeryEmergencyContactRequired
            : l10n.surgeryPatientValidationMessage;
      });
      return;
    }

    final surgery = selectedSurgery;
    if (surgery == null) return;

    setState(() {
      showNameError = false;
      showAgeError = false;
      showGenderError = false;
      showContactError = false;
      showEmergencyError = false;
      validationBannerMessage = null;
      isSubmittingBooking = true;
    });

    try {
      final result = await context.read<SurgeryCubit>().submitSurgeryBooking(
        patientName: name,
        age: age,
        contactNumber: contact,
        emergencyContact: emergency,
        surgeryName: surgery.name,
        doctorName: widget.doctorName,
        hospitalName: surgery.hospitalName.isNotEmpty
            ? surgery.hospitalName
            : widget.hospitalName,
        gender: gender,
      );

      if (!mounted) return;
      result.fold(
        (_) => _showSubmitFailedSnackbar(),
        (_) => _showBookingSubmittedDialog(),
      );
    } catch (_) {
      if (!mounted) return;
      _showSubmitFailedSnackbar();
    } finally {
      if (mounted) {
        setState(() => isSubmittingBooking = false);
      }
    }
  }

  Future<void> _showBookingSubmittedDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 17.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60.r,
                  height: 60.r,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF8DD57C),
                    size: 60.r,
                  ),
                ),
                SizedBox(height: 22.h),
                Text(
                  'Booking Request Submitted',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    height: 1.02,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your surgery request has been received. Our representative '
                  'will contact you within 24 hours to gather your medical '
                  'history and relevant details for confirmation.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 16.sp,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      dialogContext.pop();
                      if (mounted) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0FAA9A),
                      minimumSize: Size.fromHeight(54.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSubmitFailedSnackbar() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Unable to submit booking request. Please try again.'),
        ),
      );
  }
}
