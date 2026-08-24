import 'package:flutter/material.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class PaymentPendingDialogWidget extends StatelessWidget {
  const PaymentPendingDialogWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onViewBookings,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final VoidCallback onViewBookings;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Dialog(
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
              Container(
                width: 72.r,
                height: 72.r,
                decoration: const BoxDecoration(
                  color: AppColors.clrFFF4E5,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.schedule_outlined,
                  color: AppColors.clrF5A623,
                  size: 36.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr102A56,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                message,
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
                  text: l10n.paymentPendingViewBookingsCta,
                  onPressed: onViewBookings,
                  backgroundColor: AppColors.clr0FAA9A,
                  foregroundColor: AppColors.clrWhite,
                  height: 52.h,
                  borderRadius: 12.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if ((secondaryLabel?.trim().isNotEmpty ?? false) &&
                  onSecondary != null) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.secondary(
                    text: secondaryLabel!.trim(),
                    onPressed: onSecondary,
                    backgroundColor: AppColors.clrWhite,
                    foregroundColor: AppColors.clr0FAA9A,
                    height: 52.h,
                    borderRadius: 12.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
