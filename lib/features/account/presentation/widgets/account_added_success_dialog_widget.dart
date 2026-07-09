import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

class AccountAddedSuccessDialogWidget extends StatelessWidget {
  const AccountAddedSuccessDialogWidget({
    super.key,
    required this.displayBankName,
    required this.accountNumber,
    required this.accountHolderName,
  });

  final String displayBankName;
  final String accountNumber;
  final String accountHolderName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(26.w, 22.h, 26.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60.r,
              height: 60.r,
              child: SvgPicture.asset(
                Assets.iconsTick,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              l10n.accountMethodAddedSuccess,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr102A56,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 1.15,
              ),
            ),
            SizedBox(height: 10.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr8A9AAE,
                  fontSize: 14.sp,
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text:
                        '${l10n.accountLinkedMessagePrefix} $displayBankName ${l10n.accountLinkedMessageMiddle} ',
                  ),
                  TextSpan(
                    text: accountNumber,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr6B7C96,
                      fontSize: 14.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' - '),
                  TextSpan(
                    text: accountHolderName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.clr6B7C96,
                      fontSize: 14.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' ${l10n.accountLinkedMessageSuffix}'),
                ],
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: l10n.accountContinueCta,
                onPressed: () => context.pop(),
                backgroundColor: AppColors.clr40AFA2,
                foregroundColor: AppColors.clrWhite,
                height: 60.h,
                borderRadius: 12.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
