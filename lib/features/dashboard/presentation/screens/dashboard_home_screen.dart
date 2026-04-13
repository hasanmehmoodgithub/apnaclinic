import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:io';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
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
  Timer? _promoDialogTimer;
  bool _isPromoDialogShown = false;

  static const String _promoImagePath =
      '/Users/hasan/.cursor/projects/Users-hasan-StudioProjects-apnaclinic/assets/Broadway__1_-f6b22543-8696-4c1f-8f93-b1fb978e73e4.png';
  static const String _closeIconSvgPath =
      '/Users/hasan/Downloads/fi_1617543.svg';

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
    _promoDialogTimer = Timer(const Duration(seconds: 2), _showPromoDialog);
  }

  @override
  void dispose() {
    _promoDialogTimer?.cancel();
    super.dispose();
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(_promoImagePath),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A8D84).withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.2),
                      ),
                      child: SvgPicture.file(
                        File(_closeIconSvgPath),
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAF9),
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
                onProfileTap: () {
                  // TODO: profile screen
                },
              ),
            ),
          ),
          SearchHeader(
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
