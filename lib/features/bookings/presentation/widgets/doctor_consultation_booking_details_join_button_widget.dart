import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingDetailsJoinButtonWidget
    extends StatelessWidget {
  const DoctorConsultationBookingDetailsJoinButtonWidget({
    super.key,
    required this.status,
  });

  final DoctorConsultationBookingStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final canJoin = status == DoctorConsultationBookingStatus.confirmed;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: FilledButton(
        onPressed: canJoin ? () {} : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.clr1FAFA3,
          foregroundColor: AppColors.clrWhite,
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
