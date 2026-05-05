import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SearchRatingBadgeWidget extends StatelessWidget {
  const SearchRatingBadgeWidget({
    super.key,
    required this.rating,
  });

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.clrEFFBF6,
        border: Border.all(color: AppColors.clr0FAA9A),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        rating,
        style: TextStyle(
          color: AppColors.clr0FAA9A,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
