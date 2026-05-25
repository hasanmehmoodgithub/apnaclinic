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
import '../../../bookings/presentation/screens/bookings_dashboard_screen.dart';
import '../../../customer_support/presentation/cubit/customer_support_cubit.dart';
import '../../../customer_support/presentation/screens/customer_support_screen.dart';
import '../../../free_doctor/presentation/cubit/free_doctor_cubit.dart';
import '../../../free_doctor/presentation/screens/free_doctor_screen.dart';
import '../../../profile_setup/presentation/cubit/profile_setup_cubit.dart';
import '../widgets/apna_bottom_navigation_bar.dart';
import '../widgets/keep_alive_tab_page.dart';
import '../cubit/main_navigation_cubit.dart';
import '../cubit/main_navigation_state.dart';
import 'home_screen.dart';
import '../../../profile_setup/presentation/screens/profile_screen.dart';

/// Root shell: [PageView] body + custom bottom navigation.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  static const int _homeIndex = 2;
  static const int _bookingsIndex = 3;

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
    _sessionRefresh.addListener(_onAuthSessionChanged);
    _applyStatusBar();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncTabsWithSessionIfNeeded();
    });
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
    if (_sessionRefresh.consumeSelectHomeTab()) {
      _goToHomeTab();
    }

    sl<ApiService>().refreshToken();

    if (!mounted) return;

    context.read<FreeDoctorCubit>().loadContent();
    context.read<CustomerSupportCubit>().loadContent();

    final profileCubit = context.read<ProfileSetupCubit>();
    if (sl<AppPref>().getLoginStatus()) {
      await profileCubit.loadProfile();
    } else {
      profileCubit.resetState();
    }

    if (!mounted) return;
    setState(() => _tabSessionKey++);
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
    return BlocBuilder<MainNavigationCubit, MainNavigationState>(
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
                  key: ValueKey('free_doctor_$_tabSessionKey'),
                  child: const FreeDoctorScreen(showBackButton: false),
                ),
                KeepAliveTabPage(
                  key: ValueKey('support_$_tabSessionKey'),
                  child: const CustomerSupportScreen(showBackButton: false),
                ),
                KeepAliveTabPage(
                  key: ValueKey('home_$_tabSessionKey'),
                  child: const HomeScreen(),
                ),
                KeepAliveTabPage(
                  key: ValueKey('bookings_$_tabSessionKey'),
                  child: const BookingsDashboardScreen(showBackButton: false),
                ),
                KeepAliveTabPage(
                  key: ValueKey('profile_$_tabSessionKey'),
                  child: const ProfileScreen(showBackButton: false),
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
    );
  }
}
