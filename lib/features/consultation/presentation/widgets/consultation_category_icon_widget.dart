import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';

/// Category icon from asset path or remote URL (SVG/PNG).
class ConsultationCategoryIconWidget extends StatelessWidget {
  const ConsultationCategoryIconWidget({
    super.key,
    required this.iconUrl,
    required this.width,
    required this.height,
  });

  final String iconUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final path = iconUrl.trim();
    if (path.isEmpty) {
      return _placeholder();
    }

    if (path.startsWith('http')) {
      final lower = path.toLowerCase();
      if (lower.endsWith('.svg')) {
        return SvgPicture.network(
          path,
          width: width,
          height: height,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => _placeholder(),
        );
      }
      return CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: BoxFit.contain,
        placeholder: (_, _) => _placeholder(),
        errorWidget: (_, _, _) => _placeholder(),
      );
    }

    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  Widget _placeholder() {
    return Icon(
      Icons.medical_services_outlined,
      size: width * 0.6,
      color: AppColors.clr667B99,
    );
  }
}
