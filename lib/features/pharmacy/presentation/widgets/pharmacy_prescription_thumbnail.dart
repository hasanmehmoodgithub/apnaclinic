import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Square preview of a local or remote prescription (image or PDF).
class PharmacyPrescriptionThumbnail extends StatelessWidget {
  const PharmacyPrescriptionThumbnail({
    super.key,
    this.localPath,
    this.networkUrl,
    this.size,
  });

  final String? localPath;
  final String? networkUrl;
  final double? size;

  static const _imageExts = {'.png', '.jpg', '.jpeg', '.webp'};

  @override
  Widget build(BuildContext context) {
    final dim = size ?? 88.r;
    final radius = 10.r;
    final source = (localPath ?? networkUrl ?? '').trim();

    final pdf = _isPdf(source);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.clrE3E8EE),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: dim,
          height: dim,
          child: ColoredBox(
            color: AppColors.clrF0F4F8,
            child: _buildPreview(source, dim, radius, pdf),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(
    String source,
    double dim,
    double radius,
    bool pdf,
  ) {
    if (source.isEmpty || pdf) {
      return _fallbackIcon(isPdf: pdf);
    }

    final path = localPath?.trim() ?? '';
    if (path.isNotEmpty) {
      return Image.file(
        File(path),
        width: dim,
        height: dim,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackIcon(isPdf: false),
      );
    }

    final url = networkUrl?.trim() ?? '';
    if (url.isEmpty) return _fallbackIcon(isPdf: false);

    return CachedNetworkImage(
      imageUrl: url,
      width: dim,
      height: dim,
      fit: BoxFit.cover,
      placeholder: (_, _) => AppShimmer(
        width: dim,
        height: dim,
        borderRadius: radius,
        shape: ShimmerShape.roundedRectangle,
      ),
      errorWidget: (_, _, _) => _fallbackIcon(isPdf: false),
    );
  }

  Widget _fallbackIcon({required bool isPdf}) {
    return Center(
      child: Icon(
        isPdf ? Icons.picture_as_pdf_rounded : Icons.image_outlined,
        color: AppColors.clr8A9AAE,
        size: 28.r,
      ),
    );
  }

  static bool _isPdf(String source) {
    final path = source.toLowerCase().split('?').first;
    return path.endsWith('.pdf');
  }

  static bool isImageSource(String source) {
    final path = source.trim().toLowerCase().split('?').first;
    return _imageExts.any(path.endsWith);
  }
}
