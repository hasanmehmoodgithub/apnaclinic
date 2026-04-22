import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../widgets/menu_about_card.dart';
import '../widgets/menu_action_tile.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_logout_dialog.dart';
import '../widgets/menu_profile_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final AppPref _appPref;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _appPref = sl<AppPref>();
    _isLoggedIn = _appPref.getLoginStatus();
  }

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

  static final List<MenuAboutItemData> _aboutItems = [
    MenuAboutItemData('App Version', subtitle: '1.0'),
    MenuAboutItemData(
      'Terms & Conditions',
      onTap: () => launchUrl(
        Uri.parse('https://apnaclinic.ecnstg.com/terms'),
        mode: LaunchMode.externalApplication,
      ),
    ),
    MenuAboutItemData(
      'Privacy Policy',
      onTap: () => launchUrl(
        Uri.parse('https://apnaclinic.ecnstg.com/privacy-policy'),
        mode: LaunchMode.externalApplication,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userLocal = _appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final phone = userLocal?.phone.trim() ?? '';
    final displayName = fullName.isEmpty ? 'Guest User' : fullName;
    final displayPhone = phone.isEmpty
        ? 'Sign in to manage your account'
        : phone;

    return AppScaffoldGradient(
      colors: const [Color(0xFFD5FFFB), Color(0xFFE0E6FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
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
                            isLoggedIn: _isLoggedIn,
                            name: _isLoggedIn ? displayName : 'Guest User',
                            phone: _isLoggedIn
                                ? displayPhone
                                : 'Sign in to continue',
                            onActionTap: () {
                              if (!_isLoggedIn) {
                                context.push(
                                  AppRoutes.path(AppRoutes.authLogin),
                                );
                                return;
                              }
                              context.push(
                                AppRoutes.path(AppRoutes.profileSetup),
                              );
                            },
                          ),
                          SizedBox(height: 14.h),
                          for (final item in _mainItems) ...[
                            MenuActionTile(
                              onTap: () {
                                if (item.title == 'Customer Support') {
                                  context.push(
                                    AppRoutes.path(AppRoutes.customerSupport),
                                  );
                                  return;
                                }
                                if (item.title == "FAQ’s") {
                                  launchUrl(
                                    Uri.parse('https://apnaclinic.ecnstg.com/faq'),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              title: item.title,
                              icon: item.icon,
                              curveOverlayColor: item.curveOverlayColor,
                            ),
                            SizedBox(height: 14.h),
                          ],
                          MenuAboutCard(
                            items: _aboutItems,
                            onAboutTap: () => launchUrl(
                              Uri.parse('https://apnaclinic.ecnstg.com/'),
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isLoggedIn)
                      Padding(
                        padding: EdgeInsets.fromLTRB(29.w, 0, 29.w, 11.h),
                        child: SizedBox(
                          width: double.infinity,
                          child: AppButton.primary(
                            text: 'Logout',
                            onPressed: () async {
                              final shouldLogout = await showMenuLogoutDialog(
                                context,
                              );
                              if (!shouldLogout) return;
                              await _appPref.setLoginStatus(false);
                              await _appPref.setProfileCompleted(false);
                              await _appPref.setToken('');
                              await _appPref.setUserId('');
                              await _appPref.clearUserLocalModel();
                              if (!context.mounted) return;
                              setState(() {
                                _isLoggedIn = false;
                              });
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
    );
  }
}

class _MenuItem {
  const _MenuItem(this.title, this.icon, this.curveOverlayColor);

  final String title;
  final IconData icon;
  final Color curveOverlayColor;
}
