import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class PharmacyQuantityStepper extends StatelessWidget {
  const PharmacyQuantityStepper({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.showBasketIcon = false,
    this.height,
    this.horizontalPadding,
    this.itemSpacing,
    this.quantityFontSize,
    this.actionFontSize,
    this.borderRadius,
  });

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool showBasketIcon;
  final double? height;
  final double? horizontalPadding;
  final double? itemSpacing;
  final double? quantityFontSize;
  final double? actionFontSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final containerHeight = height ?? 32.h;
    final containerPadding = horizontalPadding ?? 8.w;
    final spacing = itemSpacing ?? 14.w;
    final qtyFont = quantityFontSize ?? 16.sp;
    final actionFont = actionFontSize ?? 13.sp;
    final radius = borderRadius ?? 36.r;

    return Container(
      height: containerHeight,
      padding: EdgeInsets.symmetric(horizontal: containerPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.clrCBD3DC, width: 0.8),
        color: AppColors.clrWhite,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showBasketIcon) ...[
            SvgPicture.asset(Assets.iconsBasket, width: 14.r, height: 14.r),
            SizedBox(width: spacing),
          ],
          _ActionIconButton(label: '-', onTap: onRemove, fontSize: actionFont),
          SizedBox(width: spacing),
          Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.clr667B99,
              fontWeight: FontWeight.w400,
              fontSize: qtyFont,
            ),
          ),
          SizedBox(width: spacing),
          _ActionIconButton(label: '+', onTap: onAdd, fontSize: actionFont),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.label,
    required this.onTap,
    required this.fontSize,
  });

  final String label;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.clr667B99,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
