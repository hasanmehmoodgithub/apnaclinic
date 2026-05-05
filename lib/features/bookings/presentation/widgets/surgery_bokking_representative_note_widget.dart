import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryBookingRepresentativeNoteWidget extends StatelessWidget {
  const SurgeryBookingRepresentativeNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF1E2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Our representative will contact you in 24 hours.',
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Icon(
            Icons.error_outline,
            size: 18.r,
            color: const Color(0xFF061E40),
          ),
        ],
      ),
    );
  }
}