import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class ResultsRatingBadge extends StatelessWidget {
  const ResultsRatingBadge({
    super.key,
    required this.textTheme,
    required this.rating,
  });

  final TextTheme textTheme;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBEF),
        borderRadius: BorderRadius.circular(3.r),
        border: Border.all(color: const Color(0xFFDAEFCF), width: 1),
      ),
      child: Text(
        rating,
        style: textTheme.bodySmall?.copyWith(
          color: const Color(0xFF87B074),
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}
