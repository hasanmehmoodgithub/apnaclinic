import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Speech-bubble tooltip anchored above the Join Consultation button.
class DoctorConsultationJoinDisabledTooltipWidget extends StatelessWidget {
  const DoctorConsultationJoinDisabledTooltipWidget({
    super.key,
    required this.message,
    required this.anchorOffset,
    required this.anchorSize,
    required this.onDismiss,
  });

  final String message;
  final Offset anchorOffset;
  final Size anchorSize;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = 24.w;
    final bubbleMaxWidth = screenSize.width - (horizontalPadding * 2);

    var bubbleLeft = horizontalPadding;
    final anchorCenterX = anchorOffset.dx + (anchorSize.width / 2);
    var tailX = anchorCenterX - bubbleLeft - 9.w;
    final tailInset = 20.w;
    if (tailX < tailInset) tailX = tailInset;
    if (tailX > bubbleMaxWidth - tailInset - 18.w) {
      tailX = bubbleMaxWidth - tailInset - 18.w;
    }

    const tailHeight = 10.0;
    const gapAboveAnchor = 8.0;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: ColoredBox(
              color: const Color.fromRGBO(0, 0, 0, 0.28),
            ),
          ),
        ),
        Positioned(
          left: bubbleLeft,
          bottom:
              screenSize.height - anchorOffset.dy + gapAboveAnchor - tailHeight,
          width: bubbleMaxWidth,
          child: Material(
            color: Colors.transparent,
            child: _JoinDisabledTooltipBubble(
              message: message,
              tailX: tailX,
              tailHeight: tailHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _JoinDisabledTooltipBubble extends StatelessWidget {
  const _JoinDisabledTooltipBubble({
    required this.message,
    required this.tailX,
    required this.tailHeight,
  });

  final String message;
  final double tailX;
  final double tailHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPaint(
      painter: _DownwardTailPainter(
        bubbleColor: AppColors.clrWhite,
        tailOffsetFromLeft: tailX,
        tailWidth: 18.w,
        tailHeight: tailHeight,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: tailHeight),
        padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.18),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr060,
            fontSize: 14.sp,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
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
