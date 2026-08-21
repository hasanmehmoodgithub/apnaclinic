import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../instant_doctor/presentation/instant_doctor_consultation_args.dart';
import 'doctor_consultation_join_disabled_tooltip_widget.dart';

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
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _tooltipEntry;
  Timer? _autoDismissTimer;

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _removeTooltip();
    super.dispose();
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

  void _removeTooltip() {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
    _tooltipEntry?.remove();
    _tooltipEntry = null;
  }

  void _showDisabledTooltip(AppLocalizations l10n) {
    _removeTooltip();

    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;

    final overlay = Overlay.of(context, rootOverlay: true);
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _tooltipEntry = OverlayEntry(
      builder: (_) => DoctorConsultationJoinDisabledTooltipWidget(
        message: l10n.bookingsJoinConsultationDisabledTooltip,
        anchorOffset: offset,
        anchorSize: size,
        onDismiss: _removeTooltip,
      ),
    );
    overlay.insert(_tooltipEntry!);

    _autoDismissTimer = Timer(const Duration(seconds: 4), _removeTooltip);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final canJoin = widget.enabled && widget.meetingLink.trim().isNotEmpty;
    final labelColor = canJoin
        ? AppColors.clrWhite
        : AppColors.clrWhite.withValues(alpha: 0.35);

    return SizedBox(
      key: _buttonKey,
      width: double.infinity,
      height: 56.h,
      child: FilledButton(
        onPressed: canJoin
            ? () => _joinConsultation(context, l10n)
            : () => _showDisabledTooltip(l10n),
        style: FilledButton.styleFrom(
          backgroundColor:
              canJoin ? AppColors.clr1FAFA3 : AppColors.clrB7D9D6,
          foregroundColor: labelColor,
          disabledBackgroundColor: AppColors.clrB7D9D6,
          disabledForegroundColor: AppColors.clrWhite.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(
          l10n.bookingsJoinConsultationCta,
          style: textTheme.titleMedium?.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
