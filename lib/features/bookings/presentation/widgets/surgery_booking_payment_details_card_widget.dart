import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../data/models/surgery_details_item.dart';

/// Payment Details card: fee, discount, discount code strip and total bar.
///
/// Mirrors the lab checkout breakdown card.
class SurgeryBookingPaymentDetailsCardWidget extends StatelessWidget {
  const SurgeryBookingPaymentDetailsCardWidget({
    super.key,
    required this.item,
  });

  final SurgeryDetailsItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasDiscount = item.discountAmount > 0 || item.discountPercent > 0;
    final discountCode = item.discountCode.trim();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrEDEDED),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.bookingsPaymentDetailsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                _PaymentRow(label: l10n.bookingsFeeLabel, amount: item.fee),
                if (hasDiscount) ...[
                  SizedBox(height: 10.h),
                  Divider(height: 1, thickness: 1, color: AppColors.clrE4E4E4),
                  SizedBox(height: 10.h),
                  _PaymentRow(
                    label: l10n.bookingsDiscountLabel('${item.discountPercent}'),
                    amount: item.discountAmount,
                  ),
                ],
                if (discountCode.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _DiscountCodeStrip(code: discountCode),
                ],
              ],
            ),
          ),
          _TotalBar(total: item.total),
        ],
      ),
    );
  }
}

/// Fee / Discount row with a muted `Rs.` prefix and dark amount.
class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr667B99,
              fontSize: 14.sp,
            ),
          ),
        ),
        _Amount(
          amount: amount,
          color: AppColors.clr061E40,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

/// Edge-to-edge total bar at the bottom of the card.
class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      color: AppColors.clrF2F2F2,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.bookingsTotalLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.clr061E40,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
          ),
          _Amount(
            amount: total,
            color: AppColors.clr110844,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _DiscountCodeStrip extends StatelessWidget {
  const _DiscountCodeStrip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.clrF7EFC7,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.labTestDiscountIcon,
                width: 15.r,
                height: 15.r,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  l10n.bookingsDiscountCodeLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.clr1C232D,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                code,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.clr1C232D,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(height: 1, color: AppColors.clrE1D49D),
          SizedBox(height: 8.h),
          Text(
            l10n.bookingsShowCodeInstruction,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.clr1C232D,
              fontSize: 12.sp,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.amount,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
  });

  final int amount;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Rs.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.clr667B99,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: _formatNumber(amount),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatNumber(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final reverseIndex = s.length - i;
    buf.write(s[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) buf.write(',');
  }
  return buf.toString();
}
