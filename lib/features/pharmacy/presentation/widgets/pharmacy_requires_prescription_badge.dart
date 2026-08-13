import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

class PharmacyRequiresPrescriptionBadge extends StatelessWidget {
  const PharmacyRequiresPrescriptionBadge({
    super.key,
    this.compact = false,
  });

  /// Smaller padding/text for medicine grid cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final iconSize = compact ? 12.r : 16.r;
    final fontSize = compact ? 8.sp : 11.sp;
    final hPad = compact ? 6.w : 10.w;
    final vPad = compact ? 4.h : 6.h;
    final radius = compact ? 8.r : 10.r;

    return CustomPaint(
      painter: _PrescriptionBadgeStrokePainter(
        color: AppColors.clrFFE9C3,
        strokeWidth: 1,
        bottomRightRadius: radius,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: AppColors.clrFFF4E5,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.iconsWarningTriangle,
              width: iconSize,
              height: iconSize,
            ),
            SizedBox(width: compact ? 4.w : 6.w),
            Flexible(
              child: Text(
                l10n.pharmacyRequiresPrescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.clrC85600,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stroke on top, right, and bottom only (open on the left).
class _PrescriptionBadgeStrokePainter extends CustomPainter {
  const _PrescriptionBadgeStrokePainter({
    required this.color,
    required this.strokeWidth,
    required this.bottomRightRadius,
  });

  final Color color;
  final double strokeWidth;
  final double bottomRightRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;

    final inset = strokeWidth / 2;
    final r = bottomRightRadius.clamp(0.0, size.shortestSide);

    final path = Path()
      ..moveTo(0, inset)
      ..lineTo(size.width - inset, inset)
      ..lineTo(size.width - inset, size.height - r)
      ..arcToPoint(
        Offset(size.width - r, size.height - inset),
        radius: Radius.circular((r - inset).clamp(0.0, r)),
        clockwise: true,
      )
      ..lineTo(0, size.height - inset);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PrescriptionBadgeStrokePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.bottomRightRadius != bottomRightRadius;
  }
}
