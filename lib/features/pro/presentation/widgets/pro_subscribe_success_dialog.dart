import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'pro_brand_mark.dart';

/// Success dialog shown after ApnaClinic Pro subscription.
class ProSubscribeSuccessDialog extends StatelessWidget {
  const ProSubscribeSuccessDialog({
    super.key,
    this.title,
    this.message,
    this.onOk,
  });

  /// Optional override; defaults to l10n.
  final String? title;
  final String? message;
  final VoidCallback? onOk;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ProBrandMark(height: 72),
            SizedBox(height: 20.h),
            Text(
              title?.trim().isNotEmpty == true
                  ? title!.trim()
                  : l10n.proSubscribeSuccessTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr102A56,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                height: 1.3,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message?.trim().isNotEmpty == true
                  ? message!.trim()
                  : l10n.proSubscribeSuccessMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr6C7C92,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: l10n.proSubscribeSuccessOk,
                onPressed: () {
                  if (onOk != null) {
                    onOk!();
                  } else {
                    context.pop();
                  }
                },
                backgroundColor: AppColors.clr1FAFA3,
                foregroundColor: AppColors.clrWhite,
                height: 56.h,
                borderRadius: 16.r,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the Pro subscribe success dialog.
Future<void> showProSubscribeSuccessDialog(
  BuildContext context, {
  String? title,
  String? message,
  VoidCallback? onOk,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return PopScope(
        canPop: false,
        child: ProSubscribeSuccessDialog(
          title: title,
          message: message,
          onOk: onOk ?? () => dialogContext.pop(),
        ),
      );
    },
  );
}
