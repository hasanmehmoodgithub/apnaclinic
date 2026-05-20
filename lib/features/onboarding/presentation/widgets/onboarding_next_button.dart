import 'package:flutter/material.dart';

import 'onboarding_scale.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
    required this.scale,
    required this.label,
    required this.onTap,
  });

  final double scale;
  final String label;
  final VoidCallback onTap;

  static const Color _mint = Color(0xFF0FAE9D);

  @override
  Widget build(BuildContext context) {
    final width = onboardingScaled(141, scale).clamp(120.0, 160.0);
    final height = onboardingScaled(42, scale).clamp(40.0, 48.0);
    final fontSize = onboardingScaled(18, scale).clamp(15.0, 18.0);
    final iconSize = onboardingScaled(24, scale).clamp(20.0, 24.0);

    return SizedBox(
      width: width,
      height: height,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _mint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(onboardingScaled(120, scale)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: onboardingScaled(20, scale),
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        icon: Icon(Icons.arrow_forward_rounded, size: iconSize),
        iconAlignment: IconAlignment.end,
      ),
    );
  }
}
