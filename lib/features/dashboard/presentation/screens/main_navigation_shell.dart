import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_system_ui.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../domain/services/promotional_banner_session.dart';
import '../../../bookings/presentation/screens/bookings_dashboard_screen.dart';
import '../../../customer_support/presentation/cubit/customer_support_cubit.dart';
import '../../../customer_support/presentation/screens/customer_support_screen.dart';
import '../../../free_doctor/presentation/cubit/free_doctor_cubit.dart';
import '../../../free_doctor/presentation/screens/free_doctor_screen.dart';
import '../../../profile_setup/presentation/cubit/profile_setup_cubit.dart';
import '../constants/main_navigation_tabs.dart';
import '../widgets/apna_bottom_navigation_bar.dart';
import '../widgets/keep_alive_tab_page.dart';
import '../cubit/main_navigation_cubit.dart';
import '../cubit/main_navigation_state.dart';
import 'home_screen.dart';

/// Root shell: [PageView] body + custom bottom navigation.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  static const int _homeIndex = MainNavigationTabs.home;
  static const int _bookingsIndex = MainNavigationTabs.bookings;

  late final PageController _pageController;
  late final MainNavigationCubit _navigationCubit;
  late final AuthSessionRefresh _sessionRefresh;
  int _appliedSessionEpoch = -1;
  int _tabSessionKey = 0;

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
    _syncTabsWithSessionIfNeeded();
  }

  void _syncTabsWithSessionIfNeeded() {
    if (_sessionRefresh.epoch == _appliedSessionEpoch) return;
    _appliedSessionEpoch = _sessionRefresh.epoch;
    unawaited(_refreshAllTabs());
  }

  void _goToHomeTab() {
    _navigationCubit.setIndex(_homeIndex);
    if (_pageController.hasClients) {
      _pageController.jumpToPage(_homeIndex);
    }
  }

  Future<void> _refreshAllTabs() async {
    final appPref = sl<AppPref>();
    final isLoggedIn = appPref.getLoginStatus();
    final profileComplete = appPref.isProfileCompleted();

    if (_sessionRefresh.consumeSelectHomeTab()) {
      _goToHomeTab();
    }

    sl<ApiService>().refreshToken();

    if (_sessionRefresh.consumeReloadPromotionalBanner()) {
      final bannerSession = sl<PromotionalBannerSession>();
      bannerSession.prepareForLoginRefresh();
      await bannerSession.reload();
    }

    if (!mounted) return;

    context.read<FreeDoctorCubit>().loadContent();
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
    _applyStatusBar();
  }

  void _applyStatusBar() {
    AppSystemUi.apply();
    WidgetsBinding.instance.addPostFrameCallback((_) => AppSystemUi.apply());
  }

  void _onNavTap(int index) {
    if (index == _bookingsIndex && !sl<AppPref>().getLoginStatus()) {
      context.push(AppRoutes.path(AppRoutes.authLogin));
      return;
    }

    _navigationCubit.setIndex(index);
    _applyStatusBar();
  }

  void _syncPageToNavIndex(int index) {
    if (!_pageController.hasClients) return;
    final current = _pageController.page?.round();
    if (current == index) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
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
        child: BlocBuilder<MainNavigationCubit, MainNavigationState>(
          bloc: _navigationCubit,
          builder: (context, state) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: AppSystemUi.overlayStyle,
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
                      key: ValueKey('free_doctor_$_tabSessionKey'),
                      child: const FreeDoctorScreen(showBackButton: false),
                    ),
                    KeepAliveTabPage(
                      key: ValueKey('bookings_$_tabSessionKey'),
                      child: const BookingsDashboardScreen(showBackButton: false),
                    ),
                    KeepAliveTabPage(
                      key: ValueKey('support_$_tabSessionKey'),
                      child: const CustomerSupportScreen(showBackButton: false),
                    ),
                  ],
                ),
                bottomNavigationBar: SafeArea(
                  child: ApnaBottomNavigationBar(
                    currentIndex: state.currentIndex,
                    onTap: _onNavTap,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
