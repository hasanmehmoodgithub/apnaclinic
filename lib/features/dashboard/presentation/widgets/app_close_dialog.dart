import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

Future<bool> showAppCloseDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: AppColors.clrBlack.withValues(alpha: 0.35),
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
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.clrE8F8F5,
                  border: Border.all(color: AppColors.clrD7ECE7),
                ),
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColors.clr40AFA2,
                  size: 30.r,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                l10n.dashboardCloseAppTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr0E2D55,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                l10n.dashboardCloseAppMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr4B5563,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 28.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: TextButton(
                        onPressed: () => dialogContext.pop(false),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.clr0E2D55,
                          side: const BorderSide(
                            color: AppColors.clr9BA6A7,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          l10n.dashboardCancel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.clr0E2D55,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton.primary(
                      text: l10n.dashboardCloseAppCta,
                      onPressed: () => dialogContext.pop(true),
                      backgroundColor: AppColors.clr40AFA2,
                      foregroundColor: AppColors.clrWhite,
                      height: 50.h,
                      borderRadius: 12.r,
                      fontWeight: FontWeight.w700,
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
