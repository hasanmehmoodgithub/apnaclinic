import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../cubit/pharmacy_state.dart';

class PharmacyPaymentOptionTile extends StatelessWidget {
  const PharmacyPaymentOptionTile({
    super.key,
    required this.method,
    required this.selectedMethod,
    required this.onTap,
  });

  final PharmacyPaymentMethod method;
  final PharmacyPaymentMethod selectedMethod;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = method == selectedMethod;
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 104.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE6EBF1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8FB),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: _leading(method),
                ),
                SizedBox(width: 12.w),
                Text(
                  _label(method),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Container(
              width: 14.r,
              height: 14.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFB8C5D2)),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF5D758F),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _leading(PharmacyPaymentMethod method) {
    return switch (method) {
      PharmacyPaymentMethod.jazzCash => SvgPicture.asset(
          'assets/svg/jazzCash.svg',
          width: 36.r,
          height: 18.r,
        ),
      PharmacyPaymentMethod.debitCard => Icon(
          Icons.credit_card_rounded,
          size: 24.r,
          color: const Color(0xFF0B77C5),
        ),
      PharmacyPaymentMethod.cashOnDelivery => SvgPicture.asset(
          Assets.iconsMedicine,
          width: 24.r,
          height: 24.r,
          color: const Color(0xFF0FAA9A),
        ),
    };
  }

  String _label(PharmacyPaymentMethod method) {
    return switch (method) {
      PharmacyPaymentMethod.jazzCash => 'Jazz Cash',
      PharmacyPaymentMethod.debitCard => 'Debit / Credit Card',
      PharmacyPaymentMethod.cashOnDelivery => 'Pay via Cash',
    };
  }
}
