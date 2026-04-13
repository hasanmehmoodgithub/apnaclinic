import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_system_ui.dart';

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
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.bottom,
  });

  /// White bar; status bar via [AppSystemUi]. Use with [ApnaAppBarStyle.light] on home.
  static const SystemUiOverlayStyle lightBarColoredStatus =
      AppSystemUi.overlayStyle;

  final ApnaAppBarStyle style;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final PreferredSizeWidget? bottom;

  static const String menuAsset = 'assets/svg/ic_menu.svg';
  static const String notificationAsset = 'assets/svg/ic_notification.svg';
  static const String brandAsset = 'assets/svg/brand_apna_clinic.svg';

  static const Color _green = Color(0xFF52A898);

  bool get _isGreen => style == ApnaAppBarStyle.greenHome;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final bg = _isGreen ? _green : Colors.white;
    final svgFilter = _isGreen
        ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
        : null;

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
              children: [
                SizedBox(
                  width: 52,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        splashRadius: 24,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        onPressed: onMenuTap,
                        icon: SvgPicture.asset(
                          menuAsset,
                          width: 23,
                          height: 16,
                          fit: BoxFit.contain,
                          colorFilter: svgFilter,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SvgPicture.asset(
                        brandAsset,
                        height: 34,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        colorFilter: svgFilter,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  splashRadius: 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  tooltip: 'Notifications',
                  onPressed: onNotificationTap,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        notificationAsset,
                        width: 18,
                        height: 22,
                        fit: BoxFit.contain,
                        colorFilter: svgFilter,
                      ),
                      Positioned(
                        right: -1,
                        top: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53935),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onProfileTap,
                      customBorder: const CircleBorder(),
                      child: CircleAvatar(
                        radius: 19,
                        backgroundColor: _isGreen
                            ? Colors.white.withValues(alpha: 0.28)
                            : const Color(0xFFE0F2F1),
                        child: Icon(
                          Icons.person_rounded,
                          size: 24,
                          color: _isGreen
                              ? Colors.white
                              : const Color(0xFF0FAA9A),
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
