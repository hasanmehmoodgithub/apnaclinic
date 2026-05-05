import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Primary checkout CTA for the cart screen.
class LabTestCartBottomBarWidget extends StatelessWidget {
  const LabTestCartBottomBarWidget({
    super.key,
    required this.enabled,
    required this.label,
    required this.onProceed,
  });

  final bool enabled;
  final String label;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 57.h,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  disabledBackgroundColor: const Color(0xFF9BA6A7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.909.r),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
                onPressed: enabled ? onProceed : null,
                child: Text(label),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Container(
                width: 135.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFB9C0C9),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
