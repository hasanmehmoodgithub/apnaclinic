import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../generated/assets.dart';
import '../../../bookings/presentation/widgets/payment_method_sheet.dart';
import '../../../consultation/data/utils/consultation_booking_utils.dart';
import '../../../consultation/domain/use_cases/get_payment_providers_use_case.dart';
import '../../../consultation/presentation/models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../../consultation/presentation/widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../../domain/use_cases/book_lab_test_use_case.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_checkout_bottom_bar_widget.dart';
import '../widgets/lab_test_checkout_header_widget.dart';
import '../widgets/lab_test_checkout_patient_form_section_widget.dart';
import '../widgets/lab_test_checkout_payment_breakdown_card_widget.dart';
import '../widgets/lab_test_checkout_summary_card_widget.dart';
import '../widgets/lab_test_figma_image.dart';

/// Checkout + patient details (Figma node `2303:63721`). Success overlay matches `2303:64679`.
class LabTestCheckoutScreen extends StatefulWidget {
  const LabTestCheckoutScreen({super.key, required this.args});

  final LabTestCheckoutArgs args;

  @override
  State<LabTestCheckoutScreen> createState() => _LabTestCheckoutScreenState();
}

class _LabTestCheckoutScreenState extends State<LabTestCheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _emergencyController = TextEditingController();
  final AppPref _appPref = sl<AppPref>();
  String _gender = 'male';
  bool _isEditingPatientDetails = false;
  bool _isBooking = false;
  String? _checkoutErrorMessage;

  @override
  void initState() {
    super.initState();
    _prefillPatientDetailsFromSavedProfile();
    _emergencyController.addListener(_onEmergencyChanged);
  }

  @override
  void dispose() {
    _emergencyController.removeListener(_onEmergencyChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  void _onEmergencyChanged() {
    if (_checkoutErrorMessage != null &&
        _emergencyController.text.trim().isNotEmpty) {
      setState(() => _checkoutErrorMessage = null);
    }
  }

  void _prefillPatientDetailsFromSavedProfile() {
    if (!AuthGuard.isLoggedIn(_appPref)) return;
    final user = _appPref.getUserLocalModel();
    if (user == null) return;

    final fullName = '${user.firstName} ${user.lastName}'.trim();
    if (fullName.isNotEmpty) {
      _nameController.text = fullName;
    }

    final phone = user.phone.trim();
    if (phone.isNotEmpty) {
      _phoneController.text = phone;
    }

    final normalizedGender = _normalizeGender(user.gender);
    if (normalizedGender != null) {
      _gender = normalizedGender;
    }

    final age = _ageFromDateOfBirth(user.dateOfBirth);
    if (age != null && age > 0) {
      _ageController.text = age.toString();
    }
  }

  String? _normalizeGender(String rawGender) {
    final value = rawGender.trim().toLowerCase();
    if (value.isEmpty) return null;
    if (value == 'female' || value == 'f') return 'female';
    if (value == 'male' || value == 'm') return 'male';
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

  Future<void> _onProceed() async {
    if (_isBooking) return;
    final l10n = AppLocalizations.of(context)!;
    if (_emergencyController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty) {
      setState(() => _checkoutErrorMessage = l10n.labTestCheckoutRequiredFieldsError);
      return;
    }
    if (widget.args.testIds.isEmpty) {
      setState(() => _checkoutErrorMessage = l10n.labTestCheckoutRequiredFieldsError);
      return;
    }
    if (_checkoutErrorMessage != null) {
      setState(() => _checkoutErrorMessage = null);
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const PaymentMethodSheet(
        module: PaymentProviderModule.lab,
      ),
    );
    if (!mounted || selected == null) return;

    final paymentMethod = ConsultationBookingUtils.paymentMethodApiValue(selected);
    final String? msisdn;
    if (ConsultationBookingUtils.isJazzCashPayment(paymentMethod)) {
      msisdn = await _resolveJazzCashMsisdn();
    } else {
      msisdn = _resolveFallbackMsisdn();
    }
    if (!mounted || msisdn == null || msisdn.isEmpty) return;

    await _bookLabTest(
      paymentMethod: paymentMethod,
      msisdn: PhoneFormatUtils.toLocalDisplay(msisdn),
    );
  }

  Future<String?> _resolveJazzCashMsisdn() async {
    final result =
        await showModalBottomSheet<DoctorConsultationJazzCashSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DoctorConsultationJazzCashAccountsSheetWidget(),
    );
    return result?.msisdn.trim();
  }

  String _resolveFallbackMsisdn() {
    final fromPatient = _phoneController.text.trim();
    if (fromPatient.isNotEmpty) return fromPatient;
    return _appPref.getUserLocalModel()?.phone.trim() ?? '';
  }

  Future<void> _bookLabTest({
    required String paymentMethod,
    required String msisdn,
  }) async {
    final args = widget.args;
    setState(() => _isBooking = true);

    final result = await sl<BookLabTestUseCase>()(
      BookLabTestParams(
        partnerId: args.partnerId,
        labId: args.labId,
        cityName: args.city,
        homeSample: args.bookingMethodIsHomeSample,
        paymentMethod: paymentMethod,
        msisdn: msisdn,
        patient: BookLabTestPatientParams(
          name: _nameController.text.trim(),
          age: _ageController.text.trim(),
          gender: _gender == 'female' ? 'Female' : 'Male',
          phoneNumber: _phoneController.text.trim(),
        ),
        testIds: args.testIds,
      ),
    );

    if (!mounted) return;
    setState(() => _isBooking = false);

    result.fold(
      (error) => setState(() => _checkoutErrorMessage = error),
      (_) => _showBookedDialog(),
    );
  }

  void _showBookedDialog() {
    final l10n = AppLocalizations.of(context)!;
    final code = widget.args.discountCode;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              color: const Color(0xFFF3F4F7),
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 380,
                  maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.82,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LabTestFigmaImage(
                        url: Assets.labTestBookingConfirmationGreenCheck,
                        width: 60,
                        height: 60,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.labTestCheckoutBookedTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF0E2650),
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.labTestCheckoutBookedMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF5676A8),
                          fontSize: 14.sp,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.labTestCheckoutBookedPathHint,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF0D1218),
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.labTestDiscountIcon,
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0D1218),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.labTestDiscountCodeLabel,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: const Color(0xFF0D1218),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                              ),
                            ),
                            Text(
                              code,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF22185F),
                                    fontSize: 16.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 66,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF20A99D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                          ),
                          onPressed: () {
                            dialogContext.pop();
                            context.go(AppRoutes.path(AppRoutes.home));
                          },
                          child: Text(l10n.commonClose),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final a = widget.args;

    return AppScaffoldGradient(
      child: Column(
        children: [
          LabTestCheckoutHeaderWidget(title: l10n.labTestCheckoutTitle),
          AppScaffoldGradientPanel(
            topBorderRadius: 20.r,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabTestCheckoutSummaryCardWidget(args: a),
                        SizedBox(height: 18.h),
                        LabTestCheckoutPaymentBreakdownCardWidget(args: a),
                        SizedBox(height: 18.h),
                        LabTestCheckoutPatientFormSectionWidget(
                          theme: theme,
                          nameController: _nameController,
                          phoneController: _phoneController,
                          ageController: _ageController,
                          emergencyController: _emergencyController,
                          gender: _gender,
                          onGender: (g) => setState(() => _gender = g),
                          isEditingPatientDetails: _isEditingPatientDetails,
                          onToggleEdit: () => setState(
                            () => _isEditingPatientDetails =
                                !_isEditingPatientDetails,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                LabTestCheckoutBottomBarWidget(
                  onProceed: _onProceed,
                  errorMessage: _checkoutErrorMessage,
                  isBusy: _isBooking,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
