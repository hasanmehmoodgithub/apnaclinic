import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';

/// Animated scan control beside the medicine search field (same motion as the
/// old floating scanner, sized for the search row).
class PharmacyScanPrescriptionSearchButton extends StatefulWidget {
  const PharmacyScanPrescriptionSearchButton({super.key});

  @override
  State<PharmacyScanPrescriptionSearchButton> createState() =>
      _PharmacyScanPrescriptionSearchButtonState();
}

class _PharmacyScanPrescriptionSearchButtonState
    extends State<PharmacyScanPrescriptionSearchButton>
    with TickerProviderStateMixin {
  late final AnimationController _float;
  late final AnimationController _pulse;
  late final AnimationController _scan;
  late final AnimationController _enter;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 640),
    )..forward();
  }

  @override
  void dispose() {
    _float.dispose();
    _pulse.dispose();
    _scan.dispose();
    _enter.dispose();
    super.dispose();
  }

  void _openScan() {
    context.pushNamed(AppRoutes.pharmacyPrescriptionScan);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final animate = ModalRoute.of(context)?.isCurrent ?? true;
    final size = 45.r;

    return TickerMode(
      enabled: animate,
      child: Semantics(
        button: true,
        excludeSemantics: true,
        label: '${l10n.pharmacyScanPrescription}. ${l10n.pharmacyScanFabHint}',
        child: GestureDetector(
          onTap: _openScan,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: SizedBox(
            width: size,
            height: size,
            child: AnimatedBuilder(
              animation: Listenable.merge([_float, _pulse, _scan, _enter]),
              builder: (context, _) {
                final lift = Curves.easeInOut.transform(_float.value);
                final enter = Curves.easeOutBack.transform(_enter.value);
                final scale =
                    (enter * (_pressed ? 0.92 : 1)).clamp(0.0, 1.12);
                return Transform.translate(
                  offset: Offset(0, -3.h * lift),
                  child: Transform.rotate(
                    angle: (lift - 0.5) * 0.04,
                    child: Transform.scale(
                      scale: scale,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          _PulseRing(t: _pulse.value, diameter: size),
                          _PulseRing(
                            t: (_pulse.value + 0.5) % 1,
                            diameter: size,
                          ),
                          CustomPaint(
                            size: Size(size * 0.92, size * 0.92),
                            painter: _MiniPrescriptionScannerPainter(
                              scan: Curves.easeInOut.transform(_scan.value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.t, required this.diameter});

  final double t;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final opacity = (1 - t) * 0.28;
    return Transform.scale(
      scale: 0.88 + (0.28 * t),
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.clr0FAA9A.withValues(alpha: opacity),
            width: 1.6.r,
          ),
        ),
      ),
    );
  }
}

class _MiniPrescriptionScannerPainter extends CustomPainter {
  const _MiniPrescriptionScannerPainter({required this.scan});

  final double scan;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.56),
        width: w * 0.72,
        height: h * 0.62,
      ),
      Radius.circular(w * 0.16),
    );

    canvas.drawRRect(
      body.shift(Offset(0, h * 0.03)),
      Paint()
        ..color = AppColors.clr00897B.withValues(alpha: 0.16)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.06),
    );

    canvas.drawRRect(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.clr40AFA2,
            AppColors.clr0FAA9A,
            AppColors.clr00897B,
          ],
        ).createShader(body.outerRect),
    );

    final glass = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.58),
        width: w * 0.5,
        height: h * 0.42,
      ),
      Radius.circular(w * 0.06),
    );
    canvas.drawRRect(glass, Paint()..color = AppColors.clrWhite);

    final card = glass.outerRect.deflate(w * 0.045);
    final linePaint = Paint()
      ..color = AppColors.clrC8EEF2
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(1.2, w * 0.028);
    for (var i = 0; i < 3; i++) {
      final y = card.top + card.height * (0.28 + i * 0.24);
      final inset = i == 2 ? card.width * 0.28 : card.width * 0.08;
      canvas.drawLine(
        Offset(card.left + inset, y),
        Offset(card.right - card.width * 0.08, y),
        linePaint,
      );
    }

    _corners(canvas, glass.outerRect.inflate(w * 0.035), w * 0.045);

    final beamY = glass.top + (glass.height * scan);
    final beam = Rect.fromLTWH(
      glass.left + w * 0.02,
      beamY - w * 0.012,
      glass.width - w * 0.04,
      w * 0.024,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        beam.inflate(w * 0.02),
        Radius.circular(w * 0.04),
      ),
      Paint()..color = AppColors.clr0FAA9A.withValues(alpha: 0.22),
    );
    canvas.drawLine(
      Offset(beam.left, beamY),
      Offset(beam.right, beamY),
      Paint()
        ..color = AppColors.clr00897B
        ..strokeWidth = math.max(1.4, w * 0.03)
        ..strokeCap = StrokeCap.round,
    );

    _lens(canvas, Offset(w * 0.5, h * 0.2), w * 0.09);
  }

  void _corners(Canvas canvas, Rect rect, double arm) {
    final paint = Paint()
      ..color = AppColors.clrWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.4, arm * 0.28)
      ..strokeCap = StrokeCap.round;
    void corner(Offset start, Offset turn, Offset end) {
      canvas.drawPath(
        Path()
          ..moveTo(start.dx, start.dy)
          ..lineTo(turn.dx, turn.dy)
          ..lineTo(end.dx, end.dy),
        paint,
      );
    }

    corner(
      rect.topLeft.translate(0, arm),
      rect.topLeft,
      rect.topLeft.translate(arm, 0),
    );
    corner(
      rect.topRight.translate(0, arm),
      rect.topRight,
      rect.topRight.translate(-arm, 0),
    );
    corner(
      rect.bottomLeft.translate(0, -arm),
      rect.bottomLeft,
      rect.bottomLeft.translate(arm, 0),
    );
    corner(
      rect.bottomRight.translate(0, -arm),
      rect.bottomRight,
      rect.bottomRight.translate(-arm, 0),
    );
  }

  void _lens(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = AppColors.clrWhite);
    canvas.drawCircle(
      center,
      radius * 0.62,
      Paint()..color = AppColors.clrE0F7F6,
    );
    canvas.drawCircle(
      center,
      radius * 0.34,
      Paint()..color = AppColors.clr00897B,
    );
    canvas.drawCircle(
      center.translate(-radius * 0.12, -radius * 0.12),
      radius * 0.1,
      Paint()..color = AppColors.clrWhite.withValues(alpha: 0.85),
    );
  }

  @override
  bool shouldRepaint(covariant _MiniPrescriptionScannerPainter oldDelegate) {
    return oldDelegate.scan != scan;
  }
}
