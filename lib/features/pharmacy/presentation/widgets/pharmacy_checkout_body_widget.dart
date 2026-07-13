import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../pharmacy_navigation.dart';
import 'pharmacy_checkout_widgets.dart';
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
    showHeartLoaderDialog(context, id: _checkoutLoaderId, size: 120);
    final result = await cubit.checkoutOrder(
      address: addressController.text,
      region: cubit.state.selectedCity,
    );
    HeartLoaderDialogController.close(_checkoutLoaderId);
    if (!context.mounted) return;

    await result.fold(
      (error) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (checkout) async {
        await showPharmacyOrderPlacedDialog(context);
        if (!context.mounted) return;
        cubit.clearCart();
        pharmacyGoToOrderDetailsAfterPlace(
          context,
          extra: <String, Object?>{
            'orderNo': checkout.orderNo.isNotEmpty ? checkout.orderNo : '—',
            'status': checkout.status,
          },
        );
      },
    );
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
                PharmacySummaryRow(
                  title: l10n.pharmacyCheckoutDeliveryChargesLabel,
                  value: state.deliveryCharges,
                  isBold: true,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                PharmacySummaryRow(
                  title: state.discountPercent != null
                      ? '${l10n.labTestCheckoutDiscountLabel} (${state.discountPercent!.toStringAsFixed(0)}%)'
                      : l10n.pharmacyCheckoutDiscountLabel,
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
                ),
                SizedBox(height: 24.h),
                PharmacyCheckoutEditableField(
                  label: l10n.pharmacyCheckoutAddressLabel,
                  controller: addressController,
                  hint: l10n.pharmacyCheckoutAddressHint,
                ),
                SizedBox(height: 20.h),
                PharmacyCheckoutCityDropdown(
                  label: l10n.pharmacyCheckoutCityLabel,
                  value: cities.contains(state.selectedCity)
                      ? state.selectedCity
                      : cities.first,
                  cities: cities,
                  onChanged: (city) {
                    if (city == null) return;
                    context.read<PharmacyCubit>().selectCheckoutCity(city);
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
                PharmacyInfoCard(
                  bgColor: AppColors.clrE9F4FC,
                  title: l10n.pharmacyCheckoutDisclaimerTitle,
                  message: l10n.pharmacyCheckoutDisclaimerMessage,
                ),
                SizedBox(height: 12.h),
                PharmacyInfoCard(
                  bgColor: AppColors.clrFCF5E9,
                  message: l10n.pharmacyCheckoutDeliveryInfoMessage,
                  footer: l10n.pharmacyCheckoutDeliveryInfoFooter,
                ),
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
}
