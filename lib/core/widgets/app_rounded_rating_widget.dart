import 'package:flutter/material.dart';

import '../extensions/screen_util_extensions.dart';

/// Shared rounded rating badge used across the app (lists, doctor detail, reviews).
/// Whole numbers render without decimals (e.g. `4 / 5`); fractions use one decimal.
class AppRoundedRatingWidget extends StatelessWidget {
  const AppRoundedRatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.width,
    this.height,
    this.textTheme,
  });

  final double rating;
  final double maxRating;
  final double? width;
  final double? height;
  final TextTheme? textTheme;

  static String formatScore(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = textTheme ?? Theme.of(context).textTheme;
    final safeMax = maxRating <= 0 ? 5.0 : maxRating;
    final clamped = rating.clamp(0.0, safeMax);
    final progress = (clamped / safeMax).clamp(0.0, 1.0);
    final ratingLabel = formatScore(clamped);
    final maxLabel = formatScore(safeMax);

    return SizedBox(
      width: width ?? 72.w,
      height: height ?? 30.h,
      child: CustomPaint(
        painter: _AppRoundedRatingBorderPainter(progress: progress),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: ratingLabel,
                      style: theme.titleMedium?.copyWith(
                        color: const Color(0xFF87D47A),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: theme.titleMedium?.copyWith(
                        color: const Color(0xFF6E84A5),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: maxLabel,
                      style: theme.titleMedium?.copyWith(
                        color: const Color(0xFF6E84A5),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppRoundedRatingBorderPainter extends CustomPainter {
  const _AppRoundedRatingBorderPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final borderRect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final borderRRect =
        RRect.fromRectAndRadius(borderRect, Radius.circular(6.r));
    final borderPath = Path()..addRRect(borderRRect);

    final trackPaint = Paint()
      ..color = const Color(0xFF60789C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = const Color(0xFF8DD97E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(borderPath, trackPaint);
    for (final metric in borderPath.computeMetrics()) {
      final progressPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(progressPath, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AppRoundedRatingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
