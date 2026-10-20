import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../bookings/presentation/widgets/payment_option.dart';
import '../../../consultation/data/utils/consultation_booking_utils.dart';
import 'pro_nested_sheet_route.dart';

/// Static Pro payment-method sheet: JazzCash only. Proceed → accounts.
class ProJazzCashPaymentMethodSheet extends StatelessWidget {
  const ProJazzCashPaymentMethodSheet({super.key});

  static const String jazzCashCode = 'JAZZCASH';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.clrWhite,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.clrCBD3DC,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.consultationPaymentMethodTitle,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.clr061E40,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              PaymentOption(
                value: jazzCashCode,
                groupValue: jazzCashCode,
                onChanged: (_) {},
                label: l10n.pharmacyPaymentJazzCash,
                iconBuilder: () => Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: AppColors.clrWhite,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.clrE3E8EE, width: 0.6),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    Assets.iconsJazzCash,
                    width: 34.w,
                    height: 18.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(jazzCashCode),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.clr1FAFA3,
                      foregroundColor: AppColors.clrWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      l10n.commonProceed,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.clrWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens JazzCash payment over Pro via the Pro sheet's nested [Navigator].
///
/// Returns `true` when the user taps Proceed.
Future<bool> showProJazzCashPaymentMethodSheet(BuildContext context) async {
  final code = await pushProNestedSheet<String>(
    context: context,
    builder: (_) => const ProJazzCashPaymentMethodSheet(),
  );
  return ConsultationBookingUtils.isJazzCashPayment(code ?? '');
}
