import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

Future<bool> showInstantDoctorCancelSubscriptionDialog(
  BuildContext context, {
  required String providerName,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      final theme = Theme.of(dialogContext);

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(18.r),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.clrFCE9F0,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.clrE01F26,
                  size: 30.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                l10n.instantDoctorCancelSubscriptionTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr102A56,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                l10n.instantDoctorCancelSubscriptionMessage(providerName),
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
                  text: l10n.instantDoctorCancelSubscriptionConfirm,
                  onPressed: () => dialogContext.pop(true),
                  backgroundColor: AppColors.clrE01F26,
                  foregroundColor: AppColors.clrWhite,
                  height: 60.h,
                  borderRadius: 20.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  text: l10n.instantDoctorClose,
                  onPressed: () => dialogContext.pop(false),
                  backgroundColor: AppColors.clrF4F6F8,
                  foregroundColor: AppColors.clr303D4F,
                  height: 60.h,
                  borderRadius: 20.r,
                  fontWeight: FontWeight.w600,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
