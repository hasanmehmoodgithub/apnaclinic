import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../lab_test_route_args.dart';

class LabTestCheckoutPaymentBreakdownCardWidget extends StatelessWidget {
  const LabTestCheckoutPaymentBreakdownCardWidget({
    super.key,
    required this.args,
  });

  final LabTestCheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14053453),
            blurRadius: 18,
            offset: Offset(0, 6),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Text(
              l10n.labTestCheckoutTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.clr061E40,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
          _moneyRow(context, l10n.labTestCheckoutFeeLabel, args.originalFee),
          _moneyRow(
            context,
            '${l10n.labTestCheckoutDiscountLabel} (${args.discountPercent}%)',
            args.discountAmount,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.clrF2F2F2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.labTestCheckoutTotalLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  args.discountedFee,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.clr110844,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyRow(BuildContext context, String label, String amount) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr667B99,
              fontSize: 14.sp,
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr110844,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
