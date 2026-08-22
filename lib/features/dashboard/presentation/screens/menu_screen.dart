import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../core/widgets/user_profile_avatar.dart';
import '../../../profile_setup/presentation/profile_setup_launch_source.dart';
import '../constants/main_navigation_tabs.dart';
import '../helpers/menu_logout_handler.dart';
import '../helpers/menu_profile_mapper.dart';
import '../helpers/menu_screen_config.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_logout_button.dart';
import '../widgets/menu_screen_body.dart';

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
    _isLoggedIn = AuthGuard.isLoggedIn(_appPref);
    _sessionRefresh.addListener(_onAuthSessionChanged);
  }

  @override
  void dispose() {
    _sessionRefresh.removeListener(_onAuthSessionChanged);
    super.dispose();
  }

  void _onAuthSessionChanged() {
    if (!mounted) return;
    // Always rebuild so name/phone from prefs appear after OTP → profile hydrate.
    setState(() {
      _isLoggedIn = AuthGuard.isLoggedIn(_appPref);
    });
  }

  Future<void> _openEditProfile() async {
    if (!context.requireLogin()) return;
    await context.push(
      AppRoutes.path(AppRoutes.profileSetup),
      extra: ProfileSetupLaunchSource.menu,
    );
    if (!mounted) return;
    await UserProfileAvatar.evictCachedUrl(
      _appPref.getUserLocalModel()?.imageUrl,
    );
    if (!mounted) return;
    setState(() {
      _isLoggedIn = AuthGuard.isLoggedIn(_appPref);
    });
  }

  void _openMyBookings() {
    unawaited(
      sl<AnalyticsService>().logEvent(AnalyticsEventKeys.myBookingsClicked),
    );
    // Remember Bookings tab before login so guest return lands there.
    _sessionRefresh.requestTabIndex(MainNavigationTabs.bookings);
    if (!AuthGuard.isLoggedIn()) {
      context.push(AppRoutes.path(AppRoutes.authLogin)).then((_) {
        if (!mounted) return;
        if (AuthGuard.isLoggedIn() && context.canPop()) {
          context.pop(); // close menu after successful login
        }
      });
      return;
    }
    context.pop();
  }

  void _onMenuActionTap(MenuActionId actionId) {
    switch (actionId) {
      case MenuActionId.myBookings:
        _openMyBookings();
        return;
      case MenuActionId.customerSupport:
        unawaited(
          sl<AnalyticsService>().logEvent(AnalyticsEventKeys.supportClicked),
        );
        context.push(AppRoutes.path(AppRoutes.customerSupport));
        return;
      case MenuActionId.faq:
        openMenuFaq();
        return;
    }
  }

  Future<void> _onLogoutTap() async {
    await handleMenuLogoutTap(context);
    if (!mounted) return;
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = buildMenuProfileViewData(
      appPref: _appPref,
      l10n: l10n,
      profileRevision: _sessionRefresh.profileRevision,
    );

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
                  child: MenuScreenBody(
                    profile: profile,
                    actionItems: buildMenuActionItems(l10n),
                    aboutItems: buildMenuAboutItems(l10n),
                    onProfileActionTap: _openEditProfile,
                    onActionTap: _onMenuActionTap,
                    onAboutTap: openMenuWebsite,
                  ),
                ),
                if (_isLoggedIn) MenuLogoutButton(onPressed: _onLogoutTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
