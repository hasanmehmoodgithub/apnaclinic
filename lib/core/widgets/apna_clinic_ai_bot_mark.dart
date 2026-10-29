import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../extensions/screen_util_extensions.dart';
import 'apna_clinic_ai_bot_lottie.dart';

/// Illustrated doctor-bot on the AI chat before the first user message.
/// Bobs and tilts above a soft shadow.
class ApnaClinicAiBotMark extends StatefulWidget {
  const ApnaClinicAiBotMark({
    super.key,
    this.size = 104,
    this.enabled = true,
  });

  /// Diameter before screen-util scaling.
  final double size;
  final bool enabled;

  @override
  State<ApnaClinicAiBotMark> createState() => _ApnaClinicAiBotMarkState();
}

class _ApnaClinicAiBotMarkState extends State<ApnaClinicAiBotMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _sync();
  }

  @override
  void didUpdateWidget(covariant ApnaClinicAiBotMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) _sync();
  }

  void _sync() {
    if (widget.enabled) {
      if (!_float.isAnimating) _float.repeat(reverse: true);
    } else if (_float.isAnimating) {
      _float.stop();
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size.r;
    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) {
        final lift = Curves.easeInOut.transform(_float.value);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, -7.h * lift),
              child: Transform.rotate(
                angle: (lift - 0.5) * 0.08,
                child: child,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -2.h),
              child: Transform.scale(
                scale: 1 - (0.22 * lift),
                child: Container(
                  width: size * 0.42,
                  height: 7.r,
                  decoration: BoxDecoration(
                    color: AppColors.clr00897B.withValues(
                      alpha: 0.18 - (0.08 * lift),
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: ApnaClinicAiBotLottie(
        size: widget.size,
        animate: widget.enabled,
      ),
    );
  }
}
