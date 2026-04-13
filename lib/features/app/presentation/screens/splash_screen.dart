import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';

/// Splash Screen - First screen shown when app launches
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final appPref = sl<AppPref>();
    final seenOnboarding = appPref.isOnboardingCompleted();
    final isLoggedIn = appPref.getLoginStatus();
    final nextRoute = !seenOnboarding
        ? AppRoutes.onboarding
        : (isLoggedIn ? AppRoutes.home : AppRoutes.authLogin);
    context.go(AppRoutes.path(nextRoute));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset('assets/img/splash.webp', fit: BoxFit.cover),
      ),
    );
  }
}
