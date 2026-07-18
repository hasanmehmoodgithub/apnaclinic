import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Primary CTA: add to cart or open cart when selection already added.
class LabTestBookingBottomBarWidget extends StatelessWidget {
  const LabTestBookingBottomBarWidget({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
    required this.showLeadingCartCount,
    required this.cartCount,
    required this.cartCountOverflowLabel,
    this.enabled = true,
  });

  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool showLeadingCartCount;
  final int cartCount;
  final String cartCountOverflowLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 8.h),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 57.h,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: enabled
                  ? const Color(0xFF0FAA9A)
                  : const Color(0xFF9BA6A7),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF9BA6A7),
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.909.r),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            onPressed: enabled ? onPressed : null,
            child: Stack(
              children: [
                Center(child: Text(buttonLabel)),
                if (showLeadingCartCount && cartCount > 0)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2F7F6),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          cartCount > 99
                              ? cartCountOverflowLabel
                              : '$cartCount',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                            color: const Color(0xFF0FAA9A),
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
