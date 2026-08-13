import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

Future<void> showAccountAddFailedDialog(
  BuildContext context, {
  required String message,
}) {
  final l10n = AppLocalizations.of(context)!;
  final displayMessage = message.trim().isEmpty
      ? l10n.accountAddFailedFallback
      : message.trim();

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => AccountAddFailedDialogWidget(message: displayMessage),
  );
}

class AccountAddFailedDialogWidget extends StatelessWidget {
  const AccountAddFailedDialogWidget({
    super.key,
    required this.message,
  });

  final String message;

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
                Assets.iconsWarningTriangle,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              l10n.accountAddFailedTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr102A56,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 1.15,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr8A9AAE,
                fontSize: 14.sp,
                height: 1.35,
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: l10n.commonClose,
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
