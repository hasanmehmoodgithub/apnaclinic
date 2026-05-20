import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_system_ui.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../bookings/presentation/screens/bookings_dashboard_screen.dart';
import '../../../customer_support/presentation/screens/customer_support_screen.dart';
import '../../../free_doctor/presentation/screens/free_doctor_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _homeIndex);
    _navigationCubit = MainNavigationCubit(initialIndex: _homeIndex);
    _applyStatusBar();
  }

  @override
  void dispose() {
    AppSystemUi.apply();
    _pageController.dispose();
    _navigationCubit.close();
    super.dispose();
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
              physics: const BouncingScrollPhysics(),
              children: const [
                KeepAliveTabPage(
                  child: FreeDoctorScreen(showBackButton: false),
                ),
                KeepAliveTabPage(
                  child: CustomerSupportScreen(showBackButton: false),
                ),
                KeepAliveTabPage(child: HomeScreen()),
                KeepAliveTabPage(
                  child: BookingsDashboardScreen(showBackButton: false),
                ),
                KeepAliveTabPage(
                  child: ProfileScreen(showBackButton: false),
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

