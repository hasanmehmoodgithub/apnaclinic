import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/app/presentation/screens/splash_screen.dart';
import '../../features/consultation/presentation/cubit/consultation_cubit.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_screen.dart';
import '../../features/dashboard/presentation/screens/menu_screen.dart';
import '../../features/notification/presentation/screens/notifcation_screen.dart';
import '../../features/dashboard/presentation/screens/main_navigation_shell.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../di/dependency_injection.dart';
import '../../features/profile_setup/presentation/screens/profile_setup_screen.dart';
import 'app_routes.dart';
import 'router_observer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.splash),
    observers: [GoRouterObserver()], // Router debug logging

    routes: [
      GoRoute(
        path: AppRoutes.path(AppRoutes.root),
        redirect: (context, state) => AppRoutes.path(AppRoutes.splash),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.splash),
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.onboarding),
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.authLogin),
        name: AppRoutes.authLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.profileSetup),
        name: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.home),
        name: AppRoutes.home,
        builder: (context, state) => const MainNavigationShell(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.dashboardMenu),
        name: AppRoutes.dashboardMenu,
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.notifications),
        name: AppRoutes.notifications,
        builder: (context, state) => const NotifcationScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultation),
        name: AppRoutes.consultation,
        builder: (context, state) => BlocProvider<ConsultationCubit>(
          create: (_) => sl<ConsultationCubit>(),
          child: const DoctorConsultationScreen(),
        ),
      ),

    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
