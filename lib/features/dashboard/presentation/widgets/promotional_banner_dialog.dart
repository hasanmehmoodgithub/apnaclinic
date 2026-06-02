import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/promotional_banner_entity.dart';

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
              borderRadius: BorderRadius.circular(14.r),
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
  final target = banner.route.trim();
  dialogContext.pop();
  if (target.isEmpty) return;

  final lower = target.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    AppUrlLauncher.open(
      url: target,
      lunchMode: LaunchMode.externalApplication,
    );
    return;
  }

  final normalizedRoute = target.replaceFirst(RegExp(r'^/'), '');
  if (normalizedRoute.isEmpty) return;
  hostContext.push(AppRoutes.path(normalizedRoute));
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            Image.asset(Assets.imgBanner, fit: BoxFit.cover),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, _, _) =>
          Image.asset(Assets.imgBanner, fit: BoxFit.cover),
      placeholder: (context, _) => Container(
        color: AppColors.clrEAF6F1,
      ),
    );
  }
}
