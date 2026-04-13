import 'package:flutter/material.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
    required this.scale,
    required this.onTap,
  });

  final double scale;
  final VoidCallback onTap;

  static const Color _mint = Color(0xFF0FAE9D);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.97 * scale,
      height: 41.98 * scale,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _mint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(120 * scale),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24 * scale),
        ),
        label: Text(
          'Next',
          style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.w700),
        ),
        icon: Icon(Icons.arrow_forward_rounded, size: 24 * scale),
        iconAlignment: IconAlignment.end,
      ),
    );
  }
}
