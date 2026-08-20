import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../extensions/screen_util_extensions.dart';
import '../../../utils/no_emoji_text_input_formatter.dart';

/// Search field used inside the shared Select City dialog.
class SelectCitySearchFieldWidget extends StatelessWidget {
  const SelectCitySearchFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: AppColors.clr9AAABD, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              inputFormatters: NoEmojiTextInputFormatter.merge(null),
              onChanged: onChanged,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr060,
                fontSize: 12.sp,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr5D758F,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          Icon(
            Icons.search_rounded,
            color: AppColors.clr9AAABD,
            size: 18.r,
          ),
        ],
      ),
    );
  }
}
