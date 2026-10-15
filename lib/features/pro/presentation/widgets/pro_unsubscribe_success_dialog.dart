import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

/// Shown after ApnaClinic Pro unsubscribe succeeds.
class ProUnsubscribeSuccessDialog extends StatelessWidget {
  const ProUnsubscribeSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.proProUserLogo2,
              height: 88.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 22.h),
            Text(
              l10n.proUnsubscribeSuccessTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Satoshi',
                color: AppColors.clr102A56,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                height: 1,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.proUnsubscribeSuccessMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Satoshi',
                color: AppColors.clr6C7C92,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.5,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.clrF4F6F8,
                  foregroundColor: AppColors.clr111827,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  l10n.proUnsubscribeSuccessOk,
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    color: AppColors.clr111827,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showProUnsubscribeSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return const PopScope(
        canPop: false,
        child: ProUnsubscribeSuccessDialog(),
      );
    },
  );
}
