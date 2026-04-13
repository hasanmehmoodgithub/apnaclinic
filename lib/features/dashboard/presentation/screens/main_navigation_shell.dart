import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_system_ui.dart';
import '../widgets/apna_bottom_navigation_bar.dart';
import 'dashboard_home_screen.dart';
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
            const _NavPlaceholderPage(title: 'My Bookings'),
            const _NavPlaceholderPage(title: 'Profile'),
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

/// No [AppBar] — avoids resetting global status bar after layout.
class _NavPlaceholderPage extends StatelessWidget {
  const _NavPlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: const Color(0xFFF8FAF9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: kToolbarHeight,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
