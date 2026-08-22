import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/promotional_banner_entity.dart';
import '../constants/dashboard_ui_config.dart';
import '../constants/main_navigation_tabs.dart';
import '../instant_doctor_tab_navigation.dart';
import 'promotional_banner_shimmer_widget.dart';

Future<void> showPromotionalBannerDialog(
  BuildContext context, {
  required PromotionalBannerEntity banner,
}) async {
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
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => dialogContext.pop(),
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
              borderRadius: BorderRadius.circular(
                DashboardUiConfig.promotionalBannerBorderRadius.r,
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _onBannerTap(dialogContext, context, banner),
                child: _BannerImage(url: banner.url),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _onBannerTap(
  BuildContext dialogContext,
  BuildContext hostContext,
  PromotionalBannerEntity banner,
) {
  final contentUrl = banner.url.trim();
  unawaited(
    sl<AnalyticsService>().logEvent(
      AnalyticsEventKeys.bannerClicked,
      {
        if (contentUrl.isNotEmpty)
          AnalyticsParamKeys.contentUrl: contentUrl.length <= 100
              ? contentUrl
              : contentUrl.substring(0, 100),
      },
    ),
  );

  dialogContext.pop();
  if (!hostContext.mounted) return;

  if (banner.routeType == 'bottomsheet' && banner.tabIndex != null) {
    openBottomNavTab(
      hostContext,
      banner.tabIndex!,
      sourceScreen: banner.tabIndex == MainNavigationTabs.instantDoctor
          ? AnalyticsInstantDoctorSourceKeys.popup
          : AnalyticsInstantDoctorSourceKeys.banner,
    );
    return;
  }

  final target = banner.route.trim();
  if (target.isEmpty) return;

  final lower = target.toLowerCase();
  if (banner.routeType == 'url' ||
      lower.startsWith('http://') ||
      lower.startsWith('https://')) {
    AppUrlLauncher.open(url: target, lunchMode: LaunchMode.externalApplication);
    return;
  }

  final normalizedRoute = target.replaceFirst(RegExp(r'^/'), '');
  if (normalizedRoute.isEmpty) return;
  if (normalizedRoute == AppRoutes.instantDoctor) {
    openInstantDoctorTab(
      hostContext,
      sourceScreen: AnalyticsInstantDoctorSourceKeys.popup,
    );
    return;
  }
  hostContext.push(AppRoutes.path(normalizedRoute));
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final source = url.trim();
    if (source.isEmpty) return const _BannerFallbackAsset();

    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _BannerFallbackAsset(),
      );
    }

    if (!source.startsWith('http')) return const _BannerFallbackAsset();

    return CachedNetworkImage(
      imageUrl: source,
      width: double.infinity,
      fit: BoxFit.cover,
      fadeInDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      placeholder: (_, _) => const PromotionalBannerShimmer(),

    );
  }
}

class _BannerFallbackAsset extends StatelessWidget {
  const _BannerFallbackAsset();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        DashboardUiConfig.promotionalBannerBorderRadius.r,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        Assets.imgBanner,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
