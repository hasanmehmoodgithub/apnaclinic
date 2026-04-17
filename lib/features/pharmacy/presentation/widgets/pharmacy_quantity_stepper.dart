import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class PharmacyQuantityStepper extends StatelessWidget {
  const PharmacyQuantityStepper({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.showBasketIcon = false,
  });

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool showBasketIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36.r),
        border: Border.all(color: const Color(0xFFCBD3DC), width: 0.8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showBasketIcon) ...[
            SvgPicture.asset(
              Assets.iconsBasket,
              width: 14.r,
              height: 14.r,
              color: const Color(0xFF667B99),
            ),
            SizedBox(width: 10.w),
          ],
          _ActionIconButton(label: '-', onTap: onRemove),
          SizedBox(width: 14.w),
          Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF667B99),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
          ),
          SizedBox(width: 14.w),
          _ActionIconButton(label: '+', onTap: onAdd),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFF667B99),
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
      ),
    );
  }
}
