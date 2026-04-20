import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../domain/entities/our_service_entity.dart';
import '../cubit/dashboard_services_cubit.dart';
import '../cubit/dashboard_services_state.dart';
import '../widgets/fikrfree_health_banner.dart';
import '../widgets/our_services_widget.dart';
import '../widgets/promotional_banner_dialog.dart';
import '../widgets/search_header.dart';
import '../../../profile_setup/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _bannerLoaderId = 'banner_loader';
  bool _isLoggedIn = false;
  bool _isPromoDialogShown = false;
  late final DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = sl<AppPref>().getLoginStatus();
    _dashboardCubit = sl<DashboardCubit>();
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = sl<AppPref>().getLoginStatus();
    final greetingName = _resolveGreetingName();
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _dashboardCubit,
      child: BlocConsumer<DashboardCubit, DashboardServicesState>(
        listener: _onDashboardStateChanged,
        builder: (context, state) =>
            _buildHomeBody(context, state, greetingName, theme),
      ),
    );
  }

  void _onDashboardStateChanged(
    BuildContext context,
    DashboardServicesState state,
  ) {
    if (state.promotionalBannerLoadingStateStatus == StateStatus.loading) {
      if (!HeartLoaderDialogController.isOpen(_bannerLoaderId)) {
        showHeartLoaderDialog(context, id: _bannerLoaderId);
      }
      return;
    }

    HeartLoaderDialogController.close(_bannerLoaderId);

    if (state.promotionalBannerLoadingStateStatus != StateStatus.success) {
      return;
    }

    final banner = state.promotionalBanner;
    if (banner == null || !banner.showBanner || _isPromoDialogShown) {
      return;
    }
    _isPromoDialogShown = true;
    showPromotionalBannerDialog(context, banner: banner);
  }

  Widget _buildHomeBody(
    BuildContext context,
    DashboardServicesState state,
    String greetingName,
    ThemeData theme,
  ) {
    return Scaffold(
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
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(showBackButton: true),
                    ),
                  );
                },
              ),
            ),
          ),
          SearchHeader(
            userName: greetingName,
            onSearchSubmitted: (_) =>
                context.push(AppRoutes.path(AppRoutes.search)),
            onVoiceTap: () {},
            onSearchButtonTap: () =>
                context.push(AppRoutes.path(AppRoutes.search)),
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
                  onServiceTap: (service) => _onServiceTap(context, service),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                  sliver: SliverToBoxAdapter(
                    child: FikrfreeHealthBanner(
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _resolveGreetingName() {
    if (!_isLoggedIn) return 'Guest';
    final appPref = sl<AppPref>();
    final userLocal = appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'Guest' : fullName;
  }

  void _onServiceTap(BuildContext context, OurServiceEntity service) {
    final normalizedRoute = service.route.trim().replaceFirst(RegExp(r'^/'), '');
    if (normalizedRoute.isEmpty) return;

    context.push(AppRoutes.path(normalizedRoute));
  }
}
