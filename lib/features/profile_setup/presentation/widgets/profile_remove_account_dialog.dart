import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../account/domain/models/account_method.dart';

Future<bool> showProfileRemoveAccountDialog(
  BuildContext context, {
  required AccountMethod account,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.clrBlack.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      final theme = Theme.of(dialogContext);

      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        backgroundColor: AppColors.clrWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58.r,
                height: 58.r,
                decoration: const BoxDecoration(
                  color: AppColors.clrC9252C,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.clrWhite,
                  size: 30.r,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                l10n.profileRemoveAccountTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr102A56,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                l10n.profileRemoveAccountMessage(
                  account.bankName,
                  account.accountNumber,
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr6C7EA0,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56.h,
                      child: FilledButton(
                        onPressed: () => dialogContext.pop(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.clrC9252C,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          l10n.profileRemoveCta,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.clrWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SizedBox(
                      height: 56.h,
                      child: OutlinedButton(
                        onPressed: () => dialogContext.pop(false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.clrB7C0CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          l10n.profileCancelCta,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.clr4B5668,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
