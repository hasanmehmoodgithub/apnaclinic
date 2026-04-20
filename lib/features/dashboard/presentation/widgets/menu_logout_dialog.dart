import 'package:apnaclinic/components/widgets/app_button.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

Future<bool> showMenuLogoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          constraints: BoxConstraints(minHeight: 280.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8F8F5),
                  border: Border.all(color: const Color(0xFFD7ECE7)),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xFF40AFA2),
                  size: 30.r,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Logout',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF0E2D55),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4B5563),
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
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0E2D55),
                          side: const BorderSide(
                            color: Color(0xFF9BA6A7),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0E2D55),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton.primary(
                      text: 'Logout',
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      backgroundColor: const Color(0xFF40AFA2),
                      foregroundColor: Colors.white,
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
