import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

Future<bool> showAiScreeningExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: AppColors.clrBlack.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      final theme = Theme.of(dialogContext);

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.clrWhite,
                AppColors.clrF3FCFB,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: const BoxDecoration(
                  color: AppColors.clrFFC233,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.priority_high_rounded,
                  color: AppColors.clrWhite,
                  size: 38.r,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                l10n.consultationAiScreeningExitTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr061E40,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                l10n.consultationAiScreeningExitMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr667B99,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      text: l10n.consultationAiScreeningExitCta,
                      onPressed: () => dialogContext.pop(true),
                      backgroundColor: AppColors.clrWhite,
                      foregroundColor: AppColors.clr0FAA9A,
                      height: 52.h,
                      borderRadius: 14.r,
                      fontWeight: FontWeight.w600,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton.primary(
                      text: l10n.consultationAiScreeningExitCancel,
                      onPressed: () => dialogContext.pop(false),
                      backgroundColor: AppColors.clr0FAA9A,
                      foregroundColor: AppColors.clrWhite,
                      height: 52.h,
                      borderRadius: 14.r,
                      fontWeight: FontWeight.w600,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
