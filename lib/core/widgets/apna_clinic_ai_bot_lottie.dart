import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_colors.dart';
import '../extensions/screen_util_extensions.dart';

/// Looping chatbot inside the teal doctor-bot badge.
class ApnaClinicAiBotLottie extends StatelessWidget {
  const ApnaClinicAiBotLottie({
    super.key,
    this.size = 60,
    this.animate = true,
    this.sparkle = true,
  });

  static const asset = 'assets/images/live_chatbot.json';

  /// Badge diameter before screen-util scaling.
  final double size;
  final bool animate;
  final bool sparkle;

  @override
  Widget build(BuildContext context) {
    final box = size.r;
    return Container(
      width: box,
      height: box,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.clr00A08F,
        boxShadow: [
          BoxShadow(
            color: AppColors.clr00A08F.withValues(alpha: 0.28),
            blurRadius: box * 0.16,
            offset: Offset(0, box * 0.06),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.all(box * 0.02),
            child: Transform.scale(
              scale: 1.18,
              child: Lottie.asset(
                asset,
                fit: BoxFit.contain,
                alignment: const Alignment(0, 0.08),
                repeat: true,
                animate: animate,
              ),
            ),
          ),
          if (sparkle)
            Align(
              alignment: const Alignment(-0.62, 0.38),
              child: _BotSparkle(size: box * 0.16),
            ),
        ],
      ),
    );
  }
}

class _BotSparkle extends StatelessWidget {
  const _BotSparkle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _BotSparklePainter(),
    );
  }
}

class _BotSparklePainter extends CustomPainter {
  const _BotSparklePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.clrCCFFF7;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..quadraticBezierTo(w * 0.56, h * 0.44, w, h * 0.5)
      ..quadraticBezierTo(w * 0.56, h * 0.56, w * 0.5, h)
      ..quadraticBezierTo(w * 0.44, h * 0.56, 0, h * 0.5)
      ..quadraticBezierTo(w * 0.44, h * 0.44, w * 0.5, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BotSparklePainter oldDelegate) => false;
}
