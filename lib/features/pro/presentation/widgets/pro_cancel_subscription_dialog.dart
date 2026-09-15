import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'pro_brand_mark.dart';

/// Confirm cancel ApnaClinic Pro subscription.
Future<bool> showProCancelSubscriptionDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      final theme = Theme.of(dialogContext);

      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        backgroundColor: AppColors.clrWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProBrandMark(height: 68),
              SizedBox(height: 18.h),
              Text(
                l10n.proCancelSubscriptionTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr102A56,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                l10n.proCancelSubscriptionMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr6C82A2,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  text: l10n.proCancelSubscriptionConfirm,
                  onPressed: () => dialogContext.pop(true),
                  backgroundColor: AppColors.clrE01F26,
                  foregroundColor: AppColors.clrWhite,
                  height: 56.h,
                  borderRadius: 16.r,
                  fontWeight: FontWeight.w700,
                  elevation: 0,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  text: l10n.proCancelSubscriptionDiscard,
                  onPressed: () => dialogContext.pop(false),
                  backgroundColor: AppColors.clrF4F6F8,
                  foregroundColor: AppColors.clr303D4F,
                  height: 56.h,
                  borderRadius: 16.r,
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
