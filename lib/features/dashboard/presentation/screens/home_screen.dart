import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/our_service_entity.dart';
import '../cubit/dashboard_services_cubit.dart';
import '../cubit/dashboard_services_state.dart';
import '../widgets/fikrfree_health_banner.dart';
import '../widgets/our_services_widget.dart';
import '../widgets/search_header.dart';

/// Home dashboard with "Our Services" list.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Only the first time the home tab is shown in this app session — avoids
  /// repeating when [HomeScreen] is recreated (e.g. tab switches).
  static bool _dashboardLoaderShownThisSession = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoggedIn = false;
  Timer? _promoDialogTimer;
  Timer? _dashboardLoaderTimer;
  bool _isLoaderDialogVisible = false;
  bool _isPromoDialogShown = false;

  static const String _promoImagePath =
      'assets/img/banner.png';

  @override
  void initState() {
    super.initState();
    _isLoggedIn = sl<AppPref>().getLoginStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dashboardLoaderShownThisSession || !mounted) return;
      _showDashboardLoaderDialog();
    });
    _promoDialogTimer = Timer(const Duration(seconds: 3), _showPromoDialog);
  }

  @override
  void dispose() {
    _promoDialogTimer?.cancel();
    _dashboardLoaderTimer?.cancel();
    super.dispose();
  }

  void _showDashboardLoaderDialog() {
    if (!mounted || _isLoaderDialogVisible) return;
    _dashboardLoaderShownThisSession = true;
    _isLoaderDialogVisible = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/images/dashboard_loader.json',
          width: 250.w,
          height: 250.h,
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );

    _dashboardLoaderTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _isLoaderDialogVisible = false;
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  Future<void> _showPromoDialog() async {
    if (!mounted || _isPromoDialogShown) return;
    _isPromoDialogShown = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: SvgPicture.asset(
                      Assets.iconsClose,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  _promoImagePath,
                  fit: BoxFit.cover,
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  String _resolveGreetingName() {
    if (!_isLoggedIn) return 'Guest';
    final appPref = sl<AppPref>();
    final firstName = (appPref.getString('profile_first_name') ?? '').trim();
    final lastName = (appPref.getString('profile_last_name') ?? '').trim();
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'Guest' : fullName;
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = sl<AppPref>().getLoginStatus();
    final greetingName = _resolveGreetingName();
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => sl<DashboardServicesCubit>(),
      child: BlocBuilder<DashboardServicesCubit, DashboardServicesState>(
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Container(
                  color: const Color(0xFF52A898),
                  child: SafeArea(
                    child: ApnaClinicAppBar(
                      style: ApnaAppBarStyle.light,
                      systemOverlayStyle: ApnaClinicAppBar.lightBarColoredStatus,
                      onMenuTap: () =>
                          context.push(AppRoutes.path(AppRoutes.dashboardMenu)),
                      onNotificationTap: () {
                        context.push(AppRoutes.path(AppRoutes.notifications));
                      },
                      showLoginButton: !_isLoggedIn,
                      onLoginTap: () =>
                          context.push(AppRoutes.path(AppRoutes.authLogin)),
                      onProfileTap: () {
                        // TODO: profile screen
                      },
                    ),
                  ),
                ),
                SearchHeader(
                  userName: greetingName,
                  onSearchSubmitted: (_) {
                    // TODO: global search
                  },
                  onVoiceTap: () {
                    // TODO: voice search
                  },
                  onSearchButtonTap: () {
                    // TODO: submit search
                  },
                ),
                Expanded(
                  child: CustomScrollView(
                    key: const ValueKey('dashboard_content'),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Our Services',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(padding: EdgeInsets.only(top: 14.h)),
                      OurServicesWidget(
                        state: state,
                        onServiceTap: (service) =>
                            _onServiceTap(context, service),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                        sliver: SliverToBoxAdapter(
                          child: FikrfreeHealthBanner(
                            onTap: () {
                              // TODO: FikrFree / insurance flow
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onServiceTap(BuildContext context, OurServiceEntity service) {
    final normalizedRoute = service.route.trim().replaceFirst(RegExp(r'^/'), '');
    if (normalizedRoute.isEmpty) return;

    context.push(AppRoutes.path(normalizedRoute));
  }
}
