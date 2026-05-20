import 'package:apnaclinic/core/extensions/extensions_export.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'onboarding_scale.dart';

class OnboardingBackdrop extends StatelessWidget {
  const OnboardingBackdrop({super.key, required this.scale});

  final double scale;

  static const Color _bgBottom = Color(0xFFE5F1F3);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final topBgHeight = constraints.maxHeight * 0.6;

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -MediaQuery.sizeOf(context).height/5,
              left: -MediaQuery.sizeOf(context).width/1.5,
              right: -40.w,
              child: SizedBox(
                height: topBgHeight,
                child: SvgPicture.asset(
                  Assets.svgOnboardingBgTop,
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              right: -onboardingScaled(140, scale),
              bottom: -onboardingScaled(130, scale),
              child: Container(
                width: onboardingScaled(460, scale),
                height: onboardingScaled(220, scale),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _bgBottom,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
