import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class EmptyBookingWidget extends StatelessWidget {
  const EmptyBookingWidget({
    super.key,
    required this.description,
    required this.buttonText,
    required this.onTap,
    this.iconPath = 'assets/icons/empty.svg',
    this.alignment = Alignment.topCenter,
    this.backgroundColor = Colors.white,
  });

  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final String iconPath;
  final Alignment alignment;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: alignment,
      child: CustomPaint(
        painter: const _DashedRoundedRectPainter(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 56.r,
                height: 56.r,
              ),
              SizedBox(height: 10.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFA1A7AE),
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 12.h),
              OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(0, 30.h),
                  side: BorderSide(
                    color: const Color(0xFFD4D8DD),
                    width: 1.5.r,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF1D2A3A),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(18.r);
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = const Color(0xFFD7DBE0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 6.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
