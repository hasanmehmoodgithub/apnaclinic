import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingBackdrop extends StatelessWidget {
  const OnboardingBackdrop({super.key, required this.scale});

  final double scale;

  static const Color _bgBottom = Color(0xFFE5F1F3);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -150 * scale,
          left: -120 * scale,
          right: 20,
          child: SvgPicture.asset(
            'assets/svg/onboarding_bg_top.svg',
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          right: -140 * scale,
          bottom: -130 * scale,
          child: Container(
            width: 460 * scale,
            height: 220 * scale,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _bgBottom,
            ),
          ),
        ),
      ],
    );
  }
}
