import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class DocumentsSection extends StatelessWidget {
  const DocumentsSection({
    super.key,
    required this.textTheme,
    required this.onBrowseTap,
    required this.attachedMediaName,
  });

  final TextTheme textTheme;
  final VoidCallback onBrowseTap;
  final String? attachedMediaName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documents',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1E2D3F),
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E6EB), width: 1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SizedBox(
            height: 46.h,
            child: CustomPaint(
              painter: const _DashedRoundedBorderPainter(
                color: Color(0xFFD7DDE5),
                strokeWidth: 1,
                radius: 6,
                dashWidth: 3,
                dashSpace: 3,
              ),
              child: InkWell(
                onTap: onBrowseTap,
                borderRadius: BorderRadius.circular(6.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/consultation/upload.svg',
                      width: 19.w,
                      height: 16.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Browse',
                      style: textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF3C4858),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if ((attachedMediaName ?? '').isNotEmpty) ...[
          SizedBox(height: 8.h),
          Text(
            'Attached: $attachedMediaName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF5F6C7C),
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius.r));
    final path = Path()..addRRect(rRect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
