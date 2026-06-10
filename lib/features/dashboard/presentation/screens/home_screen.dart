import 'dart:async';

import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../profile_setup/presentation/profile_setup_launch_source.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../domain/entities/our_service_entity.dart';
import '../../domain/services/promotional_banner_session.dart';
import '../cubit/dashboard_services_cubit.dart';
import '../cubit/dashboard_services_state.dart';
import '../widgets/fikrfree_health_banner.dart';
import '../widgets/our_services_widget.dart';
import '../widgets/promotional_banner_dialog.dart';
import '../widgets/search_header.dart';
import '../../../notification/presentation/cubit/notification_cubit.dart';
import '../../../notification/presentation/cubit/notification_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const String _bannerLoaderId = 'banner_loader';
  bool _isLoggedIn = false;
  bool _isPromoDialogShown = false;
  late final DashboardCubit _dashboardCubit;
  late final NotificationCubit _notificationCubit;
  late final PromotionalBannerSession _bannerSession;
  StreamSubscription<NotificationPayload>? _pushSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isLoggedIn = sl<AppPref>().getLoginStatus();
    _bannerSession = sl<PromotionalBannerSession>();
    _isPromoDialogShown = _bannerSession.dialogShown;
    _dashboardCubit = sl<DashboardCubit>();
    _notificationCubit = sl<NotificationCubit>();
    _bindPushRefresh();
  }

  void _bindPushRefresh() {
    if (!sl.isRegistered<NotificationService>()) return;
    final service = sl<NotificationService>();
    if (!service.isInitialized) return;

    _pushSubscription = service.notificationStream.listen((_) {
      if (!mounted) return;
      _notificationCubit.loadNotifications(refresh: true);
    });
  }

  @override
  void dispose() {
    _pushSubscription?.cancel();
    HeartLoaderDialogController.close(_bannerLoaderId);
    WidgetsBinding.instance.removeObserver(this);
    _dashboardCubit.close();
    _notificationCubit.close();
    super.dispose();
  }

  bool _isHomeRouteActive(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route?.isCurrent != true) return false;
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
    return location == AppRoutes.path(AppRoutes.home);
  }

  /// Forces the keyboard to close. Called whenever the home screen comes
  /// back into focus (e.g. user popped back from search screen).
  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    final routerDelegate = GoRouter.of(context).routerDelegate;
    return AnimatedBuilder(
      animation: routerDelegate,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context)!;
        _isLoggedIn = sl<AppPref>().getLoginStatus();
        final greetingName = _resolveGreetingName(l10n);
        final theme = Theme.of(context);

        // Whenever the router rebuilds us (which includes returning from
        // the search screen), defer a keyboard-dismiss to the next frame
        // so any lingering soft keyboard is closed.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _dismissKeyboard();
        });

        return BlocProvider.value(
          value: _dashboardCubit,
          child: BlocConsumer<DashboardCubit, DashboardServicesState>(
            listener: _onDashboardStateChanged,
            builder: (context, state) =>
                _buildHomeBody(context, state, greetingName, theme, l10n),
          ),
        );
      },
    );
  }

  void _onDashboardStateChanged(
      BuildContext context,
      DashboardServicesState state,
      ) {
    if (state.promotionalBannerLoadingStateStatus == StateStatus.loading) {
      if (_isHomeRouteActive(context) &&
          !HeartLoaderDialogController.isOpen(_bannerLoaderId)) {
        showHeartLoaderDialog(context, id: _bannerLoaderId);
      }
      return;
    }

    HeartLoaderDialogController.close(_bannerLoaderId);

    if (state.promotionalBannerLoadingStateStatus != StateStatus.success) {
      return;
    }

    final banner = state.promotionalBanner;
    if (banner == null ||
        !banner.showBanner ||
        _isPromoDialogShown ||
        _bannerSession.dialogShown) {
      return;
    }
    _isPromoDialogShown = true;
    _bannerSession.markDialogShown();
    showPromotionalBannerDialog(context, banner: banner);
  }

  void _openSearch(BuildContext context, {String? query}) {
    // Belt-and-braces: close the keyboard before navigating, in case the
    // SearchHeader's own dismiss didn't fire (e.g. button-only path).
    _dismissKeyboard();
    context.push(
      AppRoutes.path(AppRoutes.search),
      extra: (query == null || query.trim().isEmpty) ? null : query.trim(),
    );
  }

  Widget _buildHomeBody(
      BuildContext context,
      DashboardServicesState state,
      String greetingName,
      ThemeData theme,
      AppLocalizations l10n,
      ) {
    return Scaffold(
      backgroundColor: AppColors.clrWhite,
      // Tapping anywhere outside the text field dismisses the keyboard.
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissKeyboard,
        child: Column(
          children: [
            Container(
              color: AppColors.clr52A898,
              child: SafeArea(
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  bloc: _notificationCubit,
                  builder: (context, notificationState) {
                    final unreadCount = notificationState.notifications
                        .where((item) => !item.isRead)
                        .length;
                    final profileImageUrl = _isLoggedIn
                        ? sl<AppPref>()
                            .getUserLocalModel()
                            ?.imageUrl
                        : null;
                    // Rebuild avatar when dashboard profile sync completes.
                    final _ = state.profileSyncNonce;
                    return ApnaClinicAppBar(
                      style: ApnaAppBarStyle.light,
                      systemOverlayStyle:
                      ApnaClinicAppBar.lightBarColoredStatus,
                      onMenuTap: () => context.push(
                        AppRoutes.path(AppRoutes.dashboardMenu),
                      ),
                      onNotificationTap: () {
                        if (!_isLoggedIn) {
                          context.push(AppRoutes.path(AppRoutes.authLogin));
                          return;
                        }
                        context.push(AppRoutes.path(AppRoutes.notifications));
                      },
                      notificationCount: _isLoggedIn ? unreadCount : 0,
                      showLoginButton: !_isLoggedIn,
                      onLoginTap: () =>
                          context.push(AppRoutes.path(AppRoutes.authLogin)),
                      onProfileTap: () => context.push(
                        AppRoutes.path(AppRoutes.profileSetup),
                        extra: ProfileSetupLaunchSource.menu,
                      ),
                      profileImageUrl: profileImageUrl,
                    );
                  },
                ),
              ),
            ),
            SearchHeader(
              userName: greetingName,
              onSearchSubmitted: (query) => _openSearch(context, query: query),
              onVoiceTap: () {},
              onSearchButtonTap: () => _openSearch(context),
            ),
            Expanded(
              child: CustomScrollView(
                key: const ValueKey('dashboard_content'),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.dashboardOurServicesTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.clr111827,
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
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveGreetingName(AppLocalizations l10n) {
    if (!_isLoggedIn) return l10n.dashboardGuestName;
    final appPref = sl<AppPref>();
    final userLocal = appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    if (fullName.isEmpty) return l10n.dashboardGuestName;
    return fullName;
  }

  void _onServiceTap(BuildContext context, OurServiceEntity service) {
    final normalizedRoute =
    service.route.trim().replaceFirst(RegExp(r'^/'), '');
    if (normalizedRoute.isEmpty) return;

    context.push(AppRoutes.path(normalizedRoute));
  }
}