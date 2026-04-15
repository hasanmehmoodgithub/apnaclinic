import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// White bar with four side tabs and a raised center Home button.
class ApnaBottomNavigationBar extends StatelessWidget {
  const ApnaBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const Color inactiveColor = Color(0xFF024886);
  static const Color activeColor = Color(0xFF26A69A);

  static const String freeDoctor = 'assets/svg/nav_free_doctor.svg';
  static const String support = 'assets/svg/nav_support.svg';
  static const String homeLogo = 'assets/svg/nav_home_logo.svg';
  static const String bookings = 'assets/svg/nav_bookings.svg';
  static const String profile = 'assets/svg/nav_profile.svg';

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: 108.h,
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16.r,
                        offset: Offset(0, -4.h),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _SideTab(
                          label: 'Free Doctor',
                          asset: freeDoctor,
                          selected: currentIndex == 0,
                          onTap: () => onTap(0),
                        ),
                      ),
                      Expanded(
                        child: _SideTab(
                          label: 'Support',
                          asset: support,
                          selected: currentIndex == 1,
                          onTap: () => onTap(1),
                        ),
                      ),
                      SizedBox(width: 76.w),
                      Expanded(
                        child: _SideTab(
                          label: 'My Bookings',
                          asset: bookings,
                          selected: currentIndex == 3,
                          onTap: () => onTap(3),
                        ),
                      ),
                      Expanded(
                        child: _SideTab(
                          label: 'Profile',
                          asset: profile,
                          selected: currentIndex == 4,
                          onTap: () => onTap(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12.h,
                child: _HomeCenterButton(
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
              ),
            ],
          ),
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
        ? ApnaBottomNavigationBar.activeColor
        : ApnaBottomNavigationBar.inactiveColor;

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
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelColor = selected
        ? ApnaBottomNavigationBar.activeColor
        : ApnaBottomNavigationBar.inactiveColor;

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
                ApnaBottomNavigationBar.homeLogo,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Home',
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
