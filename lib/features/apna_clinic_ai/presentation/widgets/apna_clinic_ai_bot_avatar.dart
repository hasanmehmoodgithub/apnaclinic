import 'package:flutter/material.dart';

import '../../../../core/widgets/apna_clinic_ai_bot_lottie.dart';

/// Circular doctor-bot used in the AI header and assistant bubbles.
class ApnaClinicAiBotAvatar extends StatelessWidget {
  const ApnaClinicAiBotAvatar({
    super.key,
    this.size = 40,
    this.animate = false,
  });

  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return ApnaClinicAiBotLottie(
      size: size,
      animate: animate,
      sparkle: size >= 48,
    );
  }
}
