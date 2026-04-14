import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyBookingWidget extends StatelessWidget {
  const EmptyBookingWidget({
    super.key,
    required this.description,
    required this.buttonText,
    required this.onTap,
    this.iconPath = 'assets/icons/empty.svg',
    this.height = 160,
  });

  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final String iconPath;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPaint(
      painter: const _DashedRoundedRectPainter(),
      child: Container(

        width: double.infinity,

        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color:   Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SvgPicture.asset(
                iconPath,
                width: 56,
                height: 56,
              ),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFFA1A7AE),
                fontWeight: FontWeight.w500,
                height: 1.2,
                fontSize: 12,
              ),
            ),
            OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 30),
                side: const BorderSide(color: Color(0xFFD4D8DD), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                buttonText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF1D2A3A),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(18);
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
