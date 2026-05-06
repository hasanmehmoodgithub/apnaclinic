import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_info_dialog.dart';

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
          InkWell(
            onTap: () {
              AppInfoDialog.show(
                context,
                title: 'Representative Contact',
                description:
                'A representative from our team will reach out to you '
                    'within 24 hours to confirm your appointment details and '
                    'guide you through the next steps.',
                icon: Icons.info_outline,
              );
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Icon(
                Icons.error_outline,
                size: 18.r,
                color: const Color(0xFF061E40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}