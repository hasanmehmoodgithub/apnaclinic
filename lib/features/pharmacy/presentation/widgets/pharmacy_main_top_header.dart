import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class PharmacyMainTopHeader extends StatelessWidget {
  const PharmacyMainTopHeader({
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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB8EDE5), Color(0xFFE8F8F5), Color(0xFFF5FBFA)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBackTap,
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: const Color(0xFF0B2239),
                  ),
                  Expanded(
                    child: Text(
                      'Pharmacy',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0B2239),
                      ),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton.filledTonal(
                        onPressed: onCartTap,
                        icon: SvgPicture.asset(
                          Assets.iconsBasket,
                          width: 16.r,
                          height: 16.r,
                          color: const Color(0xFF667B99),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF667B99),
                        ),
                      ),
                      if (cartCount > 0)
                        Positioned(
                          right: 2,
                          top: 2,
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
                  SizedBox(width: 6.w),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 120.w),
                child: ClipRect(
                  child: Align(
                    alignment: const Alignment(0, 0.3),
                    heightFactor: 0.82,
                    child: Image.asset(
                      Assets.imgPharmacyBanner,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
