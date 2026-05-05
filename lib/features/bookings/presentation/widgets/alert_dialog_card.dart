
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

enum AlertKind { error, success }

class AlertDialogCard extends StatelessWidget {
  final AlertKind kind;
  final String title;
  final String message;
  const AlertDialogCard({
    required this.kind,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = kind == AlertKind.success;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: isSuccess
                    ? const Color(0xFF1FB877)
                    : const Color(0xFFFFC233),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isSuccess ? Icons.check : Icons.priority_high_rounded,
                color: Colors.white,
                size: 38.r,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF667B99),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1AB6A1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Close',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
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