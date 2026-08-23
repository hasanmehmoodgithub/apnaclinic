import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/cities/presentation/show_select_city_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../consultation/data/utils/consultation_booking_utils.dart';
import '../../../consultation/presentation/models/doctor_consultation_jazzcash_sheet_result.dart';
import '../../../consultation/presentation/widgets/doctor_consultation_jazzcash_accounts_sheet_widget.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../../../payment/presentation/payment_navigation.dart';
import '../../../payment/presentation/widgets/payment_pending_dialog_widget.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_navigation.dart';
import 'pharmacy_checkout_notices_widget.dart';
import 'pharmacy_checkout_widgets.dart';
import 'pharmacy_error_dialog.dart';
import 'pharmacy_order_placed_dialog.dart';
import 'pharmacy_payment_option_tile.dart';

/// Checkout panel content and confirm action.
class PharmacyCheckoutBodyWidget extends StatelessWidget {
  const PharmacyCheckoutBodyWidget({
    super.key,
    required this.addressController,
    required this.specialInstructionsController,
  });

  final TextEditingController addressController;
  final TextEditingController specialInstructionsController;

  static const _checkoutLoaderId = 'pharmacy_checkout_loader';

  Future<void> _onConfirm(BuildContext context) async {
    final cubit = context.read<PharmacyCubit>();
    final paymentMethod =
        _paymentMethodApiValue(cubit.state.selectedPaymentMethod);
    String? jazzCashNumber;
    if (ConsultationBookingUtils.isJazzCashPayment(paymentMethod)) {
      jazzCashNumber = await _resolveJazzCashMsisdn(context);
      if (!context.mounted ||
          jazzCashNumber == null ||
          jazzCashNumber.isEmpty) {
        return;
      }
      jazzCashNumber = PhoneFormatUtils.toMsisdn(jazzCashNumber);
    }

    cubit.logConfirmPayment();

    showHeartLoaderDialog(context, id: _checkoutLoaderId, size: 120);
    final result = await cubit.checkoutOrder(
      address: addressController.text,
      region: cubit.state.selectedCity,
      jazzCashNumber: jazzCashNumber,
      deliveryInstructions: specialInstructionsController.text,
    );
    HeartLoaderDialogController.close(_checkoutLoaderId);
    if (!context.mounted) return;

    await result.fold(
      (error) async {
        final l10n = AppLocalizations.of(context)!;
        await showPharmacyErrorDialog(
          context,
          title: l10n.pharmacyCheckoutTitle,
          message: error.trim().isNotEmpty
              ? error.trim()
              : l10n.pharmacyCheckoutFailed,
        );
      },
      (checkout) async {
        final initiation = PaymentInitiationResult(
          paymentUrl: checkout.paymentUrl,
          orderId: checkout.orderNo,
          status: checkout.status,
        );

        if (initiation.isPendingWithoutPaymentUrl) {
          cubit.clearCart();
          if (!context.mounted) return;
          await _showPaymentPendingDialog(context);
          return;
        }

        // Card WebView lives in the shared payment feature.
        final paymentResult = await settleCardPaymentIfNeeded(
          context,
          initiation,
          allowClose: true,
        );
        if (!context.mounted) return;
        if (!paymentResult.isSuccess) {
          await showCardPaymentOutcomeDialog(context, paymentResult);
          return;
        }

        if (!context.mounted) return;
        cubit.logOrderConfirmed(
          orderId: checkout.orderNo,
          paymentStatus: AnalyticsPaymentStatusKeys.successful,
        );
        cubit.clearCart();
        await showPharmacyOrderPlacedDialog(
          context,
          orderNo: checkout.orderNo,
          onViewOrders: () {
            if (!context.mounted) return;
            pharmacyGoToOrderDetailsAfterPlace(context);
          },
        );
      },
    );
  }

  Future<void> _showPaymentPendingDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return PaymentPendingDialogWidget(
          title: l10n.pharmacyCheckoutPaymentPendingTitle,
          message: l10n.pharmacyCheckoutPaymentPendingMessage,
          ctaText: l10n.pharmacyOrderPlacedViewOrdersCta,
          onViewBookings: () {
            if (dialogContext.canPop()) dialogContext.pop();
            if (!context.mounted) return;
            pharmacyGoToOrderDetailsAfterPlace(context);
          },
        );
      },
    );
  }

  Future<String?> _resolveJazzCashMsisdn(BuildContext context) async {
    final result =
        await showModalBottomSheet<DoctorConsultationJazzCashSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DoctorConsultationJazzCashAccountsSheetWidget(),
    );
    return result?.msisdn.trim();
  }

  String _paymentMethodApiValue(PharmacyPaymentMethod method) {
    return switch (method) {
      PharmacyPaymentMethod.jazzCash => 'JAZZCASH',
      PharmacyPaymentMethod.debitCard => 'CARD',
      PharmacyPaymentMethod.cashOnDelivery => 'COD',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      buildWhen: (previous, current) =>
          previous.cartItems != current.cartItems ||
          previous.selectedCity != current.selectedCity ||
          previous.checkoutCities != current.checkoutCities ||
          previous.paymentBreakdown != current.paymentBreakdown ||
          previous.cartMessages != current.cartMessages ||
          previous.selectedPaymentMethod != current.selectedPaymentMethod,
      builder: (context, state) {
        final cities = state.checkoutCities.isNotEmpty
            ? state.checkoutCities
            : <String>[state.selectedCity];
        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(23.w, 24.h, 23.w, 126.h),
              children: [
                Text(
                  l10n.pharmacyCheckoutPatientDetailTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.clr060,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 22.h),
                PharmacyCheckoutField(
                  label: l10n.pharmacyCheckoutPatientLabel,
                  value: l10n.pharmacyCheckoutPatientSelf,
                ),
                SizedBox(height: 22.h),
                PharmacyCheckoutEditableField(
                  label: l10n.pharmacyCheckoutSpecialInstructionsLabel,
                  controller: specialInstructionsController,
                  hint: l10n.pharmacyCheckoutSpecialInstructionsHint,
                  inputFontSize: 14.sp,
                ),
                SizedBox(height: 22.h),
                Text(
                  l10n.pharmacyCheckoutOrderDetailsTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.clr060,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                ...state.cartItems.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: PharmacyCheckoutCartItemRow(item: item),
                  ),
                ),
                Divider(height: 26.h, color: AppColors.clrD6DCE2),
                if (state.freeDeliveryMessage != null) ...[
                  Text(
                    state.freeDeliveryMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.clr1FAFA3,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
                PharmacySummaryRow(
                  title: l10n.pharmacyCheckoutDeliveryChargesLabel,
                  value: state.deliveryCharges,
                  isBold: true,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                PharmacySummaryRow(
                  title: _discountTitle(l10n, state),
                  value: state.discount,
                  isBold: true,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                SizedBox(height: 12.h),
                PharmacySummaryRow(
                  title: l10n.pharmacyCheckoutTotalLabel,
                  value: state.total,
                  isBold: true,
                  bgColor: AppColors.clrBBBBBB,
                  padding: const EdgeInsets.all(8),
                  titleFontSize: 16.sp,
                  valueFontSize: 18.sp,
                ),
                SizedBox(height: 24.h),
                PharmacyCheckoutEditableField(
                  label: l10n.pharmacyCheckoutAddressLabel,
                  controller: addressController,
                  hint: l10n.pharmacyCheckoutAddressHint,
                  inputFontSize: 16.sp,
                ),
                SizedBox(height: 20.h),
                PharmacyCheckoutCityField(
                  label: l10n.pharmacyCheckoutCityLabel,
                  value: cities.contains(state.selectedCity)
                      ? state.selectedCity
                      : cities.first,
                  onTap: () async {
                    final picked = await showSelectCityDialog(
                      context,
                      cities: cities,
                      initialSelectedCity: state.selectedCity,
                      title: l10n.selectCityTitle,
                      searchHint: l10n.selectCitySearchHint,
                    );
                    if (picked == null || !context.mounted) return;
                    context.read<PharmacyCubit>().selectCheckoutCity(picked);
                  },
                ),
                SizedBox(height: 22.h),
                Text(
                  l10n.pharmacyCheckoutPaymentMethodTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.clr060,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 7.h),
                PharmacyPaymentOptionTile(
                  method: PharmacyPaymentMethod.jazzCash,
                  selectedMethod: state.selectedPaymentMethod,
                  onTap: () => context
                      .read<PharmacyCubit>()
                      .selectPaymentMethod(PharmacyPaymentMethod.jazzCash),
                ),
                SizedBox(height: 7.h),
                PharmacyPaymentOptionTile(
                  method: PharmacyPaymentMethod.debitCard,
                  selectedMethod: state.selectedPaymentMethod,
                  onTap: () => context
                      .read<PharmacyCubit>()
                      .selectPaymentMethod(PharmacyPaymentMethod.debitCard),
                ),
                SizedBox(height: 7.h),
                PharmacyPaymentOptionTile(
                  method: PharmacyPaymentMethod.cashOnDelivery,
                  selectedMethod: state.selectedPaymentMethod,
                  onTap: () =>
                      context.read<PharmacyCubit>().selectPaymentMethod(
                        PharmacyPaymentMethod.cashOnDelivery,
                      ),
                ),
                SizedBox(height: 16.h),
                PharmacyCheckoutNoticesWidget(messages: state.cartMessages),
              ],
            ),
            Positioned(
              left: 24.w,
              right: 24.w,
              bottom: 14.h,
              child: SafeArea(
                top: false,
                child: AppButtonWidget(
                  title: l10n.pharmacyCheckoutConfirmCta,
                  bgClr: AppColors.clr1FAFA3,
                  onTap: state.cartItems.isEmpty
                      ? null
                      : () => _onConfirm(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _discountTitle(AppLocalizations l10n, PharmacyState state) {
    final percent = state.discountPercent;
    if (percent != null && percent > 0) {
      return '${l10n.pharmacyCheckoutDiscountLabel} (${percent.toStringAsFixed(0)}%)';
    }
    return l10n.pharmacyCheckoutDiscountLabel;
  }
}
