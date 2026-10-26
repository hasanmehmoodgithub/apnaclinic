import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Moving scan-line overlay while a prescription image is being read.
class PrescriptionScanOverlay extends StatefulWidget {
  const PrescriptionScanOverlay({super.key});

  @override
  State<PrescriptionScanOverlay> createState() =>
      _PrescriptionScanOverlayState();
}

class _PrescriptionScanOverlayState extends State<PrescriptionScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan;

  @override
  void initState() {
    super.initState();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ColoredBox(
      color: AppColors.clr0B2239.withValues(alpha: 0.42),
      child: AnimatedBuilder(
        animation: _scan,
        builder: (context, _) {
          return CustomPaint(
            painter: _ScanFramePainter(progress: _scan.value),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 28.w),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.clr0B2239.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.clr27B3A6.withValues(alpha: 0.55),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      color: AppColors.clrWhite,
                      size: 18.r,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        l10n.pharmacyScanReading,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.clrWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  const _ScanFramePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = size.shortestSide * 0.08;
    final frame = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final corner = size.shortestSide * 0.08;
    final stroke = Paint()
      ..color = AppColors.clr27B3A6
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void cornerPath(Offset a, Offset b, Offset c) {
      canvas.drawLine(a, b, stroke);
      canvas.drawLine(b, c, stroke);
    }

    cornerPath(
      frame.topLeft.translate(0, corner),
      frame.topLeft,
      frame.topLeft.translate(corner, 0),
    );
    cornerPath(
      frame.topRight.translate(-corner, 0),
      frame.topRight,
      frame.topRight.translate(0, corner),
    );
    cornerPath(
      frame.bottomLeft.translate(0, -corner),
      frame.bottomLeft,
      frame.bottomLeft.translate(corner, 0),
    );
    cornerPath(
      frame.bottomRight.translate(-corner, 0),
      frame.bottomRight,
      frame.bottomRight.translate(0, -corner),
    );

    final y = frame.top + frame.height * progress;
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.clr27B3A6.withValues(alpha: 0),
          AppColors.clr27B3A6,
          AppColors.clrWhite,
          AppColors.clr27B3A6,
          AppColors.clr27B3A6.withValues(alpha: 0),
        ],
        stops: const [0, 0.2, 0.5, 0.8, 1],
      ).createShader(Rect.fromLTWH(frame.left, y - 1, frame.width, 2))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(frame.left, y), Offset(frame.right, y), linePaint);

    final glow = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.clr27B3A6.withValues(alpha: 0),
          AppColors.clr27B3A6.withValues(alpha: 0.22),
          AppColors.clr27B3A6.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(frame.left, y - 18, frame.width, 36));
    canvas.drawRect(Rect.fromLTWH(frame.left, y - 18, frame.width, 36), glow);
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
