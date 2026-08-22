import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../bookings/presentation/constants/bookings_tabs.dart';
import '../../../bookings/presentation/widgets/alert_dialog_card.dart';
import '../../../bookings/presentation/widgets/payment_method_sheet.dart';
import '../../../consultation/data/utils/consultation_booking_utils.dart';
import '../../../consultation/domain/use_cases/get_payment_providers_use_case.dart';
import '../../../consultation/presentation/models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../../consultation/presentation/widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../../../dashboard/presentation/constants/main_navigation_tabs.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../../../payment/presentation/payment_navigation.dart';
import '../../../payment/presentation/widgets/payment_pending_dialog_widget.dart';
import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../../domain/use_cases/book_lab_test_use_case.dart';
import '../cubit/lab_test_cart_cubit.dart';
import '../lab_test_analytics.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_booking_confirmation_dialog_widget.dart';
import '../widgets/lab_test_checkout_bottom_bar_widget.dart';
import '../widgets/lab_test_checkout_header_widget.dart';
import '../widgets/lab_test_checkout_patient_form_section_widget.dart';
import '../widgets/lab_test_checkout_payment_breakdown_card_widget.dart';
import '../widgets/lab_test_checkout_summary_card_widget.dart';

/// Checkout + patient details (Figma node `2303:63721`). Success overlay matches `2303:64679`.
class LabTestCheckoutScreen extends StatefulWidget {
  const LabTestCheckoutScreen({super.key, required this.args});

  final LabTestCheckoutArgs args;

  @override
  State<LabTestCheckoutScreen> createState() => _LabTestCheckoutScreenState();
}

class _LabTestCheckoutScreenState extends State<LabTestCheckoutScreen> {
  static const _bookLoaderId = 'lab_test_checkout_book';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      LabTestAnalytics.logCheckout();
    });
  }

  @override
  void dispose() {
    HeartLoaderDialogController.close(_bookLoaderId);
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
    if (!PhoneFormatUtils.isValidMobileOrLandline(
      _emergencyController.text.trim(),
    )) {
      setState(() => _checkoutErrorMessage = l10n.labTestCheckoutPhoneInvalid);
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
        includeLocalCashOption: true,
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
    showHeartLoaderDialog(context, id: _bookLoaderId);

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

    HeartLoaderDialogController.close(_bookLoaderId);
    if (!mounted) return;
    setState(() => _isBooking = false);

    await result.fold(
      (error) async {
        _logBookingConfirmed(
          paymentMethod: paymentMethod,
          msisdn: msisdn,
          paymentStatus: AnalyticsPaymentStatusKeys.failed,
        );
        await _showBookErrorDialog(error);
      },
      (initiation) async {
        if (initiation.isPendingWithoutPaymentUrl) {
          await _clearLabCart();
          if (!mounted) return;
          _showPaymentPendingDialog();
          return;
        }

        // Same shared card WebView path as pharmacy checkout.
        // Lab allows closing the WebView with the AppBar X only.
        final paymentResult = await settleCardPaymentIfNeeded(
          context,
          initiation,
          allowClose: true,
        );
        if (!mounted) return;
        if (!paymentResult.isSuccess) {
          _logBookingConfirmed(
            paymentMethod: paymentMethod,
            msisdn: msisdn,
            paymentStatus: AnalyticsPaymentStatusKeys.failed,
            initiation: initiation,
          );
          showCardPaymentOutcomeSnackBar(context, paymentResult);
          return;
        }
        _logBookingConfirmed(
          paymentMethod: paymentMethod,
          msisdn: msisdn,
          paymentStatus: AnalyticsPaymentStatusKeys.successful,
          initiation: initiation,
        );
        await _clearLabCart();
        if (!mounted) return;
        _showBookedDialog();
      },
    );
  }

  void _logBookingConfirmed({
    required String paymentMethod,
    required String msisdn,
    required String paymentStatus,
    PaymentInitiationResult? initiation,
  }) {
    LabTestAnalytics.logBookingConfirmed(
      args: widget.args,
      paymentMethodCode: paymentMethod,
      userName: _nameController.text.trim(),
      msisdn: msisdn,
      paymentStatus: paymentStatus,
      initiation: initiation,
    );
  }

  Future<void> _showBookErrorDialog(String error) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final message = error.trim().isNotEmpty
        ? error.trim()
        : l10n.labTestSomethingWentWrong;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => AlertDialogCard(
        kind: AlertKind.error,
        title: l10n.labTestSomethingWentWrong,
        message: message,
      ),
    );
  }

  Future<void> _clearLabCart() async {
    await sl<LabTestCartRepository>().writeCart(
      const <LabTestCartItem>[],
    );
    sl<LabTestCartCubit>().replaceItems(const <LabTestCartItem>[]);
  }

  void _goToLabBookingsFromDialog(BuildContext dialogContext) {
    if (dialogContext.canPop()) dialogContext.pop();
    if (!mounted) return;
    sl<AuthSessionRefresh>().requestTabIndex(
      MainNavigationTabs.bookings,
      bookingsSubTabIndex: BookingsTabs.labTest,
    );
    context.go(AppRoutes.path(AppRoutes.home));
  }

  void _showPaymentPendingDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return PaymentPendingDialogWidget(
          title: l10n.labTestCheckoutPaymentPendingTitle,
          message: l10n.labTestCheckoutPaymentPendingMessage,
          ctaText: l10n.labTestCheckoutViewBookingsCta,
          onViewBookings: () => _goToLabBookingsFromDialog(dialogContext),
        );
      },
    );
  }

  void _showBookedDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return LabTestBookingConfirmationDialogWidget(
          onViewBookings: () => _goToLabBookingsFromDialog(dialogContext),
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
                        for (var i = 0; i < a.lines.length; i++) ...[
                          if (i > 0) SizedBox(height: 12.h),
                          LabTestCheckoutSummaryCardWidget(line: a.lines[i]),
                        ],
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
                          onToggleEdit: () {
                            if (!_isEditingPatientDetails) {
                              LabTestAnalytics.logPatientDetailsEdit();
                            }
                            setState(
                              () => _isEditingPatientDetails =
                                  !_isEditingPatientDetails,
                            );
                          },
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
