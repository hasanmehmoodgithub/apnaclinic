import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// User chose to view cart or clear cart and continue a destructive selection change.
enum LabTestCartChangeDialogAction { viewCart, continueClear }

/// Warns that changing booking context will clear the cart.
class LabTestCartChangeWarningDialogWidget extends StatelessWidget {
  const LabTestCartChangeWarningDialogWidget({
    super.key,
    required this.title,
    required this.body,
    required this.viewCartLabel,
    required this.continueLabel,
  });

  final String title;
  final String body;
  final String viewCartLabel;
  final String continueLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 18.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF6FDFF),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: const BoxDecoration(
                color: Color(0xFFF8DE63),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1E2A3A),
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF2F3E54),
                fontSize: 14.sp,
                height: 1.35,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        context.pop(LabTestCartChangeDialogAction.viewCart),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2F3E54),
                      side: const BorderSide(color: Color(0xFF9FB8BF), width: 1),
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    child: Text(viewCartLabel),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        context.pop(LabTestCartChangeDialogAction.continueClear),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0FAA9A),
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    child: Text(continueLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
