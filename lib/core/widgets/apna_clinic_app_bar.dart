import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../generated/assets.dart';
import '../constants/app_colors.dart';
import '../extensions/screen_util_extensions.dart';

import '../constants/app_system_ui.dart';
import 'user_profile_avatar.dart';

/// Top bar: menu, brand (logo + wordmark), notification, profile.
/// Plain [Material] + [Row] (not [AppBar]); still [PreferredSizeWidget] for [Scaffold.appBar].
enum ApnaAppBarStyle {
  /// White bar (default).
  light,

  /// Teal-green bar + white icons.
  greenHome,
}

class ApnaClinicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ApnaClinicAppBar({
    super.key,
    this.style = ApnaAppBarStyle.light,
    this.systemOverlayStyle,
    this.transparentBackground = false,
    this.onMenuTap,
    this.onNotificationTap,
    this.notificationCount,
    this.showNotificationDot = false,
    this.onProfileTap,
    this.onLoginTap,
    this.showLoginButton = false,
    this.filledLoginButton = false,
    this.profileImageUrl,
    this.bottom,
  });

  /// White bar; status bar via [AppSystemUi]. Use with [ApnaAppBarStyle.light] on home.
  static const SystemUiOverlayStyle lightBarColoredStatus =
      AppSystemUi.overlayStyle;

  final ApnaAppBarStyle style;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool transparentBackground;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final int? notificationCount;
  final bool showNotificationDot;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLoginTap;
  final bool showLoginButton;
  final bool filledLoginButton;
  final String? profileImageUrl;
  final PreferredSizeWidget? bottom;



  static const Color _green = Color(0xFF52A898);

  bool get _isGreen => style == ApnaAppBarStyle.greenHome;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final bg = transparentBackground
        ? Colors.transparent
        : (_isGreen ? _green : Colors.white);
    final svgFilter = _isGreen
        ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
        : const ColorFilter.mode(AppColors.clr52A898, BlendMode.srcIn);
    final wordmarkColor = _isGreen ? Colors.white : AppColors.clr52A898;

    final bar = Material(
      color: bg,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 52.w,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: IconButton(
                        splashRadius: 24.r,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 40.w,
                          minHeight: 40.h,
                        ),

                        onPressed: onMenuTap,

                        icon: Image.asset(
                          Assets.imgIcMenuDrawer,
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.contain,
                          color: wordmarkColor,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Image.asset(
                        Assets.imgBrandApnaclinicHome,
                        height: 26.h,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        color: wordmarkColor,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  splashRadius: 24.r,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 44.w,
                    minHeight: 44.h,
                  ),
                  tooltip: 'Notifications',
                  onPressed: onNotificationTap,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.svgIcNotification,
                        width: 30.r,
                        height: 30.r,
                        fit: BoxFit.contain,
                        colorFilter: svgFilter,
                      ),
                      if ((notificationCount ?? 0) > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5353),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '${notificationCount!}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                              ),
                            ),
                          ),
                        )
                      else if (showNotificationDot)
                        Positioned(
                          right: 2.w,
                          top: 2.h,
                          child: Container(
                            width: 9.r,
                            height: 9.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF5353),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.w, left: 4.w),
                  child: showLoginButton
                      ? filledLoginButton
                          ? Material(
                              color: AppColors.clrWhite,
                              borderRadius: BorderRadius.circular(10.r),
                              child: InkWell(
                                onTap: onLoginTap,
                                borderRadius: BorderRadius.circular(10.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: _green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 36.h,
                              child: OutlinedButton(
                                onPressed: onLoginTap,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: _isGreen
                                        ? Colors.white
                                        : const Color(0xFF0FAA9A),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                  ),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: _isGreen
                                        ? Colors.white
                                        : const Color(0xFF0FAA9A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            )
                      : Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onProfileTap,
                            customBorder: const CircleBorder(),
                            child: Padding(
                              padding: EdgeInsets.all(6.sp),
                              child: UserProfileAvatar(
                                imageUrl: profileImageUrl,
                                size: 40.r,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (bottom != null)
            SizedBox(
              height: bottom!.preferredSize.height,
              width: double.infinity,
              child: bottom!,
            ),
        ],
      ),
    );

    if (systemOverlayStyle != null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemOverlayStyle!,
        child: bar,
      );
    }
    return bar;
  }
}
