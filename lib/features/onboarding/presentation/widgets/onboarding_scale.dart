import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Figma artboard for onboarding (430×932).
const double onboardingDesignWidth = 430;
const double onboardingDesignHeight = 932;

/// Uniform scale so the layout fits width and height (letterboxing handled by parent).
double onboardingScale(BoxConstraints constraints) {
  return math.min(
    constraints.maxWidth / onboardingDesignWidth,
    constraints.maxHeight / onboardingDesignHeight,
  );
}

double onboardingScaled(double designValue, double scale) => designValue * scale;
