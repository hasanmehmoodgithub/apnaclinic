import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SearchSectionHeaderPillWidget extends StatelessWidget {
  const SearchSectionHeaderPillWidget({
    super.key,
    required this.title,
    required this.iconAsset,
  });

  final String title;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.clrF7F7F7,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: AppColors.clrE3E3E3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconAsset,
                width: 18.r,
                height: 18.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.clr060,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.clr060,
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
