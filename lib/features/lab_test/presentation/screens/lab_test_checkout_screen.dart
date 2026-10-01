import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../promo_code/domain/entities/promo_code_service.dart';
import '../../../promo_code/presentation/cubit/promo_code_cubit.dart';
import '../../../promo_code/presentation/cubit/promo_code_state.dart';
import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../../domain/use_cases/book_lab_test_use_case.dart';
import '../../domain/use_cases/abandon_lab_test_booking_use_case.dart';
import '../../domain/utils/lab_test_price_formatter.dart';
import '../cubit/lab_test_cart_cubit.dart';
import '../lab_test_analytics.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_booking_confirmation_dialog_widget.dart';
import '../widgets/lab_test_cart_item_tile_widget.dart';
import '../widgets/lab_test_checkout_address_card_widget.dart';
import '../widgets/lab_test_checkout_bottom_bar_widget.dart';
import '../widgets/lab_test_checkout_header_widget.dart';
import '../widgets/lab_test_checkout_patient_form_section_widget.dart';
import '../widgets/lab_test_checkout_payment_breakdown_card_widget.dart';

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
  final _addressController = TextEditingController();
  final _emergencyController = TextEditingController();
  final AppPref _appPref = sl<AppPref>();
  String _gender = 'male';
  String _profileAddress = '';
  LabTestCheckoutAddressSource _addressSource =
      LabTestCheckoutAddressSource.savedFromProfile;
  bool _isEditingPatientDetails = false;
  bool _isBooking = false;
  bool _showAddressError = false;
  bool _showEmergencyError = false;
  String? _checkoutErrorMessage;

  @override
  void initState() {
    super.initState();
    _prefillPatientDetailsFromSavedProfile();
    _addressController.addListener(_onAddressChanged);
    _emergencyController.addListener(_onEmergencyChanged);
    _ageController.addListener(_onAgeChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      LabTestAnalytics.logCheckout();
    });
  }

  @override
  void dispose() {
    closePaymentProcessingLoader(_bookLoaderId);
    _addressController.removeListener(_onAddressChanged);
    _emergencyController.removeListener(_onEmergencyChanged);
    _ageController.removeListener(_onAgeChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  /// Patient card stays hidden while the Add Patient sheet data is complete.
  bool get _hasCompletePatientDetails {
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    return _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        age > 0 &&
        age <= 99;
  }

  void _onAddressChanged() {
    final address = _addressController.text.trim();
    final shouldClearBanner =
        _checkoutErrorMessage != null && address.isNotEmpty;
    final shouldClearFieldError = _showAddressError && address.isNotEmpty;
    if (!shouldClearBanner && !shouldClearFieldError) return;
    setState(() {
      if (shouldClearBanner) _checkoutErrorMessage = null;
      if (shouldClearFieldError) _showAddressError = false;
    });
  }

  void _onAddressSourceChanged(LabTestCheckoutAddressSource source) {
    if (_addressSource == source) return;
    setState(() {
      _addressSource = source;
      if (source == LabTestCheckoutAddressSource.savedFromProfile) {
        _addressController.text = _profileAddress;
      } else {
        _addressController.clear();
      }
      _showAddressError = false;
      if (_checkoutErrorMessage != null &&
          _addressController.text.trim().isNotEmpty) {
        _checkoutErrorMessage = null;
      }
    });
  }

  void _onEmergencyChanged() {
    final emergency = _emergencyController.text.trim();
    final shouldClearBanner =
        _checkoutErrorMessage != null && emergency.isNotEmpty;
    final shouldClearFieldError = _showEmergencyError &&
        emergency.isNotEmpty &&
        PhoneFormatUtils.isValidMobileOrLandline(emergency);
    if (!shouldClearBanner && !shouldClearFieldError) return;
    setState(() {
      if (shouldClearBanner) _checkoutErrorMessage = null;
      if (shouldClearFieldError) _showEmergencyError = false;
    });
  }

  void _onAgeChanged() {
    if (_checkoutErrorMessage == null) return;
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    if (age > 0 && age <= 99) {
      setState(() => _checkoutErrorMessage = null);
    }
  }

  void _prefillPatientDetailsFromSavedProfile() {
    if (AuthGuard.isLoggedIn(_appPref)) {
      final user = _appPref.getUserLocalModel();
      if (user != null) {
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
        if (age != null && age > 0 && age <= 99) {
          _ageController.text = age.toString();
        }

        _profileAddress = user.address.trim();
        if (_profileAddress.isNotEmpty) {
          _addressController.text = _profileAddress;
          _addressSource = LabTestCheckoutAddressSource.savedFromProfile;
        } else {
          _addressSource = LabTestCheckoutAddressSource.different;
        }
      }
    }

    final cartName = widget.args.patientName.trim();
    if (cartName.isNotEmpty) {
      _nameController.text = cartName;
    }
    final cartAge = int.tryParse(widget.args.patientAge.trim()) ?? 0;
    if (cartAge > 0 && cartAge <= 99) {
      _ageController.text = cartAge.toString();
    }
    final cartGender = _normalizeGender(widget.args.patientGender);
    if (cartGender != null) {
      _gender = cartGender;
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
        _addressController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty) {
      setState(() {
        _checkoutErrorMessage = l10n.labTestCheckoutRequiredFieldsError;
        _showAddressError = _addressController.text.trim().isEmpty;
        _showEmergencyError = _emergencyController.text.trim().isEmpty;
      });
      return;
    }
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    if (age <= 0 || age > 99) {
      setState(() {
        _checkoutErrorMessage = l10n.labTestAgeInvalid;
        _showAddressError = false;
        _showEmergencyError = false;
      });
      return;
    }
    if (!PhoneFormatUtils.isValidMobileOrLandline(
      _emergencyController.text.trim(),
    )) {
      setState(() {
        _checkoutErrorMessage = l10n.labTestCheckoutPhoneInvalid;
        _showAddressError = false;
        _showEmergencyError = true;
      });
      return;
    }
    if (widget.args.testIds.isEmpty) {
      setState(() {
        _checkoutErrorMessage = l10n.labTestCheckoutRequiredFieldsError;
        _showAddressError = false;
        _showEmergencyError = false;
      });
      return;
    }
    if (_checkoutErrorMessage != null ||
        _showEmergencyError ||
        _showAddressError) {
      setState(() {
        _checkoutErrorMessage = null;
        _showEmergencyError = false;
        _showAddressError = false;
      });
    }

    final promoCubit = context.read<PromoCodeCubit>();
    final discountedAmount = LabTestPriceFormatter.parseRsAmount(
      widget.args.totalAmount.trim().isNotEmpty
          ? widget.args.totalAmount
          : widget.args.discountedFee,
    );
    final promoOk = await promoCubit.ensureValidated(
      service: PromoCodeService.lab,
      amount: discountedAmount,
    );
    if (!promoOk || !mounted) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const PaymentMethodSheet(
        module: PaymentProviderModule.labTesting,
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
    final isJazzCash =
        ConsultationBookingUtils.isJazzCashPayment(paymentMethod);
    setState(() => _isBooking = true);
    showPaymentProcessingLoader(
      context,
      id: _bookLoaderId,
      isJazzCash: isJazzCash,
    );

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
          address: _addressController.text.trim(),
        ),
        testIds: args.testIds,
        promoCode: context.read<PromoCodeCubit>().state.appliedCode,
      ),
    );

    closePaymentProcessingLoader(_bookLoaderId);
    if (!mounted) return;
    setState(() => _isBooking = false);

    await result.fold(
      (error) async {
        await _showBookErrorDialog(error);
      },
      (initiation) async {
        if (initiation.hasBlockingOrder) {
          if (!mounted) return;
          final l10n = AppLocalizations.of(context)!;
          final blocking = initiation.blockingOrder;
          final apiMessage = blocking?.message?.trim() ?? '';
          final abandonOrderId = initiation.abandonPublicId ?? '';
          final canAbandon =
              blocking?.canAbandon == true && abandonOrderId.isNotEmpty;
          await showPaymentPendingDialog(
            context,
            title: l10n.labTestCheckoutPaymentPendingTitle,
            message: apiMessage.isNotEmpty
                ? apiMessage
                : l10n.labTestCheckoutPaymentPendingMessage,
            onViewBookings: _goToLabBookingsFromDialog,
            secondaryLabel:
                canAbandon ? l10n.labTestAbandonUnpaidOrderCta : null,
            onSecondary: canAbandon
                ? (dialogContext) => _abandonUnpaidBooking(
                      dialogContext: dialogContext,
                      publicId: abandonOrderId,
                    )
                : null,
          );
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
          await showCardPaymentOutcomeDialog(
            context,
            paymentResult,
            onViewBookings: _goToLabBookingsFromDialog,
          );
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
      appliedPromoCode: context.read<PromoCodeCubit>().state.appliedCode,
      address: _addressController.text.trim(),
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

  Future<void> _abandonUnpaidBooking({
    required BuildContext dialogContext,
    required String publicId,
  }) async {
    if (dialogContext.canPop()) dialogContext.pop();
    if (!mounted) return;

    const loaderId = 'lab_test_abandon_order_loader';
    final l10n = AppLocalizations.of(context)!;
    showHeartLoaderDialog(context, id: loaderId, size: 120);
    final result = await sl<AbandonLabTestBookingUseCase>()(
      AbandonLabTestBookingParams(orderId: publicId),
    );
    HeartLoaderDialogController.close(loaderId);
    if (!mounted) return;

    await result.fold(
      (error) async {
        final message = error.trim().isNotEmpty
            ? error.trim()
            : l10n.labTestAbandonUnpaidOrderFailed;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      (_) async {},
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
                          LabTestCartItemTileWidget(
                            testTitle: a.lines[i].testTitle,
                            labLogoUrl: a.lines[i].labLogoUrl,
                            partnerName: a.lines[i].partnerName,
                            partnerLogoUrl: a.lines[i].partnerLogoUrl,
                            sampleType: a.lines[i].sampleType,
                            requirementLabel: a.lines[i].requirementLabel,
                          ),
                        ],
                        SizedBox(height: 12.h),
                        LabTestCheckoutPaymentBreakdownCardWidget(args: a),
                        SizedBox(height: 12.h),
                        LabTestCheckoutPatientFormSectionWidget(
                          theme: theme,
                          showPatientDetails: !_hasCompletePatientDetails,
                          nameController: _nameController,
                          phoneController: _phoneController,
                          ageController: _ageController,
                          addressController: _addressController,
                          addressSource: _addressSource,
                          onAddressSourceChanged: _onAddressSourceChanged,
                          emergencyController: _emergencyController,
                          gender: _gender,
                          onGender: (g) => setState(() => _gender = g),
                          isEditingPatientDetails: _isEditingPatientDetails,
                          showAddressError: _showAddressError,
                          showEmergencyError: _showEmergencyError,
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
                BlocBuilder<PromoCodeCubit, PromoCodeState>(
                  buildWhen: (previous, current) =>
                      previous.isValidating != current.isValidating,
                  builder: (context, promo) {
                    return LabTestCheckoutBottomBarWidget(
                      onProceed: _onProceed,
                      errorMessage: _checkoutErrorMessage,
                      isBusy: _isBooking || promo.isValidating,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
