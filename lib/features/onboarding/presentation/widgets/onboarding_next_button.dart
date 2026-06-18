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
    final height = onboardingScaled(65, scale).clamp(56.0, 72.0);
    final fontSize = onboardingScaled(18, scale).clamp(15.0, 18.0);
    final iconSize = onboardingScaled(24, scale).clamp(20.0, 24.0);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _mint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(onboardingScaled(120, scale)),
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
