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
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../domain/entities/our_service_entity.dart';
import '../../domain/services/promotional_banner_session.dart';
import '../cubit/dashboard_services_cubit.dart';
import '../cubit/dashboard_services_state.dart';
import '../widgets/app_update_dialog.dart';
import '../widgets/fikrfree_health_banner.dart';
import '../widgets/home_header_section.dart';
import '../widgets/instant_doctor_home_banner.dart';
import '../widgets/our_services_widget.dart';
import '../widgets/promotional_banner_dialog.dart';
import '../constants/main_navigation_tabs.dart';
import '../cubit/main_navigation_cubit.dart';
import '../../../search/presentation/models/search_launch_args.dart';
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
  bool _isPresentingBannerQueue = false;
  bool _isPresentingUpdateDialog = false;
  bool _updatePromptHandled = false;
  late final DashboardCubit _dashboardCubit;
  late final NotificationCubit _notificationCubit;
  late final PromotionalBannerSession _bannerSession;
  StreamSubscription<NotificationPayload>? _pushSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isLoggedIn = AuthGuard.isLoggedIn();
    _bannerSession = sl<PromotionalBannerSession>();
    _dashboardCubit = sl<DashboardCubit>();
    _notificationCubit = sl<NotificationCubit>();
    if (AuthGuard.isLoggedIn()) {
      _notificationCubit.loadNotifications();
    }
    _bindPushRefresh();
  }

  void _bindPushRefresh() {
    if (!sl.isRegistered<NotificationService>()) return;
    final service = sl<NotificationService>();
    if (!service.isInitialized) return;

    _pushSubscription = service.notificationStream.listen((_) {
      if (!mounted || !AuthGuard.isLoggedIn()) return;
      _notificationCubit.loadNotifications(refresh: true);
    });
  }

  @override
  void dispose() {
    _pushSubscription?.cancel();
    HeartLoaderDialogController.close(_bannerLoaderId);
    WidgetsBinding.instance.removeObserver(this);
    _dashboardCubit.close();
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
        _isLoggedIn = AuthGuard.isLoggedIn();
        final greetingName = _resolveGreetingName(l10n);

        // Whenever the router rebuilds us (which includes returning from
        // the search screen), defer a keyboard-dismiss to the next frame
        // so any lingering soft keyboard is closed.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _dismissKeyboard();
          unawaited(_maybePresentHomeDialogs());
        });

        return BlocProvider.value(
          value: _dashboardCubit,
          child: BlocConsumer<DashboardCubit, DashboardServicesState>(
            listener: _onDashboardStateChanged,
            builder: (context, state) =>
                _buildHomeBody(context, state, greetingName),
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
    } else {
      HeartLoaderDialogController.close(_bannerLoaderId);
    }

    unawaited(_maybePresentHomeDialogs());
  }

  Future<void> _maybePresentHomeDialogs() async {
    if (!mounted || !_isHomeRouteActive(context)) return;
    if (_isPresentingUpdateDialog || _isPresentingBannerQueue) return;

    final state = _dashboardCubit.state;
    if (state.appVersionLoadingStateStatus == StateStatus.loading) return;

    final prompt = state.appUpdatePrompt;
    if (prompt != null && !_updatePromptHandled) {
      _isPresentingUpdateDialog = true;
      try {
        await showAppUpdateDialog(context, prompt: prompt);
      } finally {
        if (mounted) _isPresentingUpdateDialog = false;
      }
      if (!mounted) return;
      // Force update stays until the store update; optional can continue.
      if (prompt.forceUpdate) return;
      _updatePromptHandled = true;
    } else if (prompt == null) {
      _updatePromptHandled = true;
    }

    if (state.appUpdatePrompt?.forceUpdate == true && !_updatePromptHandled) {
      return;
    }

    _maybeResumeBannerQueue();
  }

  void _maybeResumeBannerQueue() {
    if (_isPresentingBannerQueue ||
        _isPresentingUpdateDialog ||
        !_bannerSession.hasPendingBanners ||
        _dashboardCubit.state.promotionalBannerLoadingStateStatus !=
            StateStatus.success ||
        !_isHomeRouteActive(context)) {
      return;
    }

    _isPresentingBannerQueue = true;
    unawaited(_presentBannerQueue());
  }

  Future<void> _presentBannerQueue() async {
    try {
      while (mounted && _bannerSession.hasPendingBanners) {
        if (!_isHomeRouteActive(context)) break;
        final banner = _bannerSession.nextBanner;
        if (banner == null) break;
        await showPromotionalBannerDialog(context, banner: banner);
        if (!mounted) return;
        _bannerSession.advanceQueue();
      }
    } finally {
      if (mounted) {
        _isPresentingBannerQueue = false;
      }
    }
  }

  void _openSearch(BuildContext context, {String? query}) {
    // Belt-and-braces: close the keyboard before navigating, in case the
    // SearchHeader's own dismiss didn't fire (e.g. button-only path).
    _dismissKeyboard();
    context.push(
      AppRoutes.path(AppRoutes.search),
      extra: (query == null || query.trim().isEmpty)
          ? null
          : SearchLaunchArgs(initialQuery: query.trim()),
    );
  }

  void _openVoiceSearch(BuildContext context) {
    _dismissKeyboard();
    context.push(
      AppRoutes.path(AppRoutes.search),
      extra: const SearchLaunchArgs(startVoiceSearch: true),
    );
  }

  Widget _buildHomeBody(
      BuildContext context,
      DashboardServicesState state,
      String greetingName,
      ) {
    return Scaffold(
      backgroundColor: AppColors.clrf4f4f4,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissKeyboard,
        child: Column(
          children: [
            BlocBuilder<NotificationCubit, NotificationState>(
              bloc: _notificationCubit,
              builder: (context, notificationState) {
                final unreadCount = notificationState.notifications
                    .where((item) => !item.isRead)
                    .length;
                final profileImageUrl = _isLoggedIn
                    ? sl<AppPref>().getUserLocalModel()?.imageUrl
                    : null;
                final profileRevision =
                    sl<AuthSessionRefresh>().profileRevision;
                final trimmedImageUrl = profileImageUrl?.trim() ?? '';
                final profileImageCacheKey = trimmedImageUrl.isEmpty
                    ? null
                    : '$trimmedImageUrl#$profileRevision';
                final _ = state.profileSyncNonce;
                return HomeHeaderSection(
                  userName: greetingName,
                  isLoggedIn: _isLoggedIn,
                  hasUnreadNotifications: unreadCount > 0,
                  profileImageUrl: profileImageUrl,
                  profileImageCacheKey: profileImageCacheKey,
                  onMenuTap: () => context.push(
                    AppRoutes.path(AppRoutes.dashboardMenu),
                  ),
                  onNotificationTap: () {
                    if (!context.requireLogin()) return;
                    context.push(AppRoutes.path(AppRoutes.notifications));
                  },
                  onLoginTap: () =>
                      context.push(AppRoutes.path(AppRoutes.authLogin)),
                  onProfileTap: () {
                    if (!context.requireLogin()) return;
                    context.push(AppRoutes.path(AppRoutes.profile));
                  },
                  onSearchTap: () => _openSearch(context),
                  onVoiceTap: () => _openVoiceSearch(context),
                );
              },
            ),
            Expanded(
              child: CustomScrollView(
                key: const ValueKey('dashboard_content'),
                slivers: [
                  SliverPadding(padding: EdgeInsets.only(top: 8.h)),
                  OurServicesWidget(
                    state: state,
                    onServiceTap: (service) =>
                        _onServiceTap(context, service),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: InstantDoctorHomeBanner(
                          onTap: () => _openInstantDoctorTab(context),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
                    sliver: SliverToBoxAdapter(
                      child: const FikrfreeHealthBanner(),
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

  void _openInstantDoctorTab(BuildContext context) {
    final sessionRefresh = sl<AuthSessionRefresh>();
    if (!AuthGuard.isLoggedIn()) {
      sessionRefresh.requestTabIndex(MainNavigationTabs.instantDoctor);
      context.requireLogin();
      return;
    }
    context.read<MainNavigationCubit>().setIndex(
      MainNavigationTabs.instantDoctor,
    );
  }
}