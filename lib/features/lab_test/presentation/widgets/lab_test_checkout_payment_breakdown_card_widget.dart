import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../lab_test_route_args.dart';

class LabTestCheckoutPaymentBreakdownCardWidget extends StatelessWidget {
  const LabTestCheckoutPaymentBreakdownCardWidget({super.key, required this.args});

  final LabTestCheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE3EA), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.labTestCheckoutTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
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
            color: const Color(0xFFEBECEE),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.labTestCheckoutTotalLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  args.discountedFee,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF110844),
                    fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF667B99),
              fontSize: 14.sp,
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF110844),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
