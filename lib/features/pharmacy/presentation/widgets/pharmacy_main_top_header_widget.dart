import 'package:apnaclinic/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import 'pharmacy_cart_icon_with_count.dart';

/// Hub top: back, title, cart, delivering-to pill, and banner image.
class PharmacyMainTopHeaderWidget extends StatelessWidget {
  const PharmacyMainTopHeaderWidget({
    super.key,
    required this.title,
    required this.cartCount,
    required this.onBackTap,
    required this.onCartTap,
    this.deliveringToCity,
    this.onDeliveringToTap,
  });

  final String title;
  final int cartCount;
  final VoidCallback onBackTap;
  final VoidCallback onCartTap;
  final String? deliveringToCity;
  final VoidCallback? onDeliveringToTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final city = deliveringToCity?.trim() ?? '';
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
            if (city.isNotEmpty && onDeliveringToTap != null)
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDeliveringToTap,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.clrWhite.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.clrD6DCE2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16.r,
                            color: AppColors.clr0FAA9A,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            l10n.pharmacyDeliveringTo(city),
                            style: TextStyle(
                              color: AppColors.clr0B2239,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
