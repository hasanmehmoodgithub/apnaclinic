import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/utils/lab_test_price_formatter.dart';
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
    final hasDiscount =
        LabTestPriceFormatter.parseRsAmount(args.discountAmount) > 0 ||
            args.discountPercent > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.labTestCheckoutTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 10.h),
        _moneyRow(context, l10n.labTestCheckoutFeeLabel, args.originalFee),
        if (hasDiscount) ...[
          SizedBox(height: 8.h),
          _moneyRow(
            context,
            '${l10n.labTestCheckoutDiscountLabel} (${args.discountPercent}%)',
            args.discountAmount,
          ),
        ],
        SizedBox(height: 10.h),
        Container(height: 0.5, color: AppColors.clrE7E7E7),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.clrF2F2F2,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.labTestCheckoutTotalLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                args.totalAmount,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.clr110844,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _moneyRow(BuildContext context, String label, String amount) {
    final theme = Theme.of(context);
    return Row(
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
            color: AppColors.clr061E40,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
