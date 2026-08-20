import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class PharmacyQuantityStepper extends StatelessWidget {
  const PharmacyQuantityStepper({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.onDelete,
    this.deleteTooltip,
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
  final VoidCallback? onDelete;
  final String? deleteTooltip;
  final double? height;
  final double? horizontalPadding;
  final double? itemSpacing;
  final double? quantityFontSize;
  final double? actionFontSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    const tapSize = 36.0;
    final containerHeight = height ?? tapSize;
    final containerPadding = horizontalPadding ?? 8.w;
    final spacing = itemSpacing ?? 8.w;
    final qtyFont = quantityFontSize ?? 16.sp;
    final actionFont = actionFontSize ?? 13.sp;
    final radius = borderRadius ?? 36.r;

    return Container(
      height: containerHeight < tapSize ? tapSize : containerHeight,
      padding: EdgeInsets.symmetric(horizontal: containerPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.clrCBD3DC, width: 0.8),
        color: AppColors.clrWhite,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onDelete != null)
            _DeleteIconButton(
              onTap: onDelete!,
              tooltip: deleteTooltip,
            ),
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

class _DeleteIconButton extends StatelessWidget {
  const _DeleteIconButton({required this.onTap, this.tooltip});

  final VoidCallback onTap;
  final String? tooltip;

  static const double _tapSize = 36;

  @override
  Widget build(BuildContext context) {
    final iconSize = 18.sp;
    final icon = SizedBox(
      width: iconSize,
      height: _tapSize,
      child: InkWell(
        onTap: onTap,
        child: Icon(
          Icons.delete_outline,
          size: iconSize,
          color: AppColors.clr667B99,
        ),
      ),
    );
    final message = tooltip;
    if (message == null || message.isEmpty) return icon;
    return Tooltip(message: message, child: icon);
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

  static const double _tapSize = 36;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _tapSize,
      height: _tapSize,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.clr667B99,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
