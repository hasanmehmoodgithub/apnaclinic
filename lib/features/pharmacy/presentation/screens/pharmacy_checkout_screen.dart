import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import '../cubit/pharmacy_cubit.dart';
import '../cubit/pharmacy_state.dart';
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
  String _selectedCity = 'Islamabad';

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
                    color: const Color(0xFFF3F3F3),
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
                          _CheckoutField(
                            label: 'Patient',
                            value: 'Self',
                          ),
                          SizedBox(height: 22.h),
                          _CheckoutEditableField(
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
                              child: _CheckoutCartItemRow(item: item),
                            ),
                          ),
                          Divider(height: 26.h, color: const Color(0xFFD6DCE2)),
                          _SummaryRow(
                            title: 'Delivery Charges',
                            value: state.deliveryCharges,
                          ),
                          _SummaryRow(title: 'Discount (8%)', value: state.discount),
                          SizedBox(height: 12.h),
                          _SummaryRow(
                            title: 'Total',
                            value: state.total,
                            isBold: true,
                          ),
                          SizedBox(height: 24.h),
                          _CheckoutEditableField(
                            label: 'Delivery address',
                            controller: _addressController,
                            hint: 'Enter your address',
                          ),
                          SizedBox(height: 20.h),
                          _CheckoutCityDropdown(
                            label: 'Area / City *',
                            value: _selectedCity,
                            cities: _cities,
                            onChanged: (city) {
                              if (city == null) return;
                              setState(() => _selectedCity = city);
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
                          _InfoCard(
                            title: 'Disclaimer',
                            message:
                                'Sold and fulfilled by our Licensed Pharmacy Partner(s) "MEDIQ PHARMACY". License No. : 05-352-0070-053618P',
                          ),
                          SizedBox(height: 12.h),
                          _InfoCard(
                            message:
                                'Prescription is required for some items. Customer representative will contact you shortly.',
                          ),
                          SizedBox(height: 12.h),
                          _InfoCard(
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
                          child: FilledButton(
                            onPressed: state.cartItems.isEmpty
                                ? null
                                : () async {
                                    await _showOrderPlacedDialog(context);
                                    if (!context.mounted) return;
                                    context.read<PharmacyCubit>().clearCart();
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF1FAFA3),
                              minimumSize: Size.fromHeight(62.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              'Confirm',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
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
      },
    );
  }

  Future<void> _showOrderPlacedDialog(BuildContext context) {
    final theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.38),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60.r,
                  height: 60.r,
                  child: SvgPicture.asset('assets/icons/tick.svg'),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Order Placed',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF102A56),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Orders received b/w 8 AM - 8 PM will be delivered within 3 business hrs.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7C96),
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF27B3A6),
                      minimumSize: Size.fromHeight(52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.value,
    this.isBold = false,
  });

  final String title;
  final double value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF061E40),
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          fontSize: isBold ? 17.sp / 1.6 : 16.sp / 1.6,
        );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          RichText(
            text: TextSpan(
              style: style,
              children: [
                TextSpan(
                  text: 'Rs. ',
                  style: style?.copyWith(
                    color: const Color(0xFF5D758F),
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                TextSpan(text: value.toStringAsFixed(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutField extends StatelessWidget {
  const _CheckoutField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFD8E0E8)),
          ),
          child: Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: const Color(0xFF5D758F),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckoutEditableField extends StatelessWidget {
  const _CheckoutEditableField({
    required this.label,
    required this.controller,
    required this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          height: 42.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFD8E0E8)),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF5D758F),
                fontSize: 16.sp / 1.6,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF8C9CB0),
                  fontSize: 16.sp / 1.6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckoutCityDropdown extends StatelessWidget {
  const _CheckoutCityDropdown({
    required this.label,
    required this.value,
    required this.cities,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> cities;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFD8E0E8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.expand_more_rounded,
                color: const Color(0xFF5D758F),
                size: 20.r,
              ),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF5D758F),
                fontSize: 19.sp / 1.6,
                fontWeight: FontWeight.w500,
              ),
              onChanged: onChanged,
              items: cities
                  .map(
                    (city) => DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckoutCartItemRow extends StatelessWidget {
  const _CheckoutCartItemRow({required this.item});

  final PharmacyCartItemEntity item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 130.r,
          height: 88.r,
          decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(22.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(item.medicine.imageUrl, fit: BoxFit.cover),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.medicine.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '${item.quantity}x Rs ${item.medicine.price.toStringAsFixed(0)}/-',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5D758F),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    this.title,
    required this.message,
    this.footer,
  });

  final String? title;
  final String message;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 11.h, 16.w, 11.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 17.sp / 1.6,
              ),
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5D758F),
              fontSize: 15.sp / 1.6,
              height: 1.3,
            ),
          ),
          if (footer != null) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                footer!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF5D758F),
                  fontSize: 15.sp / 1.6,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
