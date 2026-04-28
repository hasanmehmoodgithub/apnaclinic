import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class AiScreeningScreen extends StatelessWidget {
  const AiScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ───── Top bar ─────
            Container(
              color: const Color(0xFFF2F4F7),
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Center(
                        child: SvgPicture.asset(
                          ConsultationUiConfig.backArrowAsset,
                          width: 15.w,
                          height: 15.h,
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            ConsultationUiConfig.primaryText,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'AI Screening',
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: ConsultationUiConfig.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                ],
              ),
            ),

            // ───── Decorative wave at the top ─────
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: _WaveDecoration(),
            ),

            // ───── Welcome message & CTA (centered) ─────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome text with "Apna Clinic" highlighted
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 20.sp,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4A6B78),
                        ),
                        children: [
                          const TextSpan(text: 'Hello, welcome to '),
                          TextSpan(
                            text: 'Apna Clinic',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0A2540),
                              fontSize: 20.sp,
                            ),
                          ),
                          const TextSpan(text: " , let's get started"),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // "Let's Start" pill button
                    _LetsStartButton(
                      onTap: () {
                        // TODO: Navigate to the next step of AI screening
                        // e.g. Navigator.of(context).pushNamed(AppRoutes.aiScreeningForm);
                      },
                    ),

                    // Push content slightly above vertical center
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft teal wave decoration at the top of the screen.
class _WaveDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavePainter(),
      size: Size.infinite,
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final waveColors = [
      const Color(0xFFB8E3EA).withValues(alpha: 0.55),
      const Color(0xFFA3D8E0).withValues(alpha: 0.45),
      const Color(0xFF89CAD4).withValues(alpha: 0.35),
      const Color(0xFF6FBCC8).withValues(alpha: 0.3),
    ];

    for (int i = 0; i < waveColors.length; i++) {
      final paint = Paint()
        ..color = waveColors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2 + (i * 0.4)
        ..strokeCap = StrokeCap.round;

      final path = Path();
      final baseY = 50.0 + (i * 22);
      path.moveTo(-20, baseY);

      // Smooth flowing wave using cubic bezier curves.
      path.cubicTo(
        size.width * 0.18,
        baseY - 30 - (i * 3),
        size.width * 0.35,
        baseY + 40 + (i * 2),
        size.width * 0.5,
        baseY + 10 + (i * 2),
      );
      path.cubicTo(
        size.width * 0.65,
        baseY - 20 - (i * 2),
        size.width * 0.85,
        baseY + 35 + (i * 3),
        size.width + 20,
        baseY + 5,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gradient pill-shaped "Let's Start" button with soft outer glow.
class _LetsStartButton extends StatelessWidget {
  const _LetsStartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 200.w,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A8A98),
              Color(0xFF0E3B48),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A8A98).withValues(alpha: 0.25),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "Let's Start",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}