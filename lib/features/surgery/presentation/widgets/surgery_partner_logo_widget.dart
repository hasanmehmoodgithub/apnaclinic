import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Partner logo for surgery cards (PNG/WebP/SVG). Surgery-local — not shared
/// with consultation UI.
class SurgeryPartnerLogoWidget extends StatelessWidget {
  const SurgeryPartnerLogoWidget({
    super.key,
    required this.logoUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
    this.compact = false,
  });

  final String logoUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final url = logoUrl.trim();
    if (url.isEmpty) {
      return _UnavailableLogoPlaceholder(
        width: width,
        height: height,
        compact: compact,
      );
    }

    if (url.startsWith('http')) {
      final lower = url.toLowerCase();
      if (lower.endsWith('.svg')) {
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (_) => _UnavailableLogoPlaceholder(
            width: width,
            height: height,
            compact: compact,
          ),
        );
      }
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => _UnavailableLogoPlaceholder(
          width: width,
          height: height,
          compact: compact,
        ),
        errorWidget: (_, _, _) => _UnavailableLogoPlaceholder(
          width: width,
          height: height,
          compact: compact,
        ),
      );
    }

    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (_) => _UnavailableLogoPlaceholder(
          width: width,
          height: height,
          compact: compact,
        ),
      );
    }

    return Image.asset(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _UnavailableLogoPlaceholder(
        width: width,
        height: height,
        compact: compact,
      ),
    );
  }
}

class _UnavailableLogoPlaceholder extends StatelessWidget {
  const _UnavailableLogoPlaceholder({
    required this.width,
    required this.height,
    required this.compact,
  });

  final double width;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.broken_image_outlined,
          size: (width * 0.65).clamp(12.0, 18.0),
          color: AppColors.clr667B99,
        ),
      );
    }

    final showLabel = height >= 40.h;
    final verticalPadding = 2.h;
    final labelHeight = showLabel ? 10.sp + 2.h : 0.0;
    final iconSize = (height - (verticalPadding * 2) - labelHeight)
        .clamp(10.0, 20.0)
        .toDouble();

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFE0E4EA)),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: iconSize,
                color: AppColors.clr667B99,
              ),
              if (showLabel) ...[
                SizedBox(height: 2.h),
                Text(
                  'No logo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.clr667B99,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
