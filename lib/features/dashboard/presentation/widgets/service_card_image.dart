import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';
import 'service_icon_fallbacks.dart';

/// Home service icon via [CachedNetworkImage] for remote URLs.
class ServiceCardImage extends StatelessWidget {
  const ServiceCardImage({
    super.key,
    required this.imageUrl,
    this.fallbackRoute,
    this.width,
    this.height,
  });

  final String imageUrl;
  final String? fallbackRoute;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = width ?? DashboardUiConfig.serviceIconWidth.w;
    final resolvedHeight = height ?? DashboardUiConfig.serviceIconHeight.h;
    final fallbackAsset = serviceIconFallbackAsset(fallbackRoute);
    final source = imageUrl.trim();

    return CachedNetworkImage(
      imageUrl: source,
      width: resolvedWidth,
      height: resolvedHeight,
      fit: BoxFit.contain,
      placeholder: (_, _) => _placeholder(resolvedWidth, resolvedHeight),
      errorWidget: (_, _, _) => _fallbackOrPlaceholder(
        resolvedWidth,
        resolvedHeight,
        fallbackAsset,
      ),
    );
  }

  Widget _fallbackOrPlaceholder(
    double width,
    double height,
    String? fallbackAsset,
  ) {
    if (fallbackAsset != null && fallbackAsset.isNotEmpty) {
      return Image.asset(
        fallbackAsset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _placeholder(width, height),
      );
    }
    return _placeholder(width, height);
  }

  Widget _placeholder(double width, double height) {
    final iconSize = (width < height ? width : height) * 0.45;
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Icon(
          Icons.medical_services_outlined,
          size: iconSize,
          color: AppColors.clr6B7280.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
