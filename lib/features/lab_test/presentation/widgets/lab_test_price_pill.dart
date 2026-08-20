import 'package:flutter/material.dart';

import '../../domain/utils/lab_test_price_formatter.dart';

class LabTestPricePill extends StatelessWidget {
  const LabTestPricePill({
    super.key,
    required this.discountedFee,
    this.originalFee,
    this.originalTextStyle,
    this.discountedTextStyle,
    this.originalPadding = const EdgeInsets.fromLTRB(14, 8, 14, 8),
    this.discountedPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.singlePadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderColor = const Color(0xFFE0E3E8),
    this.borderWidth = 1,
    this.outerBorderRadius = 30,
    this.discountedBorderRadius = 30,
    this.singleBorderRadius = 24,
    this.discountedBackgroundColor = const Color(0xFF11B2A4),
    this.originalBackgroundColor = Colors.white,
    this.originalTextColor = const Color(0xFFA5A5A5),
    this.discountedTextColor = Colors.white,
    this.decorationThickness = 1.5,
  });

  final String discountedFee;
  final String? originalFee;

  final TextStyle? originalTextStyle;
  final TextStyle? discountedTextStyle;

  final EdgeInsetsGeometry originalPadding;
  final EdgeInsetsGeometry discountedPadding;
  final EdgeInsetsGeometry singlePadding;

  final Color borderColor;
  final double borderWidth;
  final double outerBorderRadius;
  final double discountedBorderRadius;
  final double singleBorderRadius;
  final Color discountedBackgroundColor;
  final Color originalBackgroundColor;
  final Color originalTextColor;
  final Color discountedTextColor;
  final double decorationThickness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final original = originalFee?.trim() ?? '';
    final hasOriginal = original.isNotEmpty &&
        !LabTestPriceFormatter.isSameFee(original, discountedFee);

    if (!hasOriginal) {
      return Container(
        padding: singlePadding,
        decoration: BoxDecoration(
          color: discountedBackgroundColor,
          borderRadius: BorderRadius.circular(singleBorderRadius),
        ),
        child: Text(
          discountedFee,
          style: (discountedTextStyle ?? theme.textTheme.bodyMedium)?.copyWith(
            color: discountedTextColor,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: originalBackgroundColor,
        borderRadius: BorderRadius.circular(outerBorderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: originalPadding,
            child: Text(
              original,
              style: (originalTextStyle ?? theme.textTheme.bodySmall)?.copyWith(
                color: originalTextColor,
                decoration: TextDecoration.lineThrough,
                decorationThickness: decorationThickness,
              ),
            ),
          ),
          Container(
            padding: discountedPadding,
            decoration: BoxDecoration(
              color: discountedBackgroundColor,
              borderRadius: BorderRadius.circular(discountedBorderRadius),
            ),
            child: Text(
              discountedFee,
              style: (discountedTextStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                color: discountedTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
