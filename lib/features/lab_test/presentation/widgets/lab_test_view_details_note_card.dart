import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class LabTestViewDetailsNoteCard extends StatelessWidget {
  const LabTestViewDetailsNoteCard({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              note,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF1F2A38),
                fontSize: 12.sp,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 15.r,
            height: 15.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6F7784), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6F7784),
                fontWeight: FontWeight.w900,
                fontSize: 9.sp,
                height: 1,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
