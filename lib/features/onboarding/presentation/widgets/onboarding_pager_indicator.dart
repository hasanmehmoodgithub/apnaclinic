import 'package:flutter/material.dart';

import 'onboarding_scale.dart';

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
    final dotHeight = onboardingScaled(2, scale).clamp(2.0, 3.0);
    final activeWidth = onboardingScaled(58.48, scale).clamp(40.0, 58.48);
    final inactiveWidth = onboardingScaled(16.58, scale).clamp(12.0, 20.0);
    final gap = onboardingScaled(4, scale);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: gap),
          width: active ? activeWidth : inactiveWidth,
          height: dotHeight,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0E5C97) : const Color(0xFFBCBCBC),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
