import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../constants/dashboard_ui_config.dart';

class HomeHeaderSearchField extends StatelessWidget {
  const HomeHeaderSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onSubmitted,
    this.onVoiceTap,
    this.onSearchTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = DashboardUiConfig.homeHeaderSearchHeight.h;
    final radius = height / 2;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          SizedBox(
            width: 44.w,
            child: Center(
              child: Icon(
                Icons.search_rounded,
                color: AppColors.clr52A898,
                size: 22.r,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr111827,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr6B7280,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          IconButton(
            onPressed: onVoiceTap ?? onSearchTap,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 44.w,
              minHeight: height,
            ),
            icon: SvgPicture.asset(
              Assets.svgIcSearchMic,
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                AppColors.clr09,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
