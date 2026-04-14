import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_system_ui.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../bookings/presentation/screens/bookings_dashboard_screen.dart';
import '../../../customer_support/presentation/screens/customer_support_screen.dart';
import '../../../free_doctor/presentation/screens/free_doctor_screen.dart';
import '../widgets/apna_bottom_navigation_bar.dart';
import 'dashboard_home_screen.dart';
import 'dashboard_profile_screen.dart';

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
  int _currentIndex = _homeIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _homeIndex);
    _applyStatusBar();
  }

  @override
  void dispose() {
    AppSystemUi.apply();
    _pageController.dispose();
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

    setState(() => _currentIndex = index);
    _applyStatusBar();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _applyStatusBar();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.overlayStyle,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const BouncingScrollPhysics(),
          children: [
            const FreeDoctorScreen(showBackButton: false),
            const CustomerSupportScreen(showBackButton: false),
            const DashboardHomeScreen(),
            const BookingsDashboardScreen(showBackButton: false),
            const DashboardProfileScreen(showBackButton: false),
          ],
        ),
        bottomNavigationBar: ApnaBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}

