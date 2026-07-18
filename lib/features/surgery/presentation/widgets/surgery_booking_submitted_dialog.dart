import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';

Future<void> showSurgeryBookingSubmittedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      final l10n = AppLocalizations.of(dialogContext)!;

      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 17.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: const Color(0xFF8DD57C),
                size: 60.r,
              ),
              SizedBox(height: 22.h),
              Text(
                l10n.surgeryBookingSubmittedTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.clr061E40,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  height: 1.02,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                l10n.surgeryBookingSubmittedMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.clr667B99,
                  fontSize: 16.sp,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    dialogContext.pop();
                    context.go(AppRoutes.path(AppRoutes.home));
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.clr0FAA9A,
                    minimumSize: Size.fromHeight(54.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    l10n.commonClose,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
