import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../core/constants/app_system_ui.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/flavor/flavor_config.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/chucker_guard.dart';
import '../../../customer_support/presentation/cubit/customer_support_cubit.dart';
import '../../../free_doctor/presentation/cubit/free_doctor_cubit.dart';
import '../../../pharmacy/presentation/cubit/pharmacy_cubit.dart';
import '../../../profile_setup/presentation/cubit/profile_setup_cubit.dart';
import '../cubit/app_cubit.dart';

class ApnaClinicApp extends StatefulWidget {
  const ApnaClinicApp({super.key});

  @override
  State<ApnaClinicApp> createState() => _ApnaClinicAppState();
}

class _ApnaClinicAppState extends State<ApnaClinicApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Set navigator key for notification service
    // NotificationService.setNavigatorKey(_navigatorKey);
    //
    // // Listen to notification stream
    // NotificationService().notificationStream.listen((payload) {
    //   // Handle notification when app is open (foreground)
    //   _handleNotification(payload);
    // });
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AppCubit>()),
        BlocProvider(create: (context) => sl<FreeDoctorCubit>()),
        BlocProvider(create: (context) => sl<CustomerSupportCubit>()),
        BlocProvider(create: (context) => sl<ProfileSetupCubit>()),
        BlocProvider(create: (context) => sl<PharmacyCubit>()),
      ],
      child: _buildMaterialApp(),
    );
  }

  Widget _buildMaterialApp() {
    return MaterialApp.router(
      key: _navigatorKey,
      title: FlavorConfig.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        ScreenUtilX.init(
            context,
            useScaleByDefault: false);
        final appChild = child ?? const SizedBox.shrink();
        if (!ChuckerGuard.isEnabled) return appChild;
        return Stack(
          children: [
            appChild,
            Positioned(
              right: 16,
              bottom: 24,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => ChuckerFlutter.showChuckerScreen(),
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    child: const Icon(
                      Icons.bug_report_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Satoshi',
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: AppSystemUi.overlayStyle,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // TODO: Uncomment if you want to use theme (without state management)
      // theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system, // or ThemeMode.light, ThemeMode.dark
    );
  }
}
