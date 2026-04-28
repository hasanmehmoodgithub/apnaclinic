import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class RatingProgressBadge extends StatelessWidget {
  const RatingProgressBadge({
    super.key,
    required this.rating,
    required this.maxRating,
    required this.textTheme,
  });

  final double rating;
  final double maxRating;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final progress = (rating / maxRating).clamp(0.0, 1.0);
    return CustomPaint(
      painter: _RatingBorderPainter(progress: progress),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: rating.toStringAsFixed(1),
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF87D47A),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' / ',
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6E84A5),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: maxRating.toStringAsFixed(0),
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6E84A5),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingBorderPainter extends CustomPainter {
  const _RatingBorderPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final borderRect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final borderRRect = RRect.fromRectAndRadius(borderRect, Radius.circular(6.r));
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
  bool shouldRepaint(covariant _RatingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
