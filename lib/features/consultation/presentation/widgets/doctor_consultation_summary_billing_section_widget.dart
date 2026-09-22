import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'doctor_consultation_summary_card_shell_widget.dart';

class DoctorConsultationSummaryBillingSectionWidget extends StatelessWidget {
  const DoctorConsultationSummaryBillingSectionWidget({
    super.key,
    required this.consultationFee,
    required this.discount,
    required this.total,
    this.promoCode,
    this.promoDiscount = 0,
  });

  final int consultationFee;
  final int discount;
  final int total;
  final String? promoCode;
  final int promoDiscount;

  bool get _hasPromoDiscount {
    final code = promoCode?.trim() ?? '';
    return code.isNotEmpty || promoDiscount > 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        DoctorConsultationSummaryCardShell(
          child: Column(
            children: [
              _AmountRow(
                textTheme: textTheme,
                label: l10n.consultationConsultationFeesLabel,
                amount: consultationFee,
              ),
              if (discount > 0) ...[
                SizedBox(height: 10.h),
                _AmountRow(
                  textTheme: textTheme,
                  label: l10n.consultationDiscountLabel,
                  amount: discount,
                ),
              ],
              if (_hasPromoDiscount) ...[
                SizedBox(height: 10.h),
                _AmountRow(
                  textTheme: textTheme,
                  label: l10n.promoCodeDiscountLabel,
                  amount: promoDiscount,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 10.h),
        DoctorConsultationSummaryCardShell(
          child: Row(
            children: [
              Text(
                l10n.consultationSummaryTotalAmountLabel,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF061E40),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _AmountValue(
                textTheme: textTheme,
                amount: total,
                fontSize: 18.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.textTheme,
    required this.label,
    required this.amount,
  });

  final TextTheme textTheme;
  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF667B99),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        _AmountValue(textTheme: textTheme, amount: amount),
      ],
    );
  }
}

class _AmountValue extends StatelessWidget {
  const _AmountValue({
    required this.textTheme,
    required this.amount,
    this.fontSize,
  });

  final TextTheme textTheme;
  final int amount;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final amountSize = fontSize ?? 14.sp;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$amount',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontSize: amountSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' Rs.',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF667B99),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
