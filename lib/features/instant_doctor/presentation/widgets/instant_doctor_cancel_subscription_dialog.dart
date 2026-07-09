import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

Future<bool> showInstantDoctorCancelSubscriptionDialog(
  BuildContext context,
) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      final theme = Theme.of(dialogContext);

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
                  Assets.iconsWarningTriangle,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                l10n.instantDoctorCancelSubscriptionTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr102A56,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                l10n.instantDoctorCancelSubscriptionMessage,
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
                  backgroundColor: AppColors.clr0FAA9A,
                  foregroundColor: AppColors.clrWhite,
                  height: 64.h,
                  borderRadius: 22.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  text: l10n.instantDoctorCancelSubscriptionDiscard,
                  onPressed: () => dialogContext.pop(false),
                  backgroundColor: AppColors.clrF4F6F8,
                  foregroundColor: AppColors.clr303D4F,
                  height: 64.h,
                  borderRadius: 22.r,
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
