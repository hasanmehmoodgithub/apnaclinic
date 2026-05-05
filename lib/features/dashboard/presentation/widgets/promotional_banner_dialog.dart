import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
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
                onTap: () {
                  final normalizedRoute = banner.route
                      .trim()
                      .replaceFirst(RegExp(r'^/'), '');
                  dialogContext.pop();
                  if (normalizedRoute.isEmpty) return;
                  context.push(AppRoutes.path(normalizedRoute));
                },
                child: CachedNetworkImage(
                  imageUrl: banner.url,
                  fit: BoxFit.cover,
                  errorWidget: (context, _, _) =>
                      Image.asset(Assets.imgBanner, fit: BoxFit.cover),
                  placeholder: (context, _) => Container(
                    color: AppColors.clrEAF6F1,
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
