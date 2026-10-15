import 'dart:async';

import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
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
import '../../../pro/presentation/show_pro_bottom_sheet.dart';
import '../cubit/dashboard_services_cubit.dart';
import '../cubit/dashboard_services_state.dart';
import '../widgets/app_update_dialog.dart';
import '../widgets/apna_clinic_pro_home_banner.dart';
import '../widgets/home_header_section.dart';
import '../widgets/instant_doctor_home_banner.dart';
import '../widgets/our_services_widget.dart';
import '../widgets/promotional_banner_dialog.dart';
import '../instant_doctor_tab_navigation.dart';
import '../../../consultation/presentation/consultation_analytics.dart';
import '../../../lab_test/presentation/lab_test_analytics.dart';
import '../../../pharmacy/presentation/pharmacy_navigation.dart';
import '../../../surgery/presentation/surgery_analytics.dart';
import '../../../search/presentation/models/search_launch_args.dart';
import '../../../notification/presentation/cubit/notification_cubit.dart';
import '../../../notification/presentation/cubit/notification_state.dart';
import '../../../pro/domain/entities/pro_membership_entity.dart';
import '../../../pro/presentation/cubit/pro_cubit.dart';
import '../../../pro/presentation/cubit/pro_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const String _bannerLoaderId = 'banner_loader';
  bool _isPresentingBannerQueue = false;
  bool _isPresentingUpdateDialog = false;
  bool _updatePromptHandled = false;
  late final DashboardCubit _dashboardCubit;
  late final NotificationCubit _notificationCubit;
  late final ProCubit _proCubit;
  late final PromotionalBannerSession _bannerSession;
  //change
  StreamSubscription<NotificationPayload>? _pushSubscription;
  late final AuthSessionRefresh _sessionRefresh;
  late int _appliedProRevision;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bannerSession = sl<PromotionalBannerSession>();
    _dashboardCubit = sl<DashboardCubit>();
    _notificationCubit = sl<NotificationCubit>();
    _proCubit = sl<ProCubit>()..loadCatalog();
    _sessionRefresh = sl<AuthSessionRefresh>();
    _appliedProRevision = _sessionRefresh.proMembershipRevision;
    _sessionRefresh.addListener(_onAuthSessionChanged);
    if (AuthGuard.isLoggedIn()) {
      _notificationCubit.loadNotifications();
    }
    _bindPushRefresh();
    unawaited(sl<AnalyticsService>().logEvent(AnalyticsEventKeys.homeScreen));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_maybePresentHomeDialogs());
    });
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
    _sessionRefresh.removeListener(_onAuthSessionChanged);
    HeartLoaderDialogController.close(_bannerLoaderId);
    WidgetsBinding.instance.removeObserver(this);
    _dashboardCubit.close();
    _proCubit.close();
    super.dispose();
  }

  void _onAuthSessionChanged() {
    if (!mounted) return;
    if (_refreshProAfterMembershipChange()) return;
    unawaited(_maybePresentHomeDialogs());
    unawaited(_proCubit.loadCatalog(refresh: true));
  }

  Future<void> _openPro() async {
    final revision = _sessionRefresh.proMembershipRevision;
    await showApnaClinicProSheet(context, showServiceActions: true);
    if (!mounted) return;
    if (_sessionRefresh.proMembershipRevision != revision) return;
    unawaited(_proCubit.loadCatalog(refresh: true));
  }

  bool _refreshProAfterMembershipChange() {
    final revision = _sessionRefresh.proMembershipRevision;
    if (revision == _appliedProRevision) return false;
    _appliedProRevision = revision;
    final expected = _sessionRefresh.expectedProActive;
    if (expected == null) {
      unawaited(_proCubit.loadCatalog(refresh: true));
    } else {
      unawaited(_proCubit.refreshUntilMembership(isActive: expected));
    }
    return true;
  }

  bool _isHomeRouteActive(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route?.isCurrent != true) return false;
    final location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;
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
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _dashboardCubit),
        BlocProvider.value(value: _proCubit),
      ],
      child: ListenableBuilder(
        listenable: _sessionRefresh,
        builder: (context, _) {
          final isLoggedIn = AuthGuard.isLoggedIn();
          final greetingName = _resolveGreetingName(l10n, isLoggedIn);
          return BlocConsumer<DashboardCubit, DashboardServicesState>(
            listener: _onDashboardStateChanged,
            builder: (context, state) =>
                _buildHomeBody(context, state, greetingName, isLoggedIn),
          );
        },
      ),
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

  Future<void> _openSearch(BuildContext context, {String? query}) async {
    _dismissKeyboard();
    _logSearchClicked();
    await context.push(
      AppRoutes.path(AppRoutes.search),
      extra: (query == null || query.trim().isEmpty)
          ? null
          : SearchLaunchArgs(initialQuery: query.trim()),
    );
    if (!mounted) return;
    _dismissKeyboard();
  }

  Future<void> _openVoiceSearch(BuildContext context) async {
    _dismissKeyboard();
    _logSearchClicked();
    await context.push(
      AppRoutes.path(AppRoutes.search),
      extra: const SearchLaunchArgs(startVoiceSearch: true),
    );
    if (!mounted) return;
    _dismissKeyboard();
  }

  void _logSearchClicked() {
    unawaited(
      sl<AnalyticsService>().logEvent(AnalyticsEventKeys.searchClicked, {
        AnalyticsParamKeys.sourceScreen: AnalyticsHomeSourceKeys.homeScreen,
      }),
    );
  }

  Future<void> _onHomeRefresh() async {
    await _dashboardCubit.refreshHome();
    if (!mounted) return;
    if (AuthGuard.isLoggedIn()) {
      await _notificationCubit.loadNotifications(refresh: true);
    }
    if (!mounted) return;
    await _proCubit.loadCatalog(refresh: true);
  }

  Widget _buildHomeBody(
    BuildContext context,
    DashboardServicesState state,
    String greetingName,
    bool isLoggedIn,
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
                final profileImageUrl = isLoggedIn
                    ? sl<AppPref>().getUserLocalModel()?.imageUrl
                    : null;
                final profileRevision =
                    sl<AuthSessionRefresh>().profileRevision;
                final trimmedImageUrl = profileImageUrl?.trim() ?? '';
                final profileImageCacheKey = trimmedImageUrl.isEmpty
                    ? null
                    : '$trimmedImageUrl#$profileRevision';
                final _ = state.profileSyncNonce;
                return BlocSelector<ProCubit, ProState, bool>(
                  selector: (proState) =>
                      proState.membership?.isActivePro == true,
                  builder: (context, isPro) {
                    return HomeHeaderSection(
                      userName: greetingName,
                      isLoggedIn: isLoggedIn,
                      hasUnreadNotifications: unreadCount > 0,
                      profileImageUrl: profileImageUrl,
                      profileImageCacheKey: profileImageCacheKey,
                      isPro: isPro,
                      onMenuTap: () =>
                          context.push(AppRoutes.path(AppRoutes.dashboardMenu)),
                      onNotificationTap: () {
                        if (!context.requireLogin()) return;
                        unawaited(
                          sl<AnalyticsService>().logEvent(
                            AnalyticsEventKeys.notificationsScreenOpen,
                          ),
                        );
                        context.push(AppRoutes.path(AppRoutes.notifications));
                      },
                      onLoginTap: () => AuthGuard.pushLogin(context),
                      onProfileTap: () {
                        if (!context.requireLogin()) return;
                        context.push(AppRoutes.path(AppRoutes.profile));
                      },
                      onSearchTap: () => unawaited(_openSearch(context)),
                      onVoiceTap: () => unawaited(_openVoiceSearch(context)),
                    );
                  },
                );
              },
            ),

            Expanded(
              child: RefreshIndicator(
                color: AppColors.clr0FAA9A,
                onRefresh: _onHomeRefresh,
                child: CustomScrollView(
                  key: const ValueKey('dashboard_content'),
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(padding: EdgeInsets.only(top: 8.h)),
                    OurServicesWidget(
                      state: state,
                      onServiceTap: (service) =>
                          _onServiceTap(context, service),
                      onRetry: () => unawaited(_onHomeRefresh()),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: InstantDoctorHomeBanner(
                            onTap: () => openInstantDoctorTab(context),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                      sliver: SliverToBoxAdapter(
                        child:
                            BlocSelector<
                              ProCubit,
                              ProState,
                              ({
                                ProMembershipEntity? membership,
                                bool isLoading,
                              })
                            >(
                              selector: (proState) => (
                                membership: proState.membership,
                                isLoading: proState.isCatalogLoading,
                              ),
                              builder: (context, pro) {
                                final bannerUrl =
                                    state.proBannerUrl?.trim() ?? '';
                                return ApnaClinicProHomeBanner(
                                  membership: pro.membership,
                                  isLoading: pro.isLoading,
                                  imageUrl: bannerUrl.isEmpty
                                      ? ApnaClinicProHomeBanner.defaultImageUrl
                                      : bannerUrl,
                                  onTap: () => unawaited(_openPro()),
                                );
                              },
                            ),
                      ),
                    ),
                    SliverPadding(padding: EdgeInsets.only(bottom: 32.h)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveGreetingName(AppLocalizations l10n, bool isLoggedIn) {
    if (!isLoggedIn) return l10n.dashboardGuestName;
    final appPref = sl<AppPref>();
    final userLocal = appPref.getUserLocalModel();
    final firstName = userLocal?.firstName.trim() ?? '';
    final lastName = userLocal?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    if (fullName.isEmpty) return l10n.dashboardGuestName;
    return fullName;
  }

  void _onServiceTap(BuildContext context, OurServiceEntity service) {
    final normalizedRoute = service.route.trim().replaceFirst(
      RegExp(r'^/'),
      '',
    );
    if (normalizedRoute.isEmpty) return;

    Object? extra;
    if (normalizedRoute == AppRoutes.pharmacyMain) {
      extra = {PharmacyRouteExtraKeys.source: AnalyticsPharmacySourceKeys.home};
    } else if (normalizedRoute == AppRoutes.consultation) {
      extra = {
        ConsultationRouteExtraKeys.source: AnalyticsConsultancySourceKeys.home,
      };
    } else if (normalizedRoute == AppRoutes.surgery) {
      extra = {SurgeryRouteExtraKeys.source: AnalyticsSurgerySourceKeys.home};
    } else if (normalizedRoute == AppRoutes.labTest) {
      extra = {LabTestRouteExtraKeys.source: AnalyticsLabSourceKeys.home};
    }
    context.push(AppRoutes.path(normalizedRoute), extra: extra);
    final eventName = _serviceTileEventName(normalizedRoute);
    if (eventName != null) {
      unawaited(sl<AnalyticsService>().logEvent(eventName));
    }
  }

  String? _serviceTileEventName(String route) {
    if (route == AppRoutes.pharmacyMain || route == AppRoutes.pharmacy) {
      return AnalyticsEventKeys.pharmacyTileClicked;
    }
    if (route == AppRoutes.consultation) {
      return AnalyticsEventKeys.consultationTileClicked;
    }
    if (route == AppRoutes.labTest) {
      return AnalyticsEventKeys.labTileClicked;
    }
    if (route == AppRoutes.surgery) {
      return AnalyticsEventKeys.surgeryTileClicked;
    }
    return null;
  }
}
