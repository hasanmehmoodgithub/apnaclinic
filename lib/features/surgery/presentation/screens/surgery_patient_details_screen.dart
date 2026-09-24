import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_patient_details_cubit.dart';
import '../cubit/surgery_patient_details_state.dart';
import '../surgery_analytics.dart';
import '../widgets/surgery_booking_failed_dialog.dart';
import '../widgets/surgery_booking_submitted_dialog.dart';
import '../widgets/surgery_doctor_summary_widget.dart';
import '../widgets/surgery_option.dart';
import '../widgets/surgery_patient_details_bottom_bar_widget.dart';
import '../widgets/surgery_patient_details_form_section_widget.dart';
import '../widgets/surgery_patient_details_header_widget.dart';
import '../widgets/surgery_patient_details_package_field_widget.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SurgeryAnalytics.logCheckout(
        surgeryName: widget.procedureName,
        doctorId: widget.doctorId,
        doctorName: widget.doctorName,
      );
      final cubit = context.read<SurgeryPatientDetailsCubit>();
      final name = cubit.prefillFullName();
      final phone = cubit.prefillPhone();
      final age = cubit.prefillAge();
      if (name != null) patientNameController.text = name;
      if (phone != null) contactNumberController.text = phone;
      if (age != null) ageController.text = age;

      cubit.initialize(
        surgeryId: widget.surgeryId,
        cityId: widget.cityId,
        doctorId: widget.doctorId,
        initialPackage: SurgeryOption(
          id: '',
          name: widget.procedureName,
          price: widget.price,
          oldPrice: widget.oldPrice,
          hospitalName: widget.hospitalName,
        ),
      );
    });
  }

  @override
  void dispose() {
    patientNameController.dispose();
    ageController.dispose();
    contactNumberController.dispose();
    emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<SurgeryPatientDetailsCubit, SurgeryPatientDetailsState>(
      listenWhen: (previous, current) =>
          previous.bookingSubmitted != current.bookingSubmitted ||
          previous.packagesLoadFailed != current.packagesLoadFailed ||
          previous.errorMessage != current.errorMessage ||
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        final cubit = context.read<SurgeryPatientDetailsCubit>();

        if (state.bookingSubmitted) {
          SurgeryAnalytics.logBooked(
            bookingId: state.bookingId,
            userName: patientNameController.text.trim(),
            msisdn: contactNumberController.text.trim(),
            surgeryName: (state.selectedPackage?.name ?? widget.procedureName)
                .trim(),
            doctorName: widget.doctorName,
            amount: SurgeryAnalytics.amountFromPrice(
              state.selectedPackage?.price ?? widget.price,
            ),
          );
          cubit.clearTransientMessages();
          showSurgeryBookingSubmittedDialog(context);
          return;
        }

        if (state.packagesLoadFailed) {
          cubit.clearTransientMessages();
          _showSnackBar(l10n.surgeryTypesLoadFailed);
          return;
        }

        final error = state.errorMessage;
        if (error != null &&
            error.isNotEmpty &&
            state.submitStatus == StateStatus.error) {
          cubit.clearTransientMessages();
          showSurgeryBookingFailedDialog(context, message: error);
        }
      },
      child: AppScaffoldGradient(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SurgeryPatientDetailsHeaderWidget(),
              AppScaffoldGradientPanel(
                topBorderRadius: 28.r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                      children: [
                        Text(
                          l10n.surgeryPatientDetailsTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.clr061E40,
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
                        BlocBuilder<SurgeryPatientDetailsCubit,
                            SurgeryPatientDetailsState>(
                          buildWhen: (previous, current) =>
                              previous.selectedGender !=
                                  current.selectedGender ||
                              previous.showNameError != current.showNameError ||
                              previous.showAgeError != current.showAgeError ||
                              previous.showGenderError !=
                                  current.showGenderError ||
                              previous.showContactError !=
                                  current.showContactError ||
                              previous.showEmergencyError !=
                                  current.showEmergencyError,
                          builder: (context, state) {
                            return SurgeryPatientDetailsFormSectionWidget(
                              patientNameController: patientNameController,
                              ageController: ageController,
                              contactNumberController:
                                  contactNumberController,
                              emergencyContactController:
                                  emergencyContactController,
                              selectedGender: state.selectedGender,
                              showNameError: state.showNameError,
                              showAgeError: state.showAgeError,
                              showGenderError: state.showGenderError,
                              showContactError: state.showContactError,
                              showEmergencyError: state.showEmergencyError,
                              onGenderTap: _showGenderPicker,
                            );
                          },
                        ),
                        SizedBox(height: 14.h),
                        BlocBuilder<SurgeryPatientDetailsCubit,
                            SurgeryPatientDetailsState>(
                          buildWhen: (previous, current) =>
                              previous.selectedPackage !=
                                  current.selectedPackage ||
                              previous.isLoadingPackages !=
                                  current.isLoadingPackages,
                          builder: (context, state) {
                            final selected = state.selectedPackage;
                            if (selected == null) {
                              return const SizedBox.shrink();
                            }
                            return SurgeryPatientDetailsPackageFieldWidget(
                              selected: selected,
                              isLoading: state.isLoadingPackages,
                              onTap: state.isLoadingPackages
                                  ? null
                                  : _openSurgeryTypeDialog,
                            );
                          },
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                  BlocBuilder<SurgeryPatientDetailsCubit,
                      SurgeryPatientDetailsState>(
                    buildWhen: (previous, current) =>
                        previous.isSubmitting != current.isSubmitting ||
                        previous.selectedPackage != current.selectedPackage ||
                        previous.validationFailure != current.validationFailure,
                    builder: (context, state) {
                      return SurgeryPatientDetailsBottomBarWidget(
                        isSubmitting: state.isSubmitting,
                        canSubmit: state.selectedPackage != null,
                        validationBannerMessage:
                            _bannerMessage(l10n, state.validationFailure),
                        onProceed: _onProceedCheckoutPressed,
                      );
                    },
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  String? _bannerMessage(
    AppLocalizations l10n,
    SurgeryPatientValidationFailure? failure,
  ) {
    return switch (failure) {
      SurgeryPatientValidationFailure.emergencyRequired =>
        l10n.surgeryEmergencyContactRequired,
      SurgeryPatientValidationFailure.phoneInvalid => l10n.surgeryPhoneInvalid,
      SurgeryPatientValidationFailure.ageInvalid => l10n.surgeryAgeInvalid,
      SurgeryPatientValidationFailure.requiredFields =>
        l10n.surgeryPatientValidationMessage,
      null => null,
    };
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
                onTap: () => sheetContext.pop('male'),
              ),
              ListTile(
                title: Text(l10n.commonFemale),
                onTap: () => sheetContext.pop('female'),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null && mounted) {
      context.read<SurgeryPatientDetailsCubit>().selectGender(picked);
    }
  }

  Future<void> _openSurgeryTypeDialog() async {
    final cubit = context.read<SurgeryPatientDetailsCubit>();
    final selected = cubit.state.selectedPackage;
    if (selected == null || cubit.state.isLoadingPackages) return;

    FocusScope.of(context).unfocus();
    final options = await cubit.loadPackages(notifyOnFailure: true);
    if (!mounted) return;

    if (options.isEmpty) return;

    final picked = await showDialog<SurgeryOption>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return SurgeryTypeDialogWidget(
          options: options,
          selected: cubit.state.selectedPackage ?? selected,
        );
      },
    );

    if (picked != null && mounted) {
      cubit.selectPackage(picked);
    }
  }

  void _onProceedCheckoutPressed() {
    context.read<SurgeryPatientDetailsCubit>().submit(
          patientName: patientNameController.text.trim(),
          age: ageController.text.trim(),
          phone: contactNumberController.text.trim(),
          emergencyPhone: emergencyContactController.text.trim(),
        );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
