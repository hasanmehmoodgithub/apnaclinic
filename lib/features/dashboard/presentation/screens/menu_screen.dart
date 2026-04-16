import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/menu_about_card.dart';
import '../widgets/menu_action_tile.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_profile_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static final List<_MenuItem> _mainItems = [
    // _MenuItem(
    //   'My Bookings',
    //   Icons.calendar_month_outlined,
    //   Color(0xFFE8F4FF),
    // ),
    _MenuItem(
      'Customer Support',
      Icons.headset_mic_outlined,
      Color(0xFFCAD8FD).withValues(alpha: 0.46),
    ),
    _MenuItem(
      "FAQ’s",
      Icons.help_outline_rounded,
      Color(0xFFEBDFFF).withValues(alpha: 0.46),
    ),
  ];

  static const List<MenuAboutItemData> _aboutItems = [
    MenuAboutItemData('App Version', subtitle: '1.0'),
    MenuAboutItemData('Terms & Condition'),
    MenuAboutItemData('Privacy Policy'),
  ];

  @override
  Widget build(BuildContext context) {
    final appPref = sl<AppPref>();
    final isLoggedIn = appPref.getLoginStatus();
    final firstName = (appPref.getString('profile_first_name') ?? '').trim();
    final lastName = (appPref.getString('profile_last_name') ?? '').trim();
    final fullName = '$firstName $lastName'.trim();
    final phone = (appPref.getString('profile_phone') ?? '').trim();
    final displayName = fullName.isEmpty ? 'Guest User' : fullName;
    final displayPhone = phone.isEmpty
        ? 'Sign in to manage your account'
        : phone;

    return Scaffold(
      backgroundColor: const Color(0xFFC7EFEB),
      body: SafeArea(
        child: Column(
          children: [
            const MenuHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(42.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 18.h),
                        children: [
                          MenuProfileCard(
                            isLoggedIn: isLoggedIn,
                            name: isLoggedIn ? displayName : 'Guest User',
                            phone: isLoggedIn
                                ? displayPhone
                                : 'Sign in to continue',
                            onActionTap: () {
                              if (!isLoggedIn) {
                                context.push(
                                  AppRoutes.path(AppRoutes.authLogin),
                                );
                                return;
                              }
                              // TODO: wire Edit Profile screen when available.
                            },
                          ),
                          SizedBox(height: 14.h),
                          for (final item in _mainItems) ...[
                            MenuActionTile(
                              onTap: () {},
                              title: item.title,
                              icon: item.icon,
                              curveOverlayColor: item.curveOverlayColor,
                            ),
                            SizedBox(height: 14.h),
                          ],
                          MenuAboutCard(items: _aboutItems),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(29.w, 0, 29.w, 11.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton.primary(
                          text: isLoggedIn ? 'Logout' : 'Login',
                          onPressed: () async {
                            if (!isLoggedIn) {
                              context.push(AppRoutes.path(AppRoutes.authLogin));
                              return;
                            }
                            await appPref.setLoginStatus(false);
                            await appPref.setProfileCompleted(false);
                            await appPref.setToken('');
                            await appPref.setUserId('');
                            await appPref.remove('profile_first_name');
                            await appPref.remove('profile_last_name');
                            await appPref.remove('profile_phone');
                            await appPref.remove('profile_gender');
                            await appPref.remove('profile_email');
                            await appPref.remove('profile_address');
                            await appPref.remove('profile_dob');
                            if (!context.mounted) return;
                            context.go(AppRoutes.path(AppRoutes.home));
                          },
                          backgroundColor: const Color(0xFF40AFA2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          height: 62.h,
                          borderRadius: 13.r,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.title, this.icon, this.curveOverlayColor);

  final String title;
  final IconData icon;
  final Color curveOverlayColor;
}
