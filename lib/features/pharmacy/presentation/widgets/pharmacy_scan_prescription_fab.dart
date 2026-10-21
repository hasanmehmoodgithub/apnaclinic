import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/assets.dart';

/// Floating prescription scanner on the pharmacy home. Tap opens the scan screen.
class PharmacyScanPrescriptionFab extends StatefulWidget {
  const PharmacyScanPrescriptionFab({super.key});

  @override
  State<PharmacyScanPrescriptionFab> createState() =>
      _PharmacyScanPrescriptionFabState();
}

class _PharmacyScanPrescriptionFabState
    extends State<PharmacyScanPrescriptionFab>
    with TickerProviderStateMixin {
  late final AnimationController _float;
  late final AnimationController _pulse;
  late final AnimationController _scan;
  late final AnimationController _enter;
  late final AnimationController _orbit;
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
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    )..repeat();
  }

  @override
  void dispose() {
    _float.dispose();
    _pulse.dispose();
    _scan.dispose();
    _enter.dispose();
    _orbit.dispose();
    super.dispose();
  }

  void _openScan() {
    context.pushNamed(AppRoutes.pharmacyPrescriptionScan);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final animate = ModalRoute.of(context)?.isCurrent ?? true;

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
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _float,
              _pulse,
              _scan,
              _enter,
              _orbit,
            ]),
            builder: (context, _) {
              final lift = Curves.easeInOut.transform(_float.value);
              final enter = Curves.easeOutBack.transform(_enter.value);
              final scale = (enter * (_pressed ? 0.94 : 1)).clamp(0.0, 1.15);
              return Transform.translate(
                offset: Offset(0, -9.h * lift),
                child: Transform.rotate(
                  angle: (lift - 0.5) * 0.05,
                  child: Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ScanBubble(
                          title: l10n.pharmacyScanPrescription,
                          subtitle: l10n.pharmacyScanFabHint,
                        ),
                        SizedBox(height: 4.h),
                        _ScannerAvatar(
                          pulse: _pulse.value,
                          scan: Curves.easeInOut.transform(_scan.value),
                          lift: lift,
                          orbit: _orbit.value,
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
    );
  }
}

class _ScanBubble extends StatelessWidget {
  const _ScanBubble({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 156.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.clrE8F8F5),
            boxShadow: [
              BoxShadow(
                color: AppColors.clr061E40.withValues(alpha: 0.08),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.clr00897B,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.clr6B7280,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        CustomPaint(size: Size(12.r, 7.r), painter: const _BubbleTailPainter()),
      ],
    );
  }
}

class _ScannerAvatar extends StatelessWidget {
  const _ScannerAvatar({
    required this.pulse,
    required this.scan,
    required this.lift,
    required this.orbit,
  });

  final double pulse;
  final double scan;
  final double lift;
  final double orbit;

  @override
  Widget build(BuildContext context) {
    final head = 68.r;
    final orbitRadius = 42.r;
    final chip = 24.r;
    final box = orbitRadius * 2 + chip;
    final layers = <({double depth, Widget child})>[
      (depth: -2, child: _OrbitTrack(diameter: orbitRadius * 2)),
      (depth: -1.6, child: _PulseRing(t: pulse, diameter: head)),
      (depth: -1.5, child: _PulseRing(t: (pulse + 0.5) % 1, diameter: head)),
      (
        depth: -1.2,
        child: Transform.translate(
          offset: Offset(0, head * 0.48),
          child: Transform.scale(
            scale: 1 - (0.22 * lift),
            child: Container(
              width: 36.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: AppColors.clr00897B.withValues(
                  alpha: 0.18 - (0.07 * lift),
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      ),
      (
        depth: 0,
        child: CustomPaint(
          size: Size(head, head),
          painter: _PrescriptionScannerPainter(scan: scan),
        ),
      ),
    ];

    const orbitIcons = [Assets.iconsMedicine, Assets.iconsLab];
    for (var i = 0; i < orbitIcons.length; i++) {
      final angle = (orbit * math.pi * 2) + (i * math.pi) - math.pi / 2;
      layers.add((
        depth: math.sin(angle),
        child: Transform.translate(
          offset: Offset(
            math.cos(angle) * orbitRadius,
            math.sin(angle) * orbitRadius,
          ),
          child: _OrbitChip(asset: orbitIcons[i]),
        ),
      ));
    }
    final cameraAngle = (orbit * math.pi * 2) + math.pi / 2;
    layers.add((
      depth: math.sin(cameraAngle),
      child: Transform.translate(
        offset: Offset(
          math.cos(cameraAngle) * orbitRadius,
          math.sin(cameraAngle) * orbitRadius,
        ),
        child: const _CameraChip(),
      ),
    ));
    layers.sort((a, b) => a.depth.compareTo(b.depth));

    return SizedBox(
      width: box,
      height: box,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [for (final layer in layers) layer.child],
      ),
    );
  }
}

class _OrbitTrack extends StatelessWidget {
  const _OrbitTrack({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.clr0FAA9A.withValues(alpha: 0.35),
          width: 1.2.r,
        ),
      ),
    );
  }
}

class _OrbitChip extends StatelessWidget {
  const _OrbitChip({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final size = 24.r;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.clrE8F8F5),
        boxShadow: [
          BoxShadow(
            color: AppColors.clr00897B.withValues(alpha: 0.16),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: SvgPicture.asset(
        asset,
        width: 14.r,
        height: 14.r,
        colorFilter: const ColorFilter.mode(
          AppColors.clr00897B,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _CameraChip extends StatelessWidget {
  const _CameraChip();

  @override
  Widget build(BuildContext context) {
    final size = 24.r;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.clrE8F8F5),
        boxShadow: [
          BoxShadow(
            color: AppColors.clr00897B.withValues(alpha: 0.16),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Icon(
        Icons.photo_camera_outlined,
        size: 14.r,
        color: AppColors.clr00897B,
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
    final opacity = (1 - t) * 0.32;
    return Transform.scale(
      scale: 0.82 + (0.5 * t),
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.clr0FAA9A.withValues(alpha: opacity),
            width: 2.r,
          ),
        ),
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  const _BubbleTailPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.clrWhite);
    final edge = Paint()
      ..color = AppColors.clrE8F8F5
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, 0), Offset(size.width / 2, size.height), edge);
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width / 2, size.height),
      edge,
    );
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) => false;
}

class _PrescriptionScannerPainter extends CustomPainter {
  const _PrescriptionScannerPainter({required this.scan});

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
      ..strokeWidth = math.max(1.4, w * 0.028);
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
        ..strokeWidth = math.max(1.6, w * 0.03)
        ..strokeCap = StrokeCap.round,
    );

    _lens(canvas, Offset(w * 0.5, h * 0.2), w * 0.09);
  }

  void _corners(Canvas canvas, Rect rect, double arm) {
    final paint = Paint()
      ..color = AppColors.clrWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.6, arm * 0.28)
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
  bool shouldRepaint(covariant _PrescriptionScannerPainter oldDelegate) {
    return oldDelegate.scan != scan;
  }
}
