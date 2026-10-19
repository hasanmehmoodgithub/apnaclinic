import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import 'doctor_consultation_summary_card_shell_widget.dart';

class DoctorConsultationSummaryBillingSectionWidget extends StatelessWidget {
  const DoctorConsultationSummaryBillingSectionWidget({
    super.key,
    required this.consultationFee,
    required this.discount,
    required this.total,
    this.isPro = false,
    this.promoCode,
    this.promoDiscount = 0,
  });

  final int consultationFee;
  final int discount;
  final int total;
  final bool isPro;
  final String? promoCode;
  final int promoDiscount;

  bool get _hasPromoDiscount {
    final code = promoCode?.trim() ?? '';
    return code.isNotEmpty || promoDiscount > 0;
  }

  bool get _showProDiscount => isPro && discount > 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final fee = _showProDiscount
        ? consultationFee
        : (discount > 0 ? consultationFee - discount : consultationFee);
    final discountPercent = consultationFee > 0
        ? ((discount * 100) / consultationFee).round()
        : 0;

    return Column(
      children: [
        DoctorConsultationSummaryCardShell(
          child: Column(
            children: [
              _AmountRow(
                textTheme: textTheme,
                label: l10n.consultationConsultationFeesLabel,
                amount: fee,
              ),
              if (_showProDiscount) ...[
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        discountPercent > 0
                            ? l10n.bookingsDiscountLabel('$discountPercent')
                            : l10n.consultationDiscountLabel,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.clr667B99,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      Assets.proProBadge,
                      height: 18.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
              if (_hasPromoDiscount) ...[
                SizedBox(height: 10.h),
                _AmountRow(
                  textTheme: textTheme,
                  label: l10n.promoCodeDiscountLabel,
                  amount: promoDiscount,
                  isNegative: true,
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
                  color: AppColors.clr061E40,
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
    this.isNegative = false,
  });

  final TextTheme textTheme;
  final String label;
  final int amount;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        _AmountValue(
          textTheme: textTheme,
          amount: amount,
          isNegative: isNegative,
        ),
      ],
    );
  }
}

class _AmountValue extends StatelessWidget {
  const _AmountValue({
    required this.textTheme,
    required this.amount,
    this.fontSize,
    this.isNegative = false,
  });

  final TextTheme textTheme;
  final int amount;
  final double? fontSize;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    final amountSize = fontSize ?? 14.sp;
    return Text.rich(
      TextSpan(
        children: [
          if (isNegative)
            TextSpan(
              text: '- ',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.clr061E40,
                fontSize: amountSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          TextSpan(
            text: '$amount',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.clr061E40,
              fontSize: amountSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' Rs.',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.clr667B99,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
