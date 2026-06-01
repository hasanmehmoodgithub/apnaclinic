import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../profile_setup/presentation/profile_setup_launch_source.dart';
import '../../domain/use_cases/get_initial_route_use_case.dart';
import '../widgets/splash_background_image_widget.dart';

/// Splash Screen - First screen shown when app launches
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final GetInitialRouteUseCase _getInitialRouteUseCase;

  @override
  void initState() {
    super.initState();
    _getInitialRouteUseCase = GetInitialRouteUseCase(sl<AppPref>());
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final nextRoute = _getInitialRouteUseCase();
    if (nextRoute == AppRoutes.profileSetup) {
      context.go(
        AppRoutes.path(nextRoute),
        extra: ProfileSetupLaunchSource.splash,
      );
      return;
    }
    context.go(AppRoutes.path(nextRoute));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashBackgroundImageWidget());
  }
}
