import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class ResultsSearchField extends StatelessWidget {
  const ResultsSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search for Doctor',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(12.r),
            child: SvgPicture.asset(
              ConsultationUiConfig.searchIconAsset,
              width: 18.w,
              height: 18.h,
            ),
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
