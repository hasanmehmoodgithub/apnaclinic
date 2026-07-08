import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';

import 'onboarding_scale.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.scale,
    required this.skipLabel,
    required this.onSkip,
  });

  final double scale;
  final String skipLabel;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final skipFontSize = onboardingScaled(20, scale).clamp(16.0, 20.0);
    final logoWidth = onboardingScaled(222.58, scale).clamp(160.0, 240.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        onboardingScaled(16, scale),
        onboardingScaled(8, scale),
        onboardingScaled(12, scale),
        onboardingScaled(4, scale),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: onboardingScaled(8, scale),
                ),
                minimumSize: Size(
                  onboardingScaled(37, scale),
                  onboardingScaled(36, scale),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                skipLabel,
                style: TextStyle(
                  fontSize: skipFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: onboardingScaled(12, scale)),
          Image.asset(
            Assets.imgBrandAlfahealth,
            width: logoWidth,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
