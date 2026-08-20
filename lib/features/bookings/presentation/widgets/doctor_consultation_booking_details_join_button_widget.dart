import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../instant_doctor/presentation/instant_doctor_consultation_args.dart';

class DoctorConsultationBookingDetailsJoinButtonWidget
    extends StatelessWidget {
  const DoctorConsultationBookingDetailsJoinButtonWidget({
    super.key,
    required this.enabled,
    required this.meetingLink,
    this.title = '',
  });

  final bool enabled;
  final String meetingLink;
  final String title;

  void _joinConsultation(BuildContext context, AppLocalizations l10n) {
    context.pushNamed(
      AppRoutes.instantDoctorConsultation,
      extra: InstantDoctorConsultationArgs(
        url: meetingLink.trim(),
        title: title.trim().isNotEmpty
            ? title.trim()
            : l10n.bookingsJoinConsultationCta,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final canJoin = enabled && meetingLink.trim().isNotEmpty;
    final labelColor = canJoin
        ? AppColors.clrWhite
        : AppColors.clrWhite.withValues(alpha: 0.35);

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: FilledButton(
        onPressed: canJoin ? () => _joinConsultation(context, l10n) : null,
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
