import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class IssueSection extends StatelessWidget {
  const IssueSection({
    super.key,
    required this.textTheme,
    required this.controller,
  });

  final TextTheme textTheme;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Issue',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1E2D3F),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 116.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF3C4858),
              fontSize: 13.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Explain How are You Feeling..',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF727F90),
                fontSize: 13.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            ),
          ),
        ),
      ],
    );
  }
}
