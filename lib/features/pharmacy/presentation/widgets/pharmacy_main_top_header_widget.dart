import 'package:apnaclinic/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import 'pharmacy_cart_icon_with_count.dart';

/// Hub top: back, title, cart, and banner image. Cart count is supplied by the parent (e.g. [BlocSelector]).
class PharmacyMainTopHeaderWidget extends StatelessWidget {
  const PharmacyMainTopHeaderWidget({
    super.key,
    required this.title,
    required this.cartCount,
    required this.onBackTap,
    required this.onCartTap,
  });

  final String title;
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
          colors: [
            AppColors.clrB8EDE5,
            AppColors.clrE8F8F5,
            AppColors.clrF5FBFA,
          ],
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
                    color: AppColors.clr0B2239,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.clr0B2239,
                      ),
                    ),
                  ),
                  PharmacyCartIconWithCount(
                    cartCount: cartCount,
                    onTap: onCartTap,
                    iconContainerSize: 35.r,
                    badgeRightOffset: 2,
                    badgeTopOffset: 2,
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                Assets.imgPharmacyBanner,
                fit: BoxFit.fitWidth,
                width: context.screenWidth / 2.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
