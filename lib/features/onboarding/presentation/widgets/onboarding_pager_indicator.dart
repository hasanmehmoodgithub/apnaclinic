import 'package:flutter/material.dart';
import '../../../../../core/extensions/screen_util_extensions.dart';

class OnboardingPagerIndicator extends StatelessWidget {
  const OnboardingPagerIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    required this.scale,
  });

  final int count;
  final int activeIndex;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: 4.w * scale),
          width: active ? 58.48.w * scale : 16.58.w * scale,
          height: 2.h * scale,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0E5C97) : const Color(0xFFBCBCBC),
            borderRadius: BorderRadius.circular(999.r),
          ),
        );
      }),
    );
  }
}
