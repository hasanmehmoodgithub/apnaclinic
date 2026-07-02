import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';

/// Home service icon — remote URL or styled placeholder when unavailable.
class ServiceCardImage extends StatelessWidget {
  const ServiceCardImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });

  final String imageUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = width ?? DashboardUiConfig.serviceIconWidth.w;
    final resolvedHeight = height ?? DashboardUiConfig.serviceIconHeight.h;
    final source = imageUrl.trim();

    if (source.isEmpty || !source.startsWith('http')) {
      return _placeholder(resolvedWidth, resolvedHeight);
    }

    if (source.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        source,
        width: resolvedWidth,
        height: resolvedHeight,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => _placeholder(resolvedWidth, resolvedHeight),
      );
    }

    return CachedNetworkImage(
      imageUrl: source,
      width: resolvedWidth,
      height: resolvedHeight,
      fit: BoxFit.contain,
      placeholder: (_, _) => _placeholder(resolvedWidth, resolvedHeight),
      errorWidget: (_, _, _) => _placeholder(resolvedWidth, resolvedHeight),
    );
  }

  Widget _placeholder(double width, double height) {
    final iconSize = (width < height ? width : height) * 0.38;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.clrF4F6F8,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      child: Center(
        child: Icon(
          Icons.medical_services_outlined,
          size: iconSize,
          color: AppColors.clr6B7280.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
