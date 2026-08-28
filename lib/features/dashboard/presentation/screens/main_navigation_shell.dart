import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_system_ui.dart';
import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../domain/services/promotional_banner_session.dart';
import '../../../bookings/presentation/screens/bookings_dashboard_screen.dart';
import '../../../bookings/presentation/bookings_analytics.dart';
import '../../../customer_support/presentation/cubit/customer_support_cubit.dart';
import '../../../customer_support/presentation/screens/customer_support_screen.dart';
import '../../../instant_doctor/presentation/cubit/instant_doctor_cubit.dart';
import '../../../instant_doctor/presentation/screens/instant_doctor_screen.dart';
import '../../../profile_setup/presentation/cubit/profile_setup_cubit.dart';
import '../constants/main_navigation_tabs.dart';
import '../widgets/apna_bottom_navigation_bar.dart';
import '../widgets/app_close_dialog.dart';
import '../widgets/keep_alive_tab_page.dart';
import '../cubit/main_navigation_cubit.dart';
import '../cubit/main_navigation_state.dart';
import 'home_screen.dart';

/// Matches bottom nav so no strip shows below the bar (system gesture area).
const _shellSystemUi = SystemUiOverlayStyle(
  statusBarColor: AppSystemUi.statusBarColor,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: AppColors.clrWhite,
  systemNavigationBarIconBrightness: Brightness.dark,
);

/// Root shell: [PageView] body + custom bottom navigation.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  static const int _homeIndex = MainNavigationTabs.home;
  static const int _instantDoctorIndex = MainNavigationTabs.instantDoctor;
  static const int _bookingsIndex = MainNavigationTabs.bookings;

  late final PageController _pageController;
  late final MainNavigationCubit _navigationCubit;
  late final AuthSessionRefresh _sessionRefresh;
  int _appliedSessionEpoch = -1;
  int _appliedTabRequestRevision = 0;
  int _tabSessionKey = 0;
  int _bookingsInitialTabIndex = 0;
  int _bookingsDashboardKey = 0;
  bool _isCloseDialogVisible = false;
  bool _isSyncingPage = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _homeIndex);
    _navigationCubit = MainNavigationCubit(initialIndex: _homeIndex);
    _sessionRefresh = sl<AuthSessionRefresh>();
    _appliedSessionEpoch = _sessionRefresh.epoch;
    _sessionRefresh.addListener(_onAuthSessionChanged);
    _applyStatusBar();
  }

  @override
  void dispose() {
    _sessionRefresh.removeListener(_onAuthSessionChanged);
    AppSystemUi.apply();
    _pageController.dispose();
    _navigationCubit.close();
    super.dispose();
  }

  void _onAuthSessionChanged() {
    if (!mounted) return;
    // Apply pending tab after session sync so it wins over default Home.
    _syncTabsWithSessionIfNeeded();
  }

  void _applyPendingTabIfNeeded() {
    // Keep pending while guest — `requestTabIndex` notifies immediately when
    // opening login, and must not be consumed until after OTP success.
    if (!AuthGuard.isLoggedIn()) return;
    final bookingsSubTab = _sessionRefresh.consumePendingBookingsSubTabIndex();
    if (bookingsSubTab != null) {
      setState(() {
        _bookingsInitialTabIndex = bookingsSubTab;
        _bookingsDashboardKey++;
      });
    }
    final tabIndex = _sessionRefresh.consumePendingTabIndex();
    if (tabIndex == null) return;
    if (tabIndex == _instantDoctorIndex) {
      final source =
          _sessionRefresh.consumePendingInstantDoctorSourceScreen() ??
          AnalyticsInstantDoctorSourceKeys.bottomTab;
      context.read<InstantDoctorCubit>().logModuleViewed(source);
    }
    if (tabIndex == _bookingsIndex &&
        _navigationCubit.state.currentIndex != tabIndex) {
      BookingsAnalytics.logMyBookingsTab();
    }
    _navigationCubit.setIndex(tabIndex);
    _jumpToTab(tabIndex);
    _applyStatusBar();
  }

  void _syncTabsWithSessionIfNeeded() {
    if (_sessionRefresh.epoch != _appliedSessionEpoch) {
      _appliedSessionEpoch = _sessionRefresh.epoch;
      unawaited(_refreshAllTabs());
      return;
    }
    // Profile-name updates must not consume a pending Instant Doctor /
    // Bookings tab while OTP Verify is still showing its spinner.
    _applyPendingTabIfRequested();
  }

  void _applyPendingTabIfRequested() {
    if (_sessionRefresh.tabRequestRevision == _appliedTabRequestRevision) {
      return;
    }
    _appliedTabRequestRevision = _sessionRefresh.tabRequestRevision;
    _applyPendingTabIfNeeded();
  }

  void _goToHomeTab() {
    _navigationCubit.setIndex(_homeIndex);
    _jumpToTab(_homeIndex);
    _applyStatusBar();
  }

  Future<void> _onBackRequested() async {
    if (_navigationCubit.state.currentIndex != _homeIndex) {
      _goToHomeTab();
      return;
    }
    if (_isCloseDialogVisible) return;
    _isCloseDialogVisible = true;
    final shouldExit = await showAppCloseDialog(context);
    _isCloseDialogVisible = false;
    if (shouldExit && mounted) {
      SystemNavigator.pop();
    }
  }

  Future<void> _refreshAllTabs() async {
    final appPref = sl<AppPref>();
    final isLoggedIn = AuthGuard.isLoggedIn(appPref);
    final profileComplete = appPref.isProfileCompleted();

    if (_sessionRefresh.consumeSelectHomeTab()) {
      _goToHomeTab();
    }

    sl<ApiService>().refreshToken();

    if (_sessionRefresh.consumeReloadPromotionalBanner()) {
      // Clear cached queue; HomeScreen / DashboardCubit fetches on open.
      sl<PromotionalBannerSession>().prepareForLoginRefresh();
    }

    if (!mounted) return;

    if (isLoggedIn) {
      context.read<InstantDoctorCubit>().loadContent();
    }
    context.read<CustomerSupportCubit>().loadContent();

    final profileCubit = context.read<ProfileSetupCubit>();
    if (isLoggedIn && profileComplete) {
      await profileCubit.loadProfile();
    } else if (!isLoggedIn) {
      profileCubit.resetState();
    }

    if (!mounted) return;
    // Avoid remounting HomeScreen (new DashboardCubit → heart loader) while
    // the user still owes profile setup.
    if (!isLoggedIn || profileComplete) {
      setState(() => _tabSessionKey++);
    }
    // Let the OTP screen finish emitting isLoading: false before we
    // remount tabs / jump to Bookings.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyPendingTabIfNeeded();
      _applyStatusBar();
    });
  }

  void _applyStatusBar() {
    AppSystemUi.apply();
    WidgetsBinding.instance.addPostFrameCallback((_) => AppSystemUi.apply());
  }

  void _onNavTap(int index) {
    if (index == _bookingsIndex) {
      unawaited(
        sl<AnalyticsService>().logEvent(AnalyticsEventKeys.myBookingsClicked),
      );
    } else if (index == MainNavigationTabs.support) {
      unawaited(
        sl<AnalyticsService>().logEvent(AnalyticsEventKeys.supportClicked),
      );
    }

    if ((index == _instantDoctorIndex || index == _bookingsIndex) &&
        !AuthGuard.isLoggedIn()) {
      _sessionRefresh.requestTabIndex(
        index,
        instantDoctorSourceScreen: index == _instantDoctorIndex
            ? AnalyticsInstantDoctorSourceKeys.bottomTab
            : null,
      );
      context.requireLogin(
        loginSource: index == _instantDoctorIndex
            ? AnalyticsAuthSourceKeys.instantDoctor
            : AnalyticsAuthSourceKeys.login,
      );
      return;
    }

    if (index == _instantDoctorIndex &&
        _navigationCubit.state.currentIndex != index) {
      context.read<InstantDoctorCubit>().logModuleViewed(
        AnalyticsInstantDoctorSourceKeys.bottomTab,
      );
    }
    if (index == _bookingsIndex &&
        _navigationCubit.state.currentIndex != index) {
      BookingsAnalytics.logMyBookingsTab();
    }

    _navigationCubit.setIndex(index);
    _applyStatusBar();
  }

  void _jumpToTab(int index) {
    if (!_pageController.hasClients) return;
    final current = _pageController.page?.round();
    if (current == index) return;
    _isSyncingPage = true;
    _pageController.jumpToPage(index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isSyncingPage = false;
    });
  }

  void _syncPageToNavIndex(int index) {
    _jumpToTab(index);
  }

  void _onPageChanged(int index) {
    if (_isSyncingPage) {
      _navigationCubit.setIndex(index);
      return;
    }
    final previous = _navigationCubit.state.currentIndex;
    if (index == _instantDoctorIndex && previous != index) {
      context.read<InstantDoctorCubit>().logModuleViewed(
        AnalyticsInstantDoctorSourceKeys.bottomTab,
      );
    }
    if (index == _bookingsIndex && previous != index) {
      BookingsAnalytics.logMyBookingsTab();
    }
    _navigationCubit.setIndex(index);
    _applyStatusBar();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _navigationCubit,
      child: BlocListener<MainNavigationCubit, MainNavigationState>(
        listenWhen: (previous, current) =>
            previous.currentIndex != current.currentIndex,
        listener: (context, state) => _syncPageToNavIndex(state.currentIndex),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: _shellSystemUi,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              _onBackRequested();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  KeepAliveTabPage(
                    key: ValueKey('home_$_tabSessionKey'),
                    child: const HomeScreen(),
                  ),
                  KeepAliveTabPage(
                    key: ValueKey('instant_doctor_$_tabSessionKey'),
                    child: const InstantDoctorScreen(showBackButton: false),
                  ),
                  KeepAliveTabPage(
                    key: ValueKey('bookings_dash_$_bookingsDashboardKey'),
                    child: BookingsDashboardScreen(
                      showBackButton: false,
                      initialTabIndex: _bookingsInitialTabIndex,
                    ),
                  ),
                  KeepAliveTabPage(
                    key: ValueKey('support_$_tabSessionKey'),
                    child: const CustomerSupportScreen(
                      showBackButton: false,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BlocBuilder<MainNavigationCubit, MainNavigationState>(
                bloc: _navigationCubit,
                buildWhen: (previous, current) =>
                    previous.currentIndex != current.currentIndex,
                builder: (context, state) {
                  return ApnaBottomNavigationBar(
                    currentIndex: state.currentIndex,
                    onTap: _onNavTap,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
