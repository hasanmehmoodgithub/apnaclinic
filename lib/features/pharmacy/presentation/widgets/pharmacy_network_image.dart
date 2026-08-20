import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Product image that skips [CachedNetworkImage] for empty / non-http URLs.
class PharmacyNetworkImage extends StatelessWidget {
  const PharmacyNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.placeholderBorderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
    this.backgroundColor = AppColors.clrWhite,
    this.errorBackgroundColor = AppColors.clrF0F4F8,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? placeholderBorderRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Color backgroundColor;
  final Color errorBackgroundColor;

  static bool isHttpUrl(String value) {
    final url = value.trim().toLowerCase();
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final source = imageUrl.trim();
    if (!isHttpUrl(source)) {
      return SizedBox(width: width, height: height, child: _fallback());
    }

    final radius = placeholderBorderRadius ?? 12.r;
    return ColoredBox(
      color: backgroundColor,
      child: CachedNetworkImage(
        imageUrl: source,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        placeholder: (_, _) => AppShimmer(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          borderRadius: radius,
          shape: ShimmerShape.roundedRectangle,
        ),
        errorWidget: (_, _, _) => _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return ColoredBox(
      color: errorBackgroundColor,
      child: const Center(
        child: Icon(
          Icons.medication_rounded,
          color: AppColors.clr8A9AAE,
        ),
      ),
    );
  }
}
