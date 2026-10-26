import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/apna_clinic_ai_ui_config.dart';

/// Animated teal sweep border used on the home composer and thinking bubble.
class ApnaClinicAiMovingStroke extends StatefulWidget {
  const ApnaClinicAiMovingStroke({
    super.key,
    required this.borderRadius,
    required this.child,
    this.strokeWidth = 2.2,
    this.showShadow = true,
    this.includeWhite = true,
  });

  final double borderRadius;
  final double strokeWidth;
  final bool showShadow;
  /// When false, uses teal-only sweep (no white flash).
  final bool includeWhite;
  final Widget child;

  @override
  State<ApnaClinicAiMovingStroke> createState() =>
      _ApnaClinicAiMovingStrokeState();
}

class _ApnaClinicAiMovingStrokeState extends State<ApnaClinicAiMovingStroke>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _spin,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: SweepGradient(
              transform: GradientRotation(_spin.value * math.pi * 2),
              colors: widget.includeWhite
                  ? const [
                      ApnaClinicAiUiConfig.ctaDeep,
                      Color(0xFF7EE8DC),
                      Colors.white,
                      ApnaClinicAiUiConfig.cta,
                      Color(0xFF40AFA2),
                      ApnaClinicAiUiConfig.ctaDeep,
                    ]
                  : const [
                      ApnaClinicAiUiConfig.ctaDeep,
                      Color(0xFF40AFA2),
                      Color(0xFF7EE8DC),
                      ApnaClinicAiUiConfig.cta,
                      Color(0xFF40AFA2),
                      ApnaClinicAiUiConfig.ctaDeep,
                    ],
              stops: const [0.0, 0.18, 0.38, 0.58, 0.8, 1.0],
            ),
            boxShadow: widget.showShadow
                ? const [
                    BoxShadow(
                      color: Color(0x2800897B),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Color(0x0C061E40),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          padding: EdgeInsets.all(widget.strokeWidth),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ApnaClinicAiUiConfig.panel,
          borderRadius: BorderRadius.circular(
            math.max(0, widget.borderRadius - widget.strokeWidth),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
