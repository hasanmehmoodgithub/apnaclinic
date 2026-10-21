import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/assets.dart';
import '../constants/main_navigation_tabs.dart';
import '../cubit/main_navigation_cubit.dart';

/// Floating Apna Clinic bot on home. Tap opens Apna Clinic AI.
class ApnaClinicBotFab extends StatefulWidget {
  const ApnaClinicBotFab({super.key});

  @override
  State<ApnaClinicBotFab> createState() => _ApnaClinicBotFabState();
}

class _ApnaClinicBotFabState extends State<ApnaClinicBotFab>
    with TickerProviderStateMixin {
  late final AnimationController _float;
  late final AnimationController _pulse;
  late final AnimationController _blink;
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
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
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
    _blink.dispose();
    _enter.dispose();
    _orbit.dispose();
    super.dispose();
  }

  /// Eyes stay open, then close once near the end of each cycle.
  double _eyeOpen(double t) {
    const start = 0.78;
    const end = 0.92;
    if (t < start || t > end) return 1;
    final local = (t - start) / (end - start);
    final closed = local < 0.5 ? local * 2 : (1 - local) * 2;
    return 1 - closed;
  }

  void _openAi() {
    context.pushNamed(AppRoutes.apnaClinicAi);
  }

  @override
  Widget build(BuildContext context) {
    final animate = context.select<MainNavigationCubit, bool>(
      (cubit) => cubit.state.currentIndex == MainNavigationTabs.home,
    );
    final l10n = AppLocalizations.of(context)!;

    return TickerMode(
      enabled: animate,
      child: Semantics(
        button: true,
        excludeSemantics: true,
        label: '${l10n.apnaClinicBotLabel}. ${l10n.apnaClinicBotBubble}',
        child: GestureDetector(
          onTap: _openAi,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _float,
              _pulse,
              _blink,
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
                  angle: (lift - 0.5) * 0.06,
                  child: Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _AskBubble(
                          title: l10n.apnaClinicBotLabel,
                          subtitle: l10n.apnaClinicBotBubble,
                        ),
                        SizedBox(height: 4.h),
                        _BotAvatar(
                          pulse: _pulse.value,
                          eyeOpen: _eyeOpen(_blink.value),
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

class _AskBubble extends StatelessWidget {
  const _AskBubble({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 148.w),
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

class _BotAvatar extends StatelessWidget {
  const _BotAvatar({
    required this.pulse,
    required this.eyeOpen,
    required this.lift,
    required this.orbit,
  });

  final double pulse;
  final double eyeOpen;
  final double lift;
  final double orbit;

  static const List<String> _orbitIcons = [
    Assets.iconsMedicine,
    Assets.iconsDoctor,
    Assets.iconsLab,
  ];

  @override
  Widget build(BuildContext context) {
    final head = 64.r;
    final orbitRadius = 40.r;
    final chip = 24.r;
    final box = orbitRadius * 2 + chip;
    final layers = <({double depth, Widget child})>[
      (depth: -2, child: _OrbitTrack(diameter: orbitRadius * 2)),
      (depth: -1.6, child: _PulseRing(t: pulse, diameter: head)),
      (depth: -1.5, child: _PulseRing(t: (pulse + 0.5) % 1, diameter: head)),
      (
        depth: -1.2,
        child: Transform.translate(
          offset: Offset(0, head * 0.46),
          child: Transform.scale(
            scale: 1 - (0.22 * lift),
            child: Container(
              width: 34.r,
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
          painter: _ClinicBotPainter(eyeOpen: eyeOpen),
        ),
      ),
    ];

    for (var i = 0; i < _orbitIcons.length; i++) {
      final angle = (orbit * math.pi * 2) + (i * math.pi * 2 / 3) - math.pi / 2;
      layers.add((
        depth: math.sin(angle),
        child: Transform.translate(
          offset: Offset(
            math.cos(angle) * orbitRadius,
            math.sin(angle) * orbitRadius,
          ),
          child: Transform.rotate(
            angle: orbit * math.pi * 2,
            child: _OrbitChip(asset: _orbitIcons[i]),
          ),
        ),
      ));
    }
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

class _ClinicBotPainter extends CustomPainter {
  const _ClinicBotPainter({required this.eyeOpen});

  final double eyeOpen;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final cx = w / 2;
    final r = w * 0.34;
    final cy = size.height * 0.58;
    final center = Offset(cx, cy);

    canvas.drawCircle(
      center.translate(0, r * 0.08),
      r,
      Paint()
        ..color = AppColors.clr00897B.withValues(alpha: 0.16)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.16),
    );

    _ear(canvas, Offset(cx - r * 0.98, cy), r);
    _ear(canvas, Offset(cx + r * 0.98, cy), r);

    final headRect = Rect.fromCircle(center: center, radius: r);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.clr40AFA2,
            AppColors.clr0FAA9A,
            AppColors.clr00897B,
          ],
        ).createShader(headRect),
    );

    canvas.drawCircle(
      center.translate(-r * 0.32, -r * 0.36),
      r * 0.16,
      Paint()..color = AppColors.clrWhite.withValues(alpha: 0.28),
    );

    final face = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, r * 0.08),
        width: r * 1.42,
        height: r * 1.18,
      ),
      Radius.circular(r * 0.42),
    );
    canvas.drawRRect(face, Paint()..color = AppColors.clrWhite);

    canvas.drawCircle(
      center.translate(-r * 0.34, r * 0.22),
      r * 0.1,
      Paint()..color = AppColors.clrE8F8F5,
    );
    canvas.drawCircle(
      center.translate(r * 0.34, r * 0.22),
      r * 0.1,
      Paint()..color = AppColors.clrE8F8F5,
    );

    _eye(canvas, center.translate(-r * 0.28, -r * 0.02), r * 0.16);
    _eye(canvas, center.translate(r * 0.28, -r * 0.02), r * 0.16);

    final smile = Path()
      ..moveTo(cx - r * 0.24, cy + r * 0.28)
      ..quadraticBezierTo(cx, cy + r * 0.5, cx + r * 0.24, cy + r * 0.28);
    canvas.drawPath(
      smile,
      Paint()
        ..color = AppColors.clr00897B
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.6, r * 0.07)
        ..strokeCap = StrokeCap.round,
    );

    _antenna(canvas, Offset(cx, cy - r), r);
    _badge(canvas, center.translate(r * 0.72, r * 0.62), r * 0.24);
  }

  void _ear(Canvas canvas, Offset c, double r) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: r * 0.26, height: r * 0.46),
      Radius.circular(r * 0.1),
    );
    canvas.drawRRect(rect, Paint()..color = AppColors.clrE8F8F5);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = AppColors.clr0FAA9A
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, r * 0.04),
    );
  }

  void _eye(Canvas canvas, Offset c, double w) {
    final open = eyeOpen.clamp(0.0, 1.0);
    if (open < 0.22) {
      canvas.drawLine(
        c.translate(-w * 0.7, 0),
        c.translate(w * 0.7, 0),
        Paint()
          ..color = AppColors.clr061E40
          ..strokeWidth = math.max(1.4, w * 0.28)
          ..strokeCap = StrokeCap.round,
      );
      return;
    }
    canvas.drawOval(
      Rect.fromCenter(center: c, width: w, height: w * 1.35 * open),
      Paint()..color = AppColors.clr061E40,
    );
    canvas.drawCircle(
      c.translate(w * 0.16, -w * 0.28 * open),
      w * 0.18,
      Paint()..color = AppColors.clrWhite,
    );
  }

  void _antenna(Canvas canvas, Offset base, double r) {
    final top = base.translate(0, -r * 0.42);
    final stick = Paint()
      ..color = AppColors.clr00897B
      ..strokeWidth = math.max(1.8, r * 0.07)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(base, top, stick);
    canvas.drawCircle(top, r * 0.16, Paint()..color = AppColors.clrWhite);
    canvas.drawCircle(
      top,
      r * 0.16,
      Paint()
        ..color = AppColors.clr0FAA9A
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, r * 0.045),
    );
    _plus(canvas, top, r * 0.08, AppColors.clr0FAA9A, r * 0.045);
  }

  void _badge(Canvas canvas, Offset c, double radius) {
    canvas.drawCircle(c, radius, Paint()..color = AppColors.clrWhite);
    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..color = AppColors.clr0FAA9A
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, radius * 0.16),
    );
    _plus(canvas, c, radius * 0.48, AppColors.clr0FAA9A, radius * 0.18);
  }

  void _plus(Canvas canvas, Offset c, double arm, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = math.max(1.4, width)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(c.translate(-arm, 0), c.translate(arm, 0), paint);
    canvas.drawLine(c.translate(0, -arm), c.translate(0, arm), paint);
  }

  @override
  bool shouldRepaint(covariant _ClinicBotPainter oldDelegate) {
    return oldDelegate.eyeOpen != eyeOpen;
  }
}
