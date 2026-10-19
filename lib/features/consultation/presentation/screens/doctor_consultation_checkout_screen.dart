import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../data/models/doctor_consultation_checkout_model.dart';
import '../../data/utils/consultation_booking_utils.dart';
import '../constants/consultation_system_ui.dart';
import '../constants/consultation_ui_config.dart';
import '../cubit/doctor_consultation_checkout_cubit.dart';
import '../cubit/doctor_consultation_checkout_state.dart';
import '../doctor_consultation_checkout_args.dart';
import '../doctor_consultation_summary_args.dart';
import '../../../pro/presentation/widgets/pro_service_offer_slot.dart';
import '../widgets/consultation_screen_header_widget.dart';
import '../widgets/doctor_consultation_checkout_billing_section_widget.dart';
import '../widgets/doctor_consultation_checkout_payment_method_tile_widget.dart';
import '../widgets/doctor_consultation_checkout_shimmer_widget.dart';
import '../widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../../../promo_code/presentation/cubit/promo_code_cubit.dart';
import '../../../promo_code/presentation/widgets/promo_code_field_widget.dart';
import '../../../promo_code/presentation/cubit/promo_code_state.dart';

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
  bool _isPro = false;
  final _proOfferKey = GlobalKey<ProServiceOfferSlotState>();

  void _onProChanged(bool isPro) {
    if (!mounted) return;
    context.read<PromoCodeCubit>().setIsPro(isPro);
    if (_isPro == isPro) return;
    setState(() => _isPro = isPro);
  }

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

    final checkoutData = state.data;
    if (checkoutData == null) return;

    if (!context.read<PromoCodeCubit>().allowCheckout()) return;

    final selectedOption = _selectedPaymentOption(state);
    if (ConsultationBookingUtils.isJazzCashPayment(
      selectedPaymentMethodCode,
      name: selectedOption?.name ?? '',
    )) {
      await _openJazzCashThenSummary(selectedPaymentMethodCode);
      return;
    }

    await _openSummaryForCard(selectedPaymentMethodCode);
  }

  Future<void> _openJazzCashThenSummary(String paymentMethodCode) async {
    final l10n = AppLocalizations.of(context)!;
    final result =
        await showModalBottomSheet<DoctorConsultationJazzCashSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DoctorConsultationJazzCashAccountsSheetWidget(),
    );
    if (result == null || !mounted) return;

    final msisdn = result.msisdn.trim();
    if (msisdn.isEmpty) return;

    final selectedOption = _selectedPaymentOption(
      context.read<DoctorConsultationCheckoutCubit>().state,
    );
    await _pushSummary(
      paymentMethodCode: paymentMethodCode,
      paymentMethodName: selectedOption?.name ?? l10n.accountMethodJazzCash,
      paymentMethodIconUrl: selectedOption?.iconUrl ?? '',
      accountNumber: PhoneFormatUtils.toLocalDisplay(msisdn),
      msisdn: msisdn,
    );
  }

  Future<void> _openSummaryForCard(String paymentMethodCode) async {
    final l10n = AppLocalizations.of(context)!;
    final selectedOption = _selectedPaymentOption(
      context.read<DoctorConsultationCheckoutCubit>().state,
    );
    final phone = sl<AppPref>().getUserLocalModel()?.phone.trim() ?? '';

    await _pushSummary(
      paymentMethodCode: paymentMethodCode,
      paymentMethodName: selectedOption?.name ?? l10n.pharmacyPaymentDebitCard,
      paymentMethodIconUrl: selectedOption?.iconUrl ?? '',
      accountNumber: l10n.consultationDiscountNotAvailable,
      msisdn: phone,
    );
  }

  Future<void> _pushSummary({
    required String paymentMethodCode,
    required String paymentMethodName,
    required String paymentMethodIconUrl,
    required String accountNumber,
    required String msisdn,
  }) async {
    final checkoutData =
        context.read<DoctorConsultationCheckoutCubit>().state.data;
    if (checkoutData == null || !mounted) return;

    final promo = context.read<PromoCodeCubit>().state;

    await context.pushNamed(
      AppRoutes.consultationSummary,
      extra: DoctorConsultationSummaryArgs(
        checkoutArgs: widget.args,
        paymentMethodCode: paymentMethodCode,
        paymentMethodName: paymentMethodName,
        paymentMethodIconUrl: paymentMethodIconUrl,
        accountNumber: accountNumber,
        msisdn: msisdn,
        consultationFee: checkoutData.consultationFee,
        discount: checkoutData.discount,
        total: promo.payableTotal(checkoutData.total),
        isPro: _isPro,
        promoCode: promo.appliedCode,
        promoDiscount: promo.isApplied ? promo.result!.discountAmount : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: consultationSystemUiOverlay,
      child: Scaffold(
      backgroundColor: AppColors.clrWhite,
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
          bottom: false,
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
                  child: SafeArea(
                    top: false,
                    bottom: false,
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
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  DoctorConsultationCheckoutBillingSectionWidget(
                                    data: data,
                                    isPro: _isPro,
                                    onProTap: () =>
                                        _proOfferKey.currentState?.openSheet(),
                                  ),
                                  SizedBox(height: 18.h),
                                  ProServiceOfferSlot(
                                    key: _proOfferKey,
                                    service: ProServiceOfferKind.consultation,
                                    upsellOnly: _isPro,
                                    onProChanged: _onProChanged,
                                  ),
                                  Text(
                                    l10n.consultationPaymentMethodTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColors.clr061E40,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  SizedBox(height: 10.h),
                                  ...List.generate(data.paymentOptions.length, (
                                    index,
                                  ) {
                                    final option = data.paymentOptions[index];
                                    final isSelected =
                                        state.selectedPaymentMethodId ==
                                            option.code;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: index ==
                                                data.paymentOptions.length - 1
                                            ? 0
                                            : 12.h,
                                      ),
                                      child:
                                          DoctorConsultationCheckoutPaymentMethodTileWidget(
                                        option: option,
                                        isSelected: isSelected,
                                        onTap: () =>
                                            _onPaymentMethodTap(option.code),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            BlocBuilder<PromoCodeCubit, PromoCodeState>(
                              buildWhen: (previous, current) =>
                                  previous.isValidating != current.isValidating,
                              builder: (context, promo) {
                                final isBusy =
                                    state.isSubmitting || promo.isValidating;
                                final canContinue =
                                    state.selectedPaymentMethodId != null &&
                                    !isBusy;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 56.h,
                                  child: Listener(
                                    behavior: HitTestBehavior.opaque,
                                    onPointerDown: (_) {
                                      if (canContinue) {
                                        PromoCodeFieldWidget.ignoreNextSubmit();
                                      }
                                    },
                                    child: FilledButton(
                                    onPressed: canContinue
                                        ? () => _onContinuePressed(state)
                                        : null,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.clr1FAFA3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    child: state.isSubmitting
                                        ? SizedBox(
                                            width: 22.r,
                                            height: 22.r,
                                            child:
                                                const CircularProgressIndicator(
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
                                                  color: AppColors.clrWhite,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17.sp,
                                                ),
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
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
}
