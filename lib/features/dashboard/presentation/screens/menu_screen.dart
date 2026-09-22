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
// TODO(pro): re-enable
// import '../../../../core/widgets/pro_user_avatar.dart';
// import '../../../pro/presentation/widgets/pro_show_info_widget.dart';
import '../../../profile_setup/presentation/profile_setup_launch_source.dart';
// TODO(pro): re-enable
// import '../../../pro/domain/entities/pro_membership_entity.dart';
// import '../../../pro/domain/use_cases/get_pro_catalog_use_case.dart';
// import '../../../pro/presentation/show_pro_bottom_sheet.dart';
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
  String _appVersion = '';
  // TODO(pro): re-enable
  // ProMembershipEntity? _proMembership;
  // bool _isProMembershipLoading = false;

  @override
  void initState() {
    super.initState();
    _appPref = sl<AppPref>();
    _sessionRefresh = sl<AuthSessionRefresh>();
    _isLoggedIn = AuthGuard.isLoggedIn(_appPref);
    _sessionRefresh.addListener(_onAuthSessionChanged);
    unawaited(_loadAppVersion());
    // TODO(pro): re-enable
    // unawaited(_loadProMembership());
  }

  Future<void> _loadAppVersion() async {
    final version = await loadMenuAppVersion();
    if (!mounted || version.isEmpty) return;
    setState(() => _appVersion = version);
  }

  // TODO(pro): re-enable
  // Future<void> _loadProMembership() async {
  //   if (!mounted) return;
  //   setState(() => _isProMembershipLoading = true);
  //   final result = await sl<GetProCatalogUseCase>()();
  //   if (!mounted) return;
  //   result.fold(
  //     (_) {
  //       setState(() {
  //         _proMembership = null;
  //         _isProMembershipLoading = false;
  //       });
  //     },
  //     (catalog) {
  //       setState(() {
  //         _proMembership = catalog.membership;
  //         _isProMembershipLoading = false;
  //       });
  //     },
  //   );
  // }

  @override
  void dispose() {
    _sessionRefresh.removeListener(_onAuthSessionChanged);
    super.dispose();
  }

  void _onAuthSessionChanged() {
    if (!mounted) return;
    setState(() {
      _isLoggedIn = AuthGuard.isLoggedIn(_appPref);
    });
    // TODO(pro): re-enable
    // unawaited(_loadProMembership());
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
    _sessionRefresh.requestTabIndex(MainNavigationTabs.bookings);
    if (!AuthGuard.isLoggedIn()) {
      AuthGuard.pushLogin(context).then((_) {
        if (!mounted) return;
        if (AuthGuard.isLoggedIn() && context.canPop()) {
          context.pop();
        }
      });
      return;
    }
    context.pop();
  }

  // TODO(pro): re-enable
  // Future<void> _openPro() async {
  //   await showApnaClinicProSheet(context);
  //   if (!mounted) return;
  //   unawaited(_loadProMembership());
  // }

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
    setState(() => _isLoggedIn = AuthGuard.isLoggedIn(_appPref));
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
                // TODO(pro): re-enable temp Pro debug widgets
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ProShowInfoWidget(
                //     title: "Lab Tests Discount",
                //     discount: "30%",
                //     subtitle:
                //         "Become a pro member to get additional discount",
                //   ),
                // ),
                // ProUserAvatar(imageUrl: "", size: 60, isPro: true),
                Expanded(
                  child: MenuScreenBody(
                    profile: profile,
                    actionItems: buildMenuActionItems(l10n),
                    aboutItems: buildMenuAboutItems(
                      l10n,
                      appVersion: _appVersion,
                    ),
                    onProfileActionTap: _openEditProfile,
                    onActionTap: _onMenuActionTap,
                    onAboutTap: openMenuWebsite,
                    // TODO(pro): re-enable
                    // proMembership: _proMembership,
                    // onProTap: () => unawaited(_openPro()),
                    // isProMembershipLoading: _isProMembershipLoading,
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
