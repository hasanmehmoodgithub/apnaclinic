import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../../dashboard/presentation/constants/main_navigation_tabs.dart';
import '../../data/models/doctor_consultation_checkout_model.dart';
import '../../data/utils/consultation_booking_utils.dart';
import '../constants/consultation_ui_config.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../cubit/doctor_consultation_checkout_cubit.dart';
import '../cubit/doctor_consultation_checkout_state.dart';
import '../doctor_consultation_checkout_args.dart';
import '../doctor_consultation_summary_args.dart';
import '../widgets/consultation_booking_confirmation_dialog_widget.dart';
import '../widgets/doctor_consultation_checkout_billing_section_widget.dart';
import '../widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../widgets/doctor_consultation_checkout_payment_method_tile_widget.dart';
import '../widgets/doctor_consultation_checkout_shimmer_widget.dart';

class DoctorConsultationCheckoutScreen extends StatefulWidget {
  const DoctorConsultationCheckoutScreen({
    super.key,
    required this.args,
  });

  final DoctorConsultationCheckoutArgs args;

  @override
  State<DoctorConsultationCheckoutScreen> createState() =>
      _DoctorConsultationCheckoutScreenState();
}

class _DoctorConsultationCheckoutScreenState
    extends State<DoctorConsultationCheckoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorConsultationCheckoutCubit>().load(widget.args);
  }

  DoctorConsultationPaymentOptionModel? _selectedPaymentOption(
    DoctorConsultationCheckoutState state,
  ) {
    final code = state.selectedPaymentMethodId;
    final options = state.data?.paymentOptions ?? const [];
    if (code == null) return null;
    for (final option in options) {
      if (option.code == code) return option;
    }
    return null;
  }

  void _onPaymentMethodTap(String id) {
    context.read<DoctorConsultationCheckoutCubit>().selectPaymentMethod(id);
  }

  Future<void> _onContinuePressed(DoctorConsultationCheckoutState state) async {
    final selectedPaymentMethodCode = state.selectedPaymentMethodId;
    if (selectedPaymentMethodCode == null) return;

    final selectedOption = _selectedPaymentOption(state);
    if (ConsultationBookingUtils.isJazzCashPayment(
      selectedPaymentMethodCode,
      name: selectedOption?.name ?? '',
    )) {
      await _openJazzCashBottomSheet(selectedPaymentMethodCode);
      return;
    }

    final msisdn = sl<AppPref>().getUserLocalModel()?.phone ?? '';
    await _submitBooking(
      paymentMethodCode: selectedPaymentMethodCode,
      msisdn: msisdn,
    );
  }

  Future<void> _openJazzCashBottomSheet(String paymentMethodCode) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showModalBottomSheet<DoctorConsultationJazzCashSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DoctorConsultationJazzCashAccountsSheetWidget(),
    );
    if (result == null || !mounted) return;

    final msisdn = result.msisdn.trim();
    if (msisdn.isEmpty) return;

    final cubit = context.read<DoctorConsultationCheckoutCubit>();
    final checkoutData = cubit.state.data;
    if (checkoutData == null) return;

    final selectedOption = _selectedPaymentOption(cubit.state);
    if (!mounted) return;

    await context.pushNamed(
      AppRoutes.consultationSummary,
      extra: DoctorConsultationSummaryArgs(
        checkoutArgs: widget.args,
        paymentMethodCode: paymentMethodCode,
        paymentMethodName: selectedOption?.name ?? l10n.accountMethodJazzCash,
        accountNumber: PhoneFormatUtils.toLocalDisplay(msisdn),
        msisdn: msisdn,
        consultationFee: checkoutData.consultationFee,
        discount: checkoutData.discount,
        total: checkoutData.total,
      ),
    );
  }

  Future<void> _submitBooking({
    required String paymentMethodCode,
    required String msisdn,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<DoctorConsultationCheckoutCubit>();
    final success = await cubit.submitBooking(
      args: widget.args,
      paymentMethodCode: paymentMethodCode,
      msisdn: msisdn,
    );
    if (!mounted) return;

    if (!success) {
      final message = cubit.state.errorMessage;
      final displayMessage = switch (message) {
        'invalid_booking_context' => l10n.consultationBookingInvalidContextError,
        'missing_msisdn' => l10n.consultationBookingMissingMsisdnError,
        _ => (message != null && message.isNotEmpty)
            ? message
            : l10n.consultationBookingFailed,
      };
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(displayMessage)));
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ConsultationBookingConfirmationDialogWidget(
          doctorName: widget.args.doctorName,
          onOk: () {
            Navigator.of(dialogContext).pop();
            if (!mounted) return;
            sl<AuthSessionRefresh>().requestTabIndex(MainNavigationTabs.bookings);
            context.go(AppRoutes.path(AppRoutes.home));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFAEE3E3), Color(0xFFF5F7F8)],
            stops: [0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ConsultationScreenHeaderWidget(
                title: ConsultationUiConfig.screenTitle,
                onBackTap: () => context.pop(),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: widget.args.doctorImageUrl,
                    width: 188.w,
                    height: 160.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  ),
                  child: BlocBuilder<
                      DoctorConsultationCheckoutCubit,
                      DoctorConsultationCheckoutState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const DoctorConsultationCheckoutShimmerWidget();
                      }
                      if (state.hasError || state.data == null) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.errorMessage ?? l10n.consultationBookingFailed,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 12.h),
                                FilledButton(
                                  onPressed: () => context
                                      .read<DoctorConsultationCheckoutCubit>()
                                      .load(widget.args),
                                  child: Text(l10n.commonRetry),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final data = state.data!;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DoctorConsultationCheckoutBillingSectionWidget(data: data),
                            SizedBox(height: 18.h),
                            Text(
                              l10n.consultationPaymentMethodTitle,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF061E40),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: 10.h),
                            Expanded(
                              child: ListView.separated(
                                itemCount: data.paymentOptions.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 12.h),
                                itemBuilder: (context, index) {
                                  final option = data.paymentOptions[index];
                                  final isSelected =
                                      state.selectedPaymentMethodId == option.code;
                                  return DoctorConsultationCheckoutPaymentMethodTileWidget(
                                    option: option,
                                    isSelected: isSelected,
                                    onTap: () => _onPaymentMethodTap(option.code),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: FilledButton(
                                onPressed: state.selectedPaymentMethodId == null ||
                                        state.isSubmitting
                                    ? null
                                    : () => _onContinuePressed(state),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF1FAFA3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: state.isSubmitting
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        l10n.commonContinue,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17.sp,
                                            ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
