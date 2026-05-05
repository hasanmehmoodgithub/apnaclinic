import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userLocal = _appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final phone = userLocal?.phone.trim() ?? '';
    final displayName = fullName.isEmpty ? l10n.dashboardMenuGuestUser : fullName;
    final displayPhone = phone.isEmpty
        ? l10n.dashboardMenuSignInManageAccount
        : phone;
    final mainItems = [
      _MenuItem(
        id: _MenuItemId.customerSupport,
        title: l10n.dashboardMenuCustomerSupport,
        icon: Icons.headset_mic_outlined,
        curveOverlayColor: AppColors.clrCAD8FD.withValues(alpha: 0.46),
      ),
      _MenuItem(
        id: _MenuItemId.faq,
        title: l10n.dashboardMenuFaq,
        icon: Icons.help_outline_rounded,
        curveOverlayColor: AppColors.clrEBDFFF.withValues(alpha: 0.46),
      ),
    ];
    final aboutItems = [
      MenuAboutItemData(l10n.dashboardMenuAppVersion, subtitle: '1.0'),
      MenuAboutItemData(
        l10n.dashboardMenuTerms,
        onTap: () => launchUrl(
          Uri.parse('https://apnaclinic.ecnstg.com/terms'),
          mode: LaunchMode.externalApplication,
        ),
      ),
      MenuAboutItemData(
        l10n.dashboardMenuPrivacy,
        onTap: () => launchUrl(
          Uri.parse('https://apnaclinic.ecnstg.com/privacy-policy'),
          mode: LaunchMode.externalApplication,
        ),
      ),
    ];

    return AppScaffoldGradient(
      colors: const [AppColors.clrD5FFFB, AppColors.clrE0E6FF],
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
                            name: _isLoggedIn ? displayName : l10n.dashboardMenuGuestUser,
                            phone: _isLoggedIn
                                ? displayPhone
                                : l10n.dashboardMenuSignInContinue,
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
                          for (final item in mainItems) ...[
                            MenuActionTile(
                              onTap: () {
                                if (item.id == _MenuItemId.customerSupport) {
                                  context.push(
                                    AppRoutes.path(AppRoutes.customerSupport),
                                  );
                                  return;
                                }
                                if (item.id == _MenuItemId.faq) {
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
                            items: aboutItems,
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
                            text: l10n.dashboardMenuLogout,
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
                            backgroundColor: AppColors.clr40AFA2,
                            foregroundColor: AppColors.clrWhite,
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
  const _MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.curveOverlayColor,
  });

  final _MenuItemId id;
  final String title;
  final IconData icon;
  final Color curveOverlayColor;
}

enum _MenuItemId {
  customerSupport,
  faq,
}
