import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

/// White bar with four side tabs and a raised center Home button.
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
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 0.h,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 66.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.clrWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.clrBlack.withValues(alpha: 0.08),
                      blurRadius: 16.r,
                      offset: Offset(0, -4.h),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 8.w,),
                    Expanded(
                      child: _SideTab(
                        label: l10n.dashboardBottomFreeDoctor,
                        asset: Assets.svgNavFreeDoctor,
                        selected: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),
                    ),
                    Expanded(
                      child: _SideTab(
                        label: l10n.dashboardBottomSupport,
                        asset: Assets.svgNavSupport,
                        selected: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),
                    ),
                    SizedBox(width: 66.w),
                    Expanded(
                      child: _SideTab(
                        label: l10n.dashboardBottomBookings,
                        asset: Assets.svgNavBookings,
                        selected: currentIndex == 3,
                        onTap: () => onTap(3),
                      ),
                    ),
                    Expanded(
                      child: _SideTab(
                        label: l10n.dashboardBottomProfile,
                        asset: Assets.svgNavProfile,
                        selected: currentIndex == 4,
                        onTap: () => onTap(4),
                      ),
                    ),
                    SizedBox(width: 8.w,),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12.h,
              child: _HomeCenterButton(
                label: l10n.dashboardBottomHome,
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideTab extends StatelessWidget {
  const _SideTab({
    required this.label,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.clr26A69A
        : AppColors.clr024886;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h, top: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              asset,
              width: 24.r,
              height: 24.r,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                height: 1.1,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCenterButton extends StatelessWidget {
  const _HomeCenterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelColor = selected
        ? AppColors.clr26A69A
        : AppColors.clr024886;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 64.r,
              height: 64.r,
              child: SvgPicture.asset(
                Assets.svgNavHomeLogo,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
