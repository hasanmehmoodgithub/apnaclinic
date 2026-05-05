import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/models/surgery_details_item.dart';


class SurgeryBookingPaymentDetailsCardWidget extends StatelessWidget {
  const SurgeryBookingPaymentDetailsCardWidget({
    super.key,
    required this.item,
  });

  final SurgeryDetailsItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F053453),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + Fee + Discount get horizontal padding ──
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Details',
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                _PaymentRow(
                  label: 'Fee',
                  amount: item.fee,
                  textTheme: textTheme,
                ),
                Container(
                  height: 0.6,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  color: const Color(0xFFE2E8EE),
                ),
                _PaymentRow(
                  label: 'Discount (${item.discountPercent}%)',
                  amount: item.discountAmount,
                  trailingDecimal: '.0',
                  textTheme: textTheme,
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
          // ── Total bar: NO outer padding → spans full card width ──
          _TotalBar(total: item.total, textTheme: textTheme),
        ],
      ),
    );
  }
}

// ─── Single Fee/Discount row with muted "Rs." prefix and dark amount ───
class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.label,
    required this.amount,
    required this.textTheme,
    this.trailingDecimal = '',
  });

  final String label;
  final int amount;
  final String trailingDecimal;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8593A8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Rs.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8593A8),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: '${_formatNumber(amount)}$trailingDecimal',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF061E40),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Edge-to-edge total bar ───
class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.total, required this.textTheme});

  final int total;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      color: const Color(0xFFEEF1F3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total',
              style: textTheme.titleSmall?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Rs.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF8593A8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: _formatNumber(total),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared number-formatting helper (top-level, file-private) ───
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