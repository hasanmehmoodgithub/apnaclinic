import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
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
      borderRadius: BorderRadius.circular(2.r),
      child: Material(
        elevation: 0.1,
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.r),
        child: Container(
          height: 104.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3, color: Color(0xff9BA6A7)),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: _leading(method),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    _label(context, method),
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
      ),
    );
  }

  Widget _leading(PharmacyPaymentMethod method) {
    return switch (method) {
      PharmacyPaymentMethod.jazzCash => SvgPicture.asset(
        Assets.iconsJazzCash,
        width: 36.r,
        height: 18.r,
      ),
      PharmacyPaymentMethod.debitCard => SvgPicture.asset(
        Assets.iconsDebitCard,
        width: 36.r,
        height: 18.r,
      ),
      PharmacyPaymentMethod.cashOnDelivery => SvgPicture.asset(
        Assets.iconsCash,
        width: 36.r,
        height: 18.r,
      ),
    };
  }

  String _label(BuildContext context, PharmacyPaymentMethod method) {
    // Keep payment labels in localization so checkout text is fully translatable.
    final l10n = AppLocalizations.of(context)!;
    return switch (method) {
      PharmacyPaymentMethod.jazzCash => l10n.pharmacyPaymentJazzCash,
      PharmacyPaymentMethod.debitCard => l10n.pharmacyPaymentDebitCard,
      PharmacyPaymentMethod.cashOnDelivery => l10n.pharmacyPaymentCash,
    };
  }
}
