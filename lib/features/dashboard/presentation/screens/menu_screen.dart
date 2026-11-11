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
import '../../../pro/domain/entities/pro_membership_entity.dart';
import '../../../pro/domain/use_cases/get_pro_catalog_use_case.dart';
import '../../../pro/presentation/pro_membership_cache.dart';
import '../../../pro/presentation/show_pro_bottom_sheet.dart';
import '../../domain/services/home_pro_banner_session.dart';
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
  late final HomeProBannerSession _proBannerSession;
  bool _isLoggedIn = false;
  String _appVersion = '';
  ProMembershipEntity? _proMembership;
  bool _isProMembershipLoading = false;
  late int _appliedEpoch;
  late int _appliedProRevision;

  @override
  void initState() {
    super.initState();
    _appPref = sl<AppPref>();
    _sessionRefresh = sl<AuthSessionRefresh>();
    _proBannerSession = sl<HomeProBannerSession>();
    _isLoggedIn = AuthGuard.isLoggedIn(_appPref);
    _appliedEpoch = _sessionRefresh.epoch;
    _appliedProRevision = _sessionRefresh.proMembershipRevision;
    _sessionRefresh.addListener(_onAuthSessionChanged);
    _proBannerSession.addListener(_onProBannerChanged);
    unawaited(_loadAppVersion());
    _restoreOrLoadProMembership();
  }

  void _onProBannerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadAppVersion() async {
    final version = await loadMenuAppVersion();
    if (!mounted || version.isEmpty) return;
    setState(() => _appVersion = version);
  }

  void _restoreOrLoadProMembership() {
    final cache = sl<ProMembershipCache>();
    final epoch = _sessionRefresh.epoch;
    final revision = _sessionRefresh.proMembershipRevision;
    if (cache.matches(sessionEpoch: epoch, proRevision: revision)) {
      _proMembership = cache.snapshot!.membership;
      _isProMembershipLoading = false;
      return;
    }
    final expected = _sessionRefresh.expectedProActive;
    if (expected != null) {
      if (!expected) {
        _proMembership = const ProMembershipEntity(
          isPro: false,
          status: 'none',
        );
        _isProMembershipLoading = false;
      } else {
        _isProMembershipLoading = true;
      }
      unawaited(_loadProMembershipUntil(expected));
      return;
    }
    _isProMembershipLoading = true;
    unawaited(_loadProMembership());
  }

  void _rememberProMembership(ProMembershipEntity membership) {
    sl<ProMembershipCache>().save(
      membership,
      sessionEpoch: _sessionRefresh.epoch,
      proRevision: _sessionRefresh.proMembershipRevision,
    );
  }

  Future<void> _loadProMembership() async {
    if (!mounted) return;
    setState(() => _isProMembershipLoading = true);
    final result = await sl<GetProCatalogUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) {
        setState(() {
          _proMembership = null;
          _isProMembershipLoading = false;
        });
      },
      (catalog) {
        _rememberProMembership(catalog.membership);
        setState(() {
          _proMembership = catalog.membership;
          _isProMembershipLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _sessionRefresh.removeListener(_onAuthSessionChanged);
    _proBannerSession.removeListener(_onProBannerChanged);
    super.dispose();
  }

  void _onAuthSessionChanged() {
    if (!mounted) return;
    setState(() {
      _isLoggedIn = AuthGuard.isLoggedIn(_appPref);
    });
    final epoch = _sessionRefresh.epoch;
    final revision = _sessionRefresh.proMembershipRevision;
    if (epoch != _appliedEpoch) {
      _appliedEpoch = epoch;
      _appliedProRevision = revision;
      // Prefer Home's cached membership; fetch only on cache miss.
      _restoreOrLoadProMembership();
      setState(() {});
      return;
    }
    if (revision == _appliedProRevision) return;
    _appliedProRevision = revision;
    final expected = _sessionRefresh.expectedProActive;
    if (expected != null) {
      unawaited(_loadProMembershipUntil(expected));
      return;
    }
    // Membership revision bumped without an expected flag — reuse cache if
    // Home already refreshed it for this revision.
    _restoreOrLoadProMembership();
    setState(() {});
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

  Future<void> _openPro() async {
    await showApnaClinicProSheet(context, showServiceActions: true);
  }

  Future<void> _loadProMembershipUntil(bool isActive) async {
    if (mounted && !isActive) {
      setState(() {
        _proMembership = const ProMembershipEntity(
          isPro: false,
          status: 'none',
        );
        _isProMembershipLoading = false;
      });
    }
    ProMembershipEntity? latest;
    for (var attempt = 0; attempt < 4; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(const Duration(seconds: 2));
        if (!mounted) return;
      }
      final result = await sl<GetProCatalogUseCase>()();
      if (!mounted) return;
      final catalog = result.fold((_) => null, (value) => value);
      if (catalog == null) continue;
      latest = catalog.membership;
      if (latest.isActivePro == isActive) {
        _rememberProMembership(latest);
        setState(() {
          _proMembership = latest;
          _isProMembershipLoading = false;
        });
        return;
      }
    }
    if (!mounted || latest == null) {
      if (mounted) {
        setState(() => _isProMembershipLoading = false);
      }
      return;
    }
    _rememberProMembership(latest);
    setState(() {
      _proMembership = latest;
      _isProMembershipLoading = false;
    });
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
                    proMembership: _proMembership,
                    onProTap: () => unawaited(_openPro()),
                    isProMembershipLoading: _isProMembershipLoading,
                    proPromoImageUrl: _proBannerSession.bannerUrl,
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
