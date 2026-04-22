import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
import '../widgets/pharmacy_checkout_widgets.dart';
import '../widgets/pharmacy_order_placed_dialog.dart';
import '../widgets/pharmacy_payment_option_tile.dart';

class PharmacyCheckoutScreen extends StatefulWidget {
  const PharmacyCheckoutScreen({super.key});

  @override
  State<PharmacyCheckoutScreen> createState() => _PharmacyCheckoutScreenState();
}

class _PharmacyCheckoutScreenState extends State<PharmacyCheckoutScreen> {
  late final TextEditingController _addressController;
  late final TextEditingController _specialInstructionsController;
  final List<String> _cities = const [
    'Islamabad',
    'Lahore',
    'Karachi',
    'Rawalpindi',
    'Peshawar',
  ];
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _specialInstructionsController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PharmacyCubit, PharmacyState>(
      builder: (context, state) {
        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 13.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF061E40),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Check Out',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF061E40),
                              fontSize: 31.sp / 1.6,
                            ),
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
                  ),
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.fromLTRB(23.w, 24.h, 23.w, 126.h),
                        children: [
                          Text(
                            'Patient Detail',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF061E40),
                                  fontSize: 16.sp,
                                ),
                          ),
                          SizedBox(height: 22.h),
                          PharmacyCheckoutField(
                            label: 'Patient',
                            value: 'Self',
                          ),
                          SizedBox(height: 22.h),
                          PharmacyCheckoutEditableField(
                            label: 'Special Instructions',
                            controller: _specialInstructionsController,
                            hint: '----',
                          ),
                          SizedBox(height: 22.h),
                          Text(
                            'Order Details',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF061E40),
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
                          Divider(height: 26.h, color: const Color(0xFFD6DCE2)),
                          PharmacySummaryRow(
                            title: 'Delivery Charges',
                            value: state.deliveryCharges,
                            isBold: true,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          PharmacySummaryRow(
                            title: 'Discount (8%)',
                            value: state.discount,
                            isBold: true,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          SizedBox(height: 12.h),
                          PharmacySummaryRow(

                            title: 'Total',
                            value: state.total,
                            isBold: true,
                            bgColor: Color(0xffBBBBBB),
                            padding: EdgeInsets.all( 8),
                          ),
                          SizedBox(height: 24.h),
                          PharmacyCheckoutEditableField(
                            label: 'Delivery address',
                            controller: _addressController,
                            hint: 'Enter your address',
                          ),
                          SizedBox(height: 20.h),
                          PharmacyCheckoutCityDropdown(
                            label: 'Area / City *',
                            value: state.selectedCity,
                            cities: _cities,
                            onChanged: (city) {
                              if (city == null) return;
                              context.read<PharmacyCubit>().selectCheckoutCity(city);
                            },
                          ),
                          SizedBox(height: 22.h),
                          Text(
                            'Payment Method',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: const Color(0xFF061E40),
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
                            onTap: () => context.read<PharmacyCubit>().selectPaymentMethod(
                              PharmacyPaymentMethod.cashOnDelivery,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          PharmacyInfoCard(
                            bgColor:Color(0xffE9F4FC) ,
                            title: 'Disclaimer',
                            message:
                                'Sold and fulfilled by our Licensed Pharmacy Partner(s) "MEDIQ PHARMACY". License No. : 05-352-0070-053618P',
                          ),

                          SizedBox(height: 12.h),
                          PharmacyInfoCard(
                            bgColor:Color(0xffFCF5E9) ,
                            message:
                                'Orders will be delivered within 3 hours between 8:00 AM and 8:00 PM. Orders placed after 8:00 PM will be delivered by 12PM the following day.',
                            footer:
                                'Orders below Rs 2500 will include delivery charges of Rs 250.',
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
                            title: 'Confirm',
                            bgClr: const Color(0xFF1FAFA3),
                            onTap: state.cartItems.isEmpty
                                ? null
                                : () async {
                                    await showPharmacyOrderPlacedDialog(context);
                                    if (!context.mounted) return;
                                    context.read<PharmacyCubit>().clearCart();
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
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
      },
    );
  }

}
