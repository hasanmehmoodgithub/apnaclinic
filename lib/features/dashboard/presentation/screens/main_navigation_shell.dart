import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_system_ui.dart';
import '../widgets/apna_bottom_navigation_bar.dart';
import 'dashboard_home_screen.dart';
import 'dashboard_my_bookings_screen.dart';
import 'dashboard_profile_screen.dart';
import 'customer_support_screen.dart';
import 'free_doctor_screen.dart';

/// Root shell: [PageView] body + custom bottom navigation.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  static const int _homeIndex = 2;

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
            FreeDoctorScreen(onBack: () => _onNavTap(_homeIndex)),
            CustomerSupportScreen(onBack: () => _onNavTap(_homeIndex)),
            const DashboardHomeScreen(),
            const DashboardMyBookingsScreen(),
            const DashboardProfileScreen(),
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

