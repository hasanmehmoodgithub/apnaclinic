import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final String label;
  final Widget Function() iconBuilder;

  const PaymentOption({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    required this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: [
            iconBuilder(),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF061E40),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Custom radio
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF061E40)
                      : const Color(0xFFCBD3D9),
                  width: 1.4,
                ),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                width: 12.r,
                height: 12.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF061E40),
                  shape: BoxShape.circle,
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}