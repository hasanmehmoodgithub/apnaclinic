import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/assets.dart';
import 'user_profile_avatar.dart';

/// Circular profile photo with [Assets.proProBagde2] on the top-right edge.
class ProBadgeAvatar extends StatelessWidget {
  const ProBadgeAvatar({
    super.key,
    this.imageUrl,
    required this.size,
    this.fit = BoxFit.cover,
    this.cacheKey,
  });

  final String? imageUrl;
  final double size;
  final BoxFit fit;
  final String? cacheKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          UserProfileAvatar(
            imageUrl: imageUrl,
            size: size,
            fit: fit,
            cacheKey: cacheKey,
          ),
          Positioned(
            top: -size * 0.12,
            right: -size * 0.16,
            child: SvgPicture.asset(
              Assets.proProBagde2,
              width: size * 0.78,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
