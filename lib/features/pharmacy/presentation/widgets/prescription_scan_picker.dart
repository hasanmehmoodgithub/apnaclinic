import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';
import 'prescription_scan_overlay.dart';

class PrescriptionScanPicker extends StatelessWidget {
  const PrescriptionScanPicker({
    super.key,
    required this.imagePath,
    required this.extracting,
    required this.onPick,
    required this.onExtract,
  });

  final String? imagePath;
  final bool extracting;
  final VoidCallback onPick;
  final VoidCallback onExtract;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final path = imagePath?.trim() ?? '';
    final hasImage = path.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.pharmacyScanUploadTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.clr0B2239,
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Material(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(20.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: extracting ? null : onPick,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: double.infinity,
              height: hasImage ? 240.h : 185.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: hasImage
                    ? Border.all(color: AppColors.clrC8EEF2)
                    : null,
              ),
              child: hasImage
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(path), fit: BoxFit.cover),
                        if (extracting) const PrescriptionScanOverlay(),
                        Positioned(
                          right: 10.w,
                          bottom: 10.h,
                          child: Material(
                            color: AppColors.clrWhite.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(99.r),
                            child: InkWell(
                              onTap: extracting ? null : onPick,
                              borderRadius: BorderRadius.circular(99.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cameraswitch_outlined,
                                      size: 16.r,
                                      color: AppColors.clr00897B,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      l10n.pharmacyScanChangePhoto,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                        color: AppColors.clr00897B,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.all(12.r),
                      child: CustomPaint(
                      painter: _DashedBorderPainter(
                        color: AppColors.clr27B3A6.withValues(alpha: 0.35),
                        radius: 20.r,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 55.r,
                                height:55.r,
                                decoration: const BoxDecoration(
                                  color: AppColors.clrE0F7F6,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.document_scanner_outlined,
                                  color: AppColors.clr27B3A6,
                                  size: 24.r,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Text(
                                l10n.pharmacyScanPrescriptionHint,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: AppColors.clr0B2239,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                l10n.pharmacyScanUploadSubtitle,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.clr8A9AAE,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
        if (hasImage) ...[
          SizedBox(height: 14.h),
          AppButtonWidget(
            title: extracting
                ? l10n.pharmacyScanReading
                : l10n.pharmacyScanExtract,
            bgClr: AppColors.clr27B3A6,
            onTap: extracting ? null : onExtract,
          ),
        ],
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
          Radius.circular(radius),
        ),
      );
    const dashWidth = 7.0;
    const dashSpace = 5.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
