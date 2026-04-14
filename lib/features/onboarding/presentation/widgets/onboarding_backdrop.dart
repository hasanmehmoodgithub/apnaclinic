import 'package:apnaclinic/core/extensions/context_extensions.dart';
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
          top:-context.screenHeight/4,
          left: -context.screenWidth/2,
          right:0,
          child: SvgPicture.asset(
            'assets/svg/onboarding_bg_top.svg',
            fit: BoxFit.cover,
            height: context.screenHeight/1.5,

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
