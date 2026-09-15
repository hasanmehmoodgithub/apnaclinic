import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/assets.dart';
import 'user_profile_avatar.dart';

/// Circular profile avatar. When [isPro] is true, shows laurel leaves
/// (`leftLeave` / `right`) and the Pro badge crown at the bottom.
class ProUserAvatar extends StatelessWidget {
  const ProUserAvatar({
    super.key,
    this.imageUrl,
    required this.size,
    this.isPro = false,
    this.fit = BoxFit.cover,
    this.cacheKey,
  });

  final String? imageUrl;
  final double size;
  final bool isPro;
  final BoxFit fit;
  final String? cacheKey;

  /// Extra width for laurels + height for bottom badge when Pro.
  double get outerWidth => isPro ? size * 1.55 : size;
  double get outerHeight => isPro ? size * 1.28 : size;

  @override
  Widget build(BuildContext context) {
    if (!isPro) {
      return UserProfileAvatar(
        imageUrl: imageUrl,
        size: size,
        fit: fit,
        cacheKey: cacheKey,
      );
    }

    final leafHeight = size * 0.72;
    final badgeHeight = size * 0.28;

    return SizedBox(
      width: outerWidth,
      height: outerHeight,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Laurels sit behind / beside the circle.
          Positioned(
            left: 0,
            bottom: badgeHeight * 0.55,
            child: Image.asset(
              Assets.proLeftLeave,
              height: leafHeight,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: 0,
            bottom: badgeHeight * 0.55,
            child: Image.asset(
              Assets.proRight,
              height: leafHeight,
              fit: BoxFit.contain,
            ),
          ),
          // Avatar circle (slightly above vertical center to leave room for badge).
          Positioned(
            top: 0,
            child: UserProfileAvatar(
              imageUrl: imageUrl,
              size: size,
              fit: fit,
              cacheKey: cacheKey,
            ),
          ),
          // Pro badge overlaps bottom of the circle.
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(
              Assets.proBadgeCrown,
              height: badgeHeight,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
