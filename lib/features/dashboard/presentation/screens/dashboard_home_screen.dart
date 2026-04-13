import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/apna_clinic_app_bar.dart';
import '../widgets/fikrfree_health_banner.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/service_card.dart';

/// Home dashboard with "Our Services" list.
class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<_ServiceItem> _services = [
    _ServiceItem(
      title: 'Online Consultation',
      subtitle: 'PMDC certified doctors',
      discountLabel: 'Up to 20% off',
      imageAsset: 'assets/img/services/online_consultation.png',
    ),
    _ServiceItem(
      title: 'Pharmacy',
      subtitle: 'Authentic medicines at your doorstep',
      discountLabel: 'Up to 10% off',
      imageAsset: 'assets/img/services/pharmacy.png',
    ),
    _ServiceItem(
      title: 'Laboratory Testing',
      subtitle: 'Reliable lab tests with accurate results',
      discountLabel: 'Up to 40% off',
      imageAsset: 'assets/img/services/laboratory.png',
    ),
    _ServiceItem(
      title: 'Surgery Booking',
      subtitle: 'Hassle-free surgery scheduling',
      discountLabel: 'Up to 40% off',
      imageAsset: 'assets/img/services/surgery_booking.png',
    ),
  ];

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
            child: Column(
              children: [
                SafeArea(
                  child: ApnaClinicAppBar(
                    style: ApnaAppBarStyle.light,
                    systemOverlayStyle: ApnaClinicAppBar.lightBarColoredStatus,
                    onMenuTap: () =>
                        context.push(AppRoutes.path(AppRoutes.dashboardMenu)),
                    onNotificationTap: () {
                      // TODO: notifications screen
                    },
                    onProfileTap: () {
                      // TODO: profile screen
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeroHeader(
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
                ),
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
                        const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final s = _services[index];
                      return ServiceCard(
                        title: s.title,
                        subtitle: s.subtitle,
                        discountLabel: s.discountLabel,
                        imageAsset: s.imageAsset,
                        onTap: () {
                          // TODO: Navigate to service detail when routes exist
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
  });

  final String title;
  final String subtitle;
  final String discountLabel;
  final String imageAsset;
}
