import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../instant_doctor/presentation/instant_doctor_consultation_args.dart';

class DoctorConsultationBookingDetailsJoinButtonWidget
    extends StatefulWidget {
  const DoctorConsultationBookingDetailsJoinButtonWidget({
    super.key,
    required this.enabled,
    required this.meetingLink,
    this.title = '',
  });

  final bool enabled;
  final String meetingLink;
  final String title;

  @override
  State<DoctorConsultationBookingDetailsJoinButtonWidget> createState() =>
      _DoctorConsultationBookingDetailsJoinButtonWidgetState();
}

class _DoctorConsultationBookingDetailsJoinButtonWidgetState
    extends State<DoctorConsultationBookingDetailsJoinButtonWidget> {
  bool _showTooltip = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _showDisabledTooltip() {
    _hideTimer?.cancel();
    setState(() => _showTooltip = true);
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _showTooltip = false);
    });
  }

  void _joinConsultation(BuildContext context, AppLocalizations l10n) {
    context.pushNamed(
      AppRoutes.instantDoctorConsultation,
      extra: InstantDoctorConsultationArgs(
        url: widget.meetingLink.trim(),
        title: widget.title.trim().isNotEmpty
            ? widget.title.trim()
            : l10n.bookingsJoinConsultationCta,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final canJoin =
        widget.enabled && widget.meetingLink.trim().isNotEmpty;

    return Column(
      children: [
        if (_showTooltip && !canJoin) ...[
          _JoinDisabledTooltipBubble(
            message: l10n.bookingsJoinConsultationDisabledTooltip,
          ),
          SizedBox(height: 10.h),
        ],
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: FilledButton(
            onPressed: canJoin
                ? () => _joinConsultation(context, l10n)
                : _showDisabledTooltip,
            style: FilledButton.styleFrom(
              backgroundColor:
                  canJoin ? AppColors.clr1FAFA3 : const Color(0xFFB7D9D6),
              foregroundColor: AppColors.clrWhite,
              disabledBackgroundColor: const Color(0xFFB7D9D6),
              disabledForegroundColor: AppColors.clrWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              l10n.bookingsJoinConsultationCta,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.clrWhite,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _JoinDisabledTooltipBubble extends StatelessWidget {
  const _JoinDisabledTooltipBubble({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.clrE4E7EB),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr102A56,
              fontSize: 13.sp,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomPaint(
          size: Size(16.w, 8.h),
          painter: _TooltipTailPainter(color: AppColors.clrWhite),
        ),
      ],
    );
  }
}

class _TooltipTailPainter extends CustomPainter {
  _TooltipTailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _TooltipTailPainter oldDelegate) =>
      oldDelegate.color != color;
}
