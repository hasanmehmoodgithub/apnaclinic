import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../constants/main_navigation_tabs.dart';

/// Flat four-tab bottom bar: Home, Instant Doctor, Bookings, Support.
class ApnaBottomNavigationBar extends StatelessWidget {
  const ApnaBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.clrBlack.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 58.h,
        child: Row(
          children: [
            Expanded(
              child: _NavTab(
                label: l10n.dashboardBottomHome,
                filledAsset: Assets.svgNavHomeFilled,
                outlineAsset: Assets.svgNavHomeOutline,
                selected: currentIndex == MainNavigationTabs.home,
                onTap: () => onTap(MainNavigationTabs.home),
              ),
            ),
            Expanded(
              child: _NavTab(
                label: l10n.dashboardBottomFreeDoctor,
                filledAsset: Assets.svgNavInstantDoctorFilled,
                outlineAsset: Assets.svgNavInstantDoctorOutline,
                selected: currentIndex == MainNavigationTabs.instantDoctor,
                onTap: () => onTap(MainNavigationTabs.instantDoctor),
              ),
            ),
            Expanded(
              child: _NavTab(
                label: l10n.dashboardBottomBookings,
                filledAsset: Assets.svgNavBookingsFilled,
                outlineAsset: Assets.svgNavBookingsOutline,
                selected: currentIndex == MainNavigationTabs.bookings,
                onTap: () => onTap(MainNavigationTabs.bookings),
              ),
            ),
            Expanded(
              child: _NavTab(
                label: l10n.dashboardBottomSupport,
                filledAsset: Assets.svgNavSupportFilled,
                outlineAsset: Assets.svgNavSupportOutline,
                selected: currentIndex == MainNavigationTabs.support,
                onTap: () => onTap(MainNavigationTabs.support),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.label,
    required this.filledAsset,
    required this.outlineAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String filledAsset;
  final String outlineAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.clr09 : AppColors.clr6B7280;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                selected ? filledAsset : outlineAsset,
                width: 24.r,
                height: 24.r,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  height: 1.1,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
