import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
import '../../../../generated/assets.dart';
import '../widgets/fikrfree_health_banner.dart';
import '../widgets/search_header.dart';
import '../widgets/service_card.dart';

/// Home dashboard with "Our Services" list.
class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoggedIn = false;
  Timer? _promoDialogTimer;
  Timer? _dashboardLoaderTimer;
  bool _isLoaderDialogVisible = false;
  bool _isPromoDialogShown = false;

  static const String _promoImagePath =
      'assets/img/banner.png';


  static const List<_ServiceItem> _services = [
    _ServiceItem(
      title: 'Online Consultation',
      subtitle: 'PMDC certified doctors',
      discountLabel: 'Up to 20% off',
      imageAsset: 'assets/img/services/online_consultation.png',
      route: AppRoutes.consultation,
    ),
    _ServiceItem(
      title: 'Pharmacy',
      subtitle: 'Authentic medicines at your doorstep',
      discountLabel: 'Up to 10% off',
      imageAsset: 'assets/img/services/pharmacy.png',
      route: null,
    ),
    _ServiceItem(
      title: 'Laboratory Testing',
      subtitle: 'Reliable lab tests with accurate results',
      discountLabel: 'Up to 40% off',
      imageAsset: 'assets/img/services/laboratory.png',
      route: null,
    ),
    _ServiceItem(
      title: 'Surgery Booking',
      subtitle: 'Hassle-free surgery scheduling',
      discountLabel: 'Up to 40% off',
      imageAsset: 'assets/img/services/surgery_booking.png',
      route: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isLoggedIn = sl<AppPref>().getLoginStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    _isLoaderDialogVisible = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/images/dashboard_loader.json',
          width: 250,
          height: 250,
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(

            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
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
                borderRadius: BorderRadius.circular(14),
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:  Colors.white,
      body: Column(
        children: [
          Container(
            color: Color(0xFF52A898),
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
                onLoginTap: () => context.push(AppRoutes.path(AppRoutes.authLogin)),
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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Our Services',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 14)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  sliver: SliverList.separated(
                    itemCount: _services.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final s = _services[index];
                      return ServiceCard(
                        title: s.title,
                        subtitle: s.subtitle,
                        discountLabel: s.discountLabel,
                        imageAsset: s.imageAsset,
                        onTap: () {
                          if (s.route != null) {
                            context.push(AppRoutes.path(s.route!));
                          }
                        },
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
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
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.discountLabel,
    required this.imageAsset,
    required this.route,
  });

  final String title;
  final String subtitle;
  final String discountLabel;
  final String imageAsset;
  final String? route;
}
