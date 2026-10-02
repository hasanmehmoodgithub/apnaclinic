import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../generated/assets.dart';

/// Top app bar: back, title, cart with optional count badge.
class LabTestBrowseHeaderWidget extends StatelessWidget {
  const LabTestBrowseHeaderWidget({
    super.key,
    required this.padding,
    required this.title,
    required this.cartCount,
    required this.cartBadgeOverflowLabel,
    this.onCartTap,
    this.showCart = true,
    this.titleMaxLines,
    this.titleHorizontalPadding,
    this.titleFontSize,
  });

  final EdgeInsetsGeometry padding;
  final String title;
  final int cartCount;
  final String cartBadgeOverflowLabel;
  final Future<void> Function()? onCartTap;
  final bool showCart;

  /// When set, the title is limited to this many lines and ellipsized.
  final int? titleMaxLines;

  /// Extra space on both sides of the title, inside the back and cart controls.
  final double? titleHorizontalPadding;

  /// Overrides the default 20sp title size.
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showCartCount = context.isUserLoggedIn && cartCount > 0;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: () => context.pop(),
              child: SizedBox(
                width: 40.r,
                height: 40.r,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: const Color(0xFF061E40),
                  size: 24.r,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: titleHorizontalPadding ?? 0,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: titleMaxLines,
                overflow: titleMaxLines == null ? null : TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF061E40),
                  fontWeight: FontWeight.w700,
                  fontSize: titleFontSize ?? 20.sp,
                  height: 30.9 / 20,
                ),
              ),
            ),
          ),
          if (!showCart)
            SizedBox(width: 40.r, height: 40.r)
          else
            InkWell(
            onTap: onCartTap == null ? null : () async => onCartTap!(),
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    Assets.iconsBasket,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF667B99),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (showCartCount)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE43131),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cartCount > 9 ? cartBadgeOverflowLabel : '$cartCount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
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
