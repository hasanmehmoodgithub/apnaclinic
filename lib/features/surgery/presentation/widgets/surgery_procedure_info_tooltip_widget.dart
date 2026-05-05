import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryProcedureInfoTooltipWidget extends StatelessWidget {
  const SurgeryProcedureInfoTooltipWidget({
    super.key,
    required this.title,
    required this.description,
    required this.tileOffset,
    required this.tileSize,
    required this.onDismiss,
  });

  final String title;
  final String description;
  final Offset tileOffset;
  final Size tileSize;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = 16.w;
    final bubbleMaxWidth = screenSize.width - (horizontalPadding * 2);

    double bubbleLeft = tileOffset.dx;
    if (bubbleLeft + bubbleMaxWidth > screenSize.width - horizontalPadding) {
      bubbleLeft = screenSize.width - horizontalPadding - bubbleMaxWidth;
    }
    if (bubbleLeft < horizontalPadding) {
      bubbleLeft = horizontalPadding;
    }

    final tileCenterX = tileOffset.dx + (tileSize.width / 2);
    double tailX = tileCenterX - bubbleLeft - 9.w;
    final tailInset = 20.w;
    if (tailX < tailInset) {
      tailX = tailInset;
    }
    if (tailX > bubbleMaxWidth - tailInset - 18.w) {
      tailX = bubbleMaxWidth - tailInset - 18.w;
    }

    const tailHeight = 10.0;
    const gapBelowBubble = 6.0;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: _BarrierWithHolePainter(
                holeRect: Rect.fromLTWH(
                  tileOffset.dx,
                  tileOffset.dy,
                  tileSize.width,
                  tileSize.height,
                ),
                holeRadius: 10.7.r,
                barrierColor: const Color.fromRGBO(0, 0, 0, 0.35),
              ),
            ),
          ),
        ),
        Positioned(
          left: bubbleLeft,
          top: null,
          bottom:
              screenSize.height - tileOffset.dy + gapBelowBubble - tailHeight,
          width: bubbleMaxWidth,
          child: Material(
            color: Colors.transparent,
            child: _TooltipBubble(
              title: title,
              description: description,
              tailX: tailX,
              tailHeight: tailHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _TooltipBubble extends StatelessWidget {
  const _TooltipBubble({
    required this.title,
    required this.description,
    required this.tailX,
    required this.tailHeight,
  });

  final String title;
  final String description;
  final double tailX;
  final double tailHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPaint(
      painter: _DownwardTailPainter(
        bubbleColor: Colors.white,
        tailOffsetFromLeft: tailX,
        tailWidth: 18.w,
        tailHeight: tailHeight,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: tailHeight),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.18),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF0A2540),
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF7A8AA0),
                fontSize: 14.5.sp,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownwardTailPainter extends CustomPainter {
  _DownwardTailPainter({
    required this.bubbleColor,
    required this.tailOffsetFromLeft,
    required this.tailWidth,
    required this.tailHeight,
  });

  final Color bubbleColor;
  final double tailOffsetFromLeft;
  final double tailWidth;
  final double tailHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleBottom = size.height - tailHeight;
    final path = Path()
      ..moveTo(tailOffsetFromLeft, bubbleBottom)
      ..lineTo(tailOffsetFromLeft + (tailWidth / 2), size.height)
      ..lineTo(tailOffsetFromLeft + tailWidth, bubbleBottom)
      ..close();

    canvas.drawShadow(path, const Color.fromRGBO(0, 0, 0, 0.18), 4, false);

    final paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DownwardTailPainter oldDelegate) =>
      oldDelegate.bubbleColor != bubbleColor ||
      oldDelegate.tailOffsetFromLeft != tailOffsetFromLeft ||
      oldDelegate.tailWidth != tailWidth ||
      oldDelegate.tailHeight != tailHeight;
}

class _BarrierWithHolePainter extends CustomPainter {
  _BarrierWithHolePainter({
    required this.holeRect,
    required this.holeRadius,
    required this.barrierColor,
  });

  final Rect holeRect;
  final double holeRadius;
  final Color barrierColor;

  @override
  void paint(Canvas canvas, Size size) {
    final screenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(holeRect, Radius.circular(holeRadius)),
      );

    final cutOutPath = Path.combine(
      PathOperation.difference,
      screenPath,
      holePath,
    );

    final paint = Paint()..color = barrierColor;
    canvas.drawPath(cutOutPath, paint);
  }

  @override
  bool shouldRepaint(covariant _BarrierWithHolePainter oldDelegate) =>
      oldDelegate.holeRect != holeRect ||
      oldDelegate.holeRadius != holeRadius ||
      oldDelegate.barrierColor != barrierColor;
}
