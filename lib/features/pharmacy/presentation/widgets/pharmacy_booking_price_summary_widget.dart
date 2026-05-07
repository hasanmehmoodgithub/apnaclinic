import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class PharmacyBookingPriceSummaryWidget extends StatelessWidget {
  const PharmacyBookingPriceSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _SummaryRow(
          title: l10n.pharmacyCheckoutDeliveryChargesLabel,
          value: '200',
          valueColor: AppColors.clr110844,
        ),
        SizedBox(height: 14.h),
        _SummaryRow(
          title: l10n.pharmacyCheckoutDiscountLabel,
          value: '40',
          valueColor: AppColors.clr110844,
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          color: AppColors.clrE7E7E7,
          child: _SummaryRow(
            title: l10n.pharmacyCheckoutTotalLabel,
            value: '4040',
            valueColor: AppColors.clr110844,
            titleColor: AppColors.clr060,
            valueFontSize: 31.sp / 1.6,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.value,
    required this.valueColor,
    this.titleColor = AppColors.clr667B99,
    this.valueFontSize = 28 / 2,
  });

  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;
  final double valueFontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: titleColor,
              fontSize: 14.sp,
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: valueFontSize,
              color: valueColor,
            ),
            children: [
              TextSpan(
                text: l10n.pharmacyBookingCurrencyCompact,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.clr667B99,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ],
    );
  }
}
