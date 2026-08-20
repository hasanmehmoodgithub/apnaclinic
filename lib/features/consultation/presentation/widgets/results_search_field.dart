import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class ResultsSearchField extends StatelessWidget {
  const ResultsSearchField({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    this.showClear = false,
  });

  final TextEditingController controller;

  /// Runs doctor search with the current field text (search icon / keyboard).
  final VoidCallback onSearch;

  /// Clears the active search and reloads the full doctor list.
  final VoidCallback onClear;

  /// Show clear (X) after search results are active.
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: 'Search for Doctor',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: showClear ? 84.w : 48.w,
            minHeight: 48.h,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showClear)
                IconButton(
                  onPressed: onClear,
                  tooltip: 'Clear search',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: 36.w,
                    height: 36.h,
                  ),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20.r,
                    color: const Color(0xFF667B99),
                  ),
                ),
              IconButton(
                onPressed: onSearch,
                tooltip: 'Search',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: 40.w,
                  height: 40.h,
                ),
                icon: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(
                    ConsultationUiConfig.searchIconAsset,
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD9DEE4), width: 1),
            borderRadius: BorderRadius.circular(11.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD9DEE4), width: 1),
            borderRadius: BorderRadius.circular(11.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ConsultationUiConfig.ctaColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(11.r),
          ),
        ),
      ),
    );
  }
}
