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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final link = meetingLink.trim();
    final canJoin = enabled && link.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: FilledButton(
        onPressed: canJoin
            ? () => context.pushNamed(
                  AppRoutes.instantDoctorConsultation,
                  extra: InstantDoctorConsultationArgs(
                    url: link,
                    title: title.trim().isNotEmpty
                        ? title.trim()
                        : l10n.bookingsJoinNowCta,
                  ),
                )
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.clr1FAFA3,
          foregroundColor: AppColors.clrWhite,
          disabledBackgroundColor: const Color(0xFFB7D9D6),
          disabledForegroundColor: AppColors.clrWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(
          l10n.bookingsJoinNowCta,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.clrWhite,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
