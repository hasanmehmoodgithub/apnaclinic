import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class PharmacyCartIconWithCount extends StatelessWidget {
  const PharmacyCartIconWithCount({
    super.key,
    required this.cartCount,
    required this.onTap,
    this.iconContainerSize,
    this.iconSize,
    this.badgeRightOffset,
    this.badgeTopOffset,
  });

  final int cartCount;
  final VoidCallback onTap;
  final double? iconContainerSize;
  final double? iconSize;
  final double? badgeRightOffset;
  final double? badgeTopOffset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerSize = iconContainerSize ?? 32.r;
    final basketIconSize = iconSize ?? 16.r;
    final badgeExtraSpace = 6.r;

    return SizedBox(
      width: containerSize + badgeExtraSpace,
      height: containerSize + badgeExtraSpace,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(containerSize / 2),
              child: Container(
                width: containerSize,
                height: containerSize,
                decoration: const BoxDecoration(
                  color: AppColors.clrWhite,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.iconsBasket,
                    width: basketIconSize,
                    height: basketIconSize,
                    colorFilter: const ColorFilter.mode(
                      AppColors.clrBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (cartCount > 0)
            Positioned(
              right: badgeRightOffset ?? 1.r,
              top: badgeTopOffset ?? 1.r,
              child: Container(
                width: 16.r,
                height: 16.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.clrRed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cartCount > 99 ? '99' : '$cartCount',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.clrWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 8.sp,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
