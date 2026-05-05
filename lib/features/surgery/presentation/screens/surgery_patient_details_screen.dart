import 'package:apnaclinic/core/widgets/app_scaffold_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../cubit/surgery_cubit.dart';
import '../widgets/surgery_doctor_summary_widget.dart';
import '../widgets/surgery_option.dart';
import '../widgets/surgery_text_input_field_widget.dart';
import '../widgets/surgery_type_dialog_widget.dart';

class SurgeryPatientDetailsScreen extends StatefulWidget {
  const SurgeryPatientDetailsScreen({
    super.key,
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

  late SurgeryOption selectedSurgery;
  bool showEmergencyError = false;
  bool isSubmittingBooking = false;

  late final TextEditingController patientNameController;
  late final TextEditingController ageController;
  late final TextEditingController contactNumberController;
  late final TextEditingController emergencyContactController;

  final List<SurgeryOption> options = const [
    SurgeryOption('Refractive Surgery', 'Rs. 65,000/-', 'Rs. 100,000/-'),
    SurgeryOption('Corneal transplant.', 'Rs. 65,000/-', 'Rs. 100,000/-'),
    SurgeryOption('Glaucoma surgery', 'Rs. 65,000/-', 'Rs. 100,000/-'),
    SurgeryOption('Trabeculectomy', 'Rs. 65,000/-', 'Rs. 100,000/-'),
  ];

  @override
  void initState() {
    super.initState();
    selectedSurgery = options.first;
    patientNameController = TextEditingController(text: "Haseeb Qasim");
    ageController = TextEditingController(text: "24");
    contactNumberController = TextEditingController(text: "0341-2211221");
    emergencyContactController = TextEditingController(text: "0341-2211221");
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

          // ---------- White rounded content area ----------
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28.r),
                ),
              ),
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
                        ),
                        SizedBox(height: 14.h),
                        SurgeryTextInputFieldWidget(
                          title: 'Age',
                          hintText: 'Patient Age',
                          controller: ageController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 14.h),
                        SurgeryTextInputFieldWidget(
                          title: 'Contact Number',
                          hintText: 'Patient Contact Number',
                          controller: contactNumberController,
                          keyboardType: TextInputType.phone,
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
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // ---------- Surgery picker (opens dialog on tap) ----------
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: _openSurgeryTypeDialog,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 14.h,
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
                                    selectedSurgery.name,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF061E40),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  selectedSurgery.price,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF061E40),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFFB6BDC8),
                                    size: 17.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),

                  // ---------- Bottom "Proceed Checkout" button ----------
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
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isSubmittingBooking
                            ? null
                            : _onProceedCheckoutPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0FAA9A),
                          minimumSize: Size.fromHeight(54.h),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                            : Text(
                          'Proceed Checkout',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.sp,
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
    );
  }

  // ======================= Surgery type dialog =======================
  Future<void> _openSurgeryTypeDialog() async {
    // Dismiss the keyboard if it's open so the dialog sits centered.
    FocusScope.of(context).unfocus();

    final picked = await showDialog<SurgeryOption>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return SurgeryTypeDialogWidget(
          options: options,
          selected: selectedSurgery,
        );
      },
    );

    if (picked != null && picked.name != selectedSurgery.name) {
      setState(() => selectedSurgery = picked);
    }
  }

  Future<void> _onProceedCheckoutPressed() async {
    final emergency = emergencyContactController.text.trim();
    if (emergency.isEmpty) {
      setState(() => showEmergencyError = true);
      _showEmergencyContactSnackbar();
      return;
    }

    setState(() {
      showEmergencyError = false;
      isSubmittingBooking = true;
    });

    try {
      final result = await context.read<SurgeryCubit>().submitSurgeryBooking(
        patientName: patientNameController.text.trim(),
        age: ageController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        emergencyContact: emergency,
        surgeryName: selectedSurgery.name,
        doctorName: widget.doctorName,
        hospitalName: widget.hospitalName,
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

  void _showEmergencyContactSnackbar() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 98.h),
          backgroundColor: const Color(0xFFFFF8F8),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Color(0xFFFFEBEA)),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16.r,
                color: const Color(0xFFBA2025),
              ),
              SizedBox(width: 8.w),
              Text(
                'Please add emergency contact number.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFBA2025),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
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