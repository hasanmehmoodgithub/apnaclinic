import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class PharmacyScreenHeader extends StatelessWidget {
  const PharmacyScreenHeader({
    super.key,
    required this.cartCount,
    required this.onBackTap,
    required this.onCartTap,
  });

  final int cartCount;
  final VoidCallback onBackTap;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 22.w, 13.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF08294D),
            ),
          ),
          Expanded(
            child: Text(
              'Pharmacy',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0E2D55),
                fontWeight: FontWeight.w700,
                fontSize: 21.sp,
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: onCartTap,
                borderRadius: BorderRadius.circular(18.r),
                child: Container(
                  width: 35.r,
                  height: 35.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.iconsBasket,
                      width: 16.r,
                      height: 16.r,
                      color: const Color(0xFF667B99),
                    ),
                  ),
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  right: -2.w,
                  top: -2.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0FAA9A),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '$cartCount',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
