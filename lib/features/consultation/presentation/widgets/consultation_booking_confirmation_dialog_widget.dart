import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

class ConsultationBookingConfirmationDialogWidget extends StatelessWidget {
  const ConsultationBookingConfirmationDialogWidget({
    super.key,
    required this.doctorName,
    required this.onViewBookings,
  });

  final String doctorName;
  final VoidCallback onViewBookings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w),
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 64.r,
              height: 64.r,
              child: SvgPicture.asset(
                Assets.labTestBookingConfirmationGreenCheck,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.consultationBookingConfirmedTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr102A56,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.consultationBookingConfirmedMessage(doctorName),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr6C7C92,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: l10n.consultationViewBookingsCta,
                onPressed: onViewBookings,
                backgroundColor: AppColors.clr0FAA9A,
                foregroundColor: AppColors.clrWhite,
                height: 52.h,
                borderRadius: 12.r,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
