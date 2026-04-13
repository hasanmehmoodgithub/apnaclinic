import 'package:flutter/material.dart';
import '../../../../core/constants/app_system_ui.dart';
import '../../../../core/flavor/flavor_config.dart';
import '../../../../core/router/app_router.dart';
// TODO: Uncomment when notification service is enabled
// import '../../../../core/services/notification_service.dart';

// TODO: Uncomment if you want to use BlocProvider for state management
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/di/dependency_injection.dart';
// import '../cubit/app_cubit.dart';
// import '../cubit/app_state.dart';

// TODO: Uncomment if you want to use localization
// import 'package:flutter_localizations/flutter_localizations.dart';
// import '../../../../core/l10n/app_localizations.dart';
// import '../../../../core/l10n/app_localization_service.dart';

// TODO: Uncomment if you want to use theme
// import '../../../../core/theme/app_theme.dart';

// TODO: Uncomment when auth feature is created
// import '../../../../features/auth/presentation/cubit/auth_cubit.dart';

/// Main application widget
class FlutterSampleApp extends StatefulWidget {
  const FlutterSampleApp({super.key});

  @override
  State<FlutterSampleApp> createState() => _FlutterSampleAppState();
}

class _FlutterSampleAppState extends State<FlutterSampleApp> {
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

  // TODO: Uncomment when notification service is enabled
  // void _handleNotification(NotificationPayload payload) {
  //   // Navigate to route if specified
  //   if (payload.route != null && payload.route!.isNotEmpty) {
  //     NotificationService().navigateToRoute(payload.route, data: payload.data);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: Uncomment if you want to use BlocProvider for state management
    // return MultiBlocProvider(
    //   providers: [
    //     // AppCubit: Global state (theme, language, app-wide settings)
    //     BlocProvider(create: (context) => sl<AppCubit>()),
    //     // TODO: Uncomment when auth feature is created
    //     // AuthCubit: Shared across all auth screens
    //     // BlocProvider.value(value: sl<AuthCubit>()),
    //   ],
    //   child: _buildMaterialApp(),
    // );

    return _buildMaterialApp();
  }

  Widget _buildMaterialApp() {
    // TODO: Uncomment if you want to use theme/localization with state management
    // return BlocBuilder<AppCubit, AppState>(
    //   buildWhen: (previous, current) =>
    //       previous.themeMode != current.themeMode ||
    //       previous.locale != current.locale,
    //   builder: (context, state) {
    //     return MaterialApp.router(
    //       key: ValueKey('${state.themeMode}_${state.locale.languageCode}'),
    //       title: FlavorConfig.appName,
    //       debugShowCheckedModeBanner: FlavorConfig.enableDebugFeatures,
    //       theme: AppTheme.lightTheme,
    //       darkTheme: AppTheme.darkTheme,
    //       themeMode: state.themeMode,
    //       routerConfig: AppRouter.router,
    //       locale: state.locale,
    //       localizationsDelegates: [
    //         AppLocalizations.delegate,
    //         GlobalMaterialLocalizations.delegate,
    //         GlobalWidgetsLocalizations.delegate,
    //         GlobalCupertinoLocalizations.delegate,
    //       ],
    //       supportedLocales: AppLocalizationService.supportedLocales,
    //     );
    //   },
    // );

    return MaterialApp.router(
      key: _navigatorKey,
      title: FlavorConfig.appName,
      debugShowCheckedModeBanner: FlavorConfig.enableDebugFeatures,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: AppSystemUi.overlayStyle,
        ),
      ),

      // TODO: Uncomment if you want to use theme (without state management)
      // theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system, // or ThemeMode.light, ThemeMode.dark

      // TODO: Uncomment if you want to use localization (without state management)
      // locale: const Locale('en'), // or get from AppLocalizationService.getSavedLocale()
      // localizationsDelegates: [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: AppLocalizationService.supportedLocales,
    );
  }
}
