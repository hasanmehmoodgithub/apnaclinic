import 'package:flutter/material.dart';

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
          margin: EdgeInsets.symmetric(horizontal: 4 * scale),
          width: active ? 58.48 * scale : 16.58 * scale,
          height: 2 * scale,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0E5C97) : const Color(0xFFBCBCBC),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
