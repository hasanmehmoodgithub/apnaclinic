import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class PatientSection extends StatelessWidget {
  const PatientSection({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1E2D3F),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(0),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            'Self',
            style: textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF3C4858),
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
