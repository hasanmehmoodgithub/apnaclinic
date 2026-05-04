import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Search input used by the pharmacy main panel.
class PharmacyMainSearchFieldWidget extends StatelessWidget {
  const PharmacyMainSearchFieldWidget({
    super.key,
    required this.searchQuery,
    required this.searchHint,
    required this.onSearchChanged,
  });

  final String searchQuery;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45.r,
      child: TextFormField(
        onChanged: onSearchChanged,
        initialValue: searchQuery,
        decoration: InputDecoration(
          hintText: searchHint,
          suffixIcon: const Icon(Icons.search, color: AppColors.clr9AA4B2),
          filled: true,
          fillColor: AppColors.clrWhite,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.clrE3E8EE),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.clrE3E8EE),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.clr9EC7E8),
          ),
        ),
      ),
    );
  }
}
