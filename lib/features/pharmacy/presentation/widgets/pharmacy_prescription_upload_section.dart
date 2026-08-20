import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import 'pharmacy_prescription_thumbnail.dart';

class PharmacyPrescriptionUploadSection extends StatelessWidget {
  const PharmacyPrescriptionUploadSection({
    super.key,
    required this.onPickFile,
    this.fileName,
    this.filePath,
    this.onClearFile,
  });

  final VoidCallback onPickFile;
  final String? fileName;
  final String? filePath;
  final VoidCallback? onClearFile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selectedName = fileName?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.pharmacyPrescriptionRequiredMessage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr4A4A4A,
            fontSize: 13.sp,
            height: 1.35,
          ),
        ),
        SizedBox(height: 12.h),
        CustomPaint(
          painter: const _PharmacyDashedRoundedBorderPainter(
            color: AppColors.clrC8EEF2,
            strokeWidth: 1.5,
            radius: 12,
            dashWidth: 6,
            dashSpace: 4,
          ),
          child: InkWell(
            onTap: onPickFile,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
              child: selectedName.isNotEmpty
                  ? Column(
                      children: [
                        PharmacyPrescriptionThumbnail(
                          localPath: filePath,
                          size: 96.r,
                        ),
                        if (!PharmacyPrescriptionThumbnail.isImageSource(
                          filePath ?? selectedName,
                        )) ...[
                          SizedBox(height: 10.h),
                          Text(
                            selectedName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.clr4A4A4A,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Column(
                      children: [
                        SvgPicture.asset(
                          Assets.consultationUpload,
                          width: 28.w,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.clr8A9AAE,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          l10n.pharmacyPrescriptionUploadHint,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.clr4A4A4A,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          l10n.pharmacyPrescriptionUploadFormats,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.clr8A9AAE,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (selectedName.isNotEmpty && onClearFile != null) ...[
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onClearFile,
              child: Text(l10n.pharmacyPrescriptionRemoveFile),
            ),
          ),
        ],
      ],
    );
  }
}

class _PharmacyDashedRoundedBorderPainter extends CustomPainter {
  const _PharmacyDashedRoundedBorderPainter({
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
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _PharmacyDashedRoundedBorderPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
