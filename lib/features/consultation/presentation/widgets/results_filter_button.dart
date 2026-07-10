import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class ResultsFilterButton extends StatelessWidget {
  const ResultsFilterButton({
    super.key,
    required this.textTheme,
    required this.label,
    this.onTap,
  });

  final TextTheme textTheme;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11.r),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9DEE4), width: 1),
            borderRadius: BorderRadius.circular(11.r),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.filter_alt_outlined,
                color: Color(0xFF96A1AE),
                size: 16,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
