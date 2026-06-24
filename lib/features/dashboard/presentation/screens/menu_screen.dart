import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/router/app_routes.dart';
import '../../../profile_setup/presentation/profile_setup_launch_source.dart';
import '../../../auth/domain/use_cases/logout_use_case.dart';
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
  late final AuthSessionRefresh _sessionRefresh;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _appPref = sl<AppPref>();
    _sessionRefresh = sl<AuthSessionRefresh>();
    _isLoggedIn = _appPref.getLoginStatus();
    _sessionRefresh.addListener(_onAuthSessionChanged);
  }

  @override
  void dispose() {
    _sessionRefresh.removeListener(_onAuthSessionChanged);
    super.dispose();
  }

  void _onAuthSessionChanged() {
    if (!mounted) return;
    final loggedIn = _appPref.getLoginStatus();
    if (loggedIn == _isLoggedIn) return;
    setState(() => _isLoggedIn = loggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userLocal = _appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final phone = userLocal?.phone.trim() ?? '';
    final displayName = fullName.isEmpty
        ? l10n.dashboardMenuGuestUser
        : fullName;
    final displayPhone = !_isLoggedIn
        ? l10n.dashboardMenuSignInContinue
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
        onTap: () => AppUrlLauncher.open(url:AppUrls.termsAndConditions,lunchMode: LaunchMode.inAppWebView),
      ),
      MenuAboutItemData(
        l10n.dashboardMenuPrivacy,
        onTap: () => AppUrlLauncher.open(url:AppUrls.privacyPolicy,lunchMode: LaunchMode.inAppWebView),
      ),
    ];

    return AppScaffoldGradient(
      colors: const [AppColors.clrD5FFFB, AppColors.clrE0E6FF],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      child: Column(
        children: [
          const MenuHeader(),
          AppScaffoldGradientPanel(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                      padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 18.h),
                      children: [
                        MenuProfileCard(
                          isLoggedIn: _isLoggedIn,
                          name: _isLoggedIn
                              ? displayName
                              : l10n.dashboardMenuGuestUser,
                          phone: displayPhone,
                          imageUrl: _isLoggedIn
                              ? userLocal?.imageUrl
                              : null,
                          onActionTap: () {
                            if (!_isLoggedIn) {
                              context.push(AppRoutes.path(AppRoutes.authLogin));
                              return;
                            }
                            context.push(
                              AppRoutes.path(AppRoutes.profileSetup),
                              extra: ProfileSetupLaunchSource.menu,
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
                                  Uri.parse(
                                    'https://apnaclinic.ecnstg.com/faq',
                                  ),
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
                            final userId = _appPref.getUserId();
                            if (userId.isNotEmpty) {
                              final result = await sl<LogoutUseCase>().call(
                                LogoutParams(
                                  userId: userId,
                                  refreshToken: _appPref.getRefreshToken(),
                                ),
                              );
                              final logoutFailed = result.fold((error) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(error)));
                                return true;
                              }, (_) => false);
                              if (logoutFailed) return;
                            }
                            sl<ApiService>().removeToken();
                            await _appPref.setRefreshToken('');
                            await _appPref.setAccessTokenExpiresIn(0);
                            await _appPref.setRefreshTokenExpiresIn(0);
                            await _appPref.setLoginStatus(false);
                            await _appPref.setProfileCompleted(false);
                            await _appPref.setToken('');
                            await _appPref.setUserId('');
                            await _appPref.clearUserLocalModel();
                            if (sl.isRegistered<NotificationService>()) {
                              final pushService = sl<NotificationService>();
                              if (pushService.isInitialized) {
                                await pushService.deleteToken();
                              }
                            }
                            sl<AuthSessionRefresh>().notifyLoggedOut();
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

enum _MenuItemId { customerSupport, faq }
