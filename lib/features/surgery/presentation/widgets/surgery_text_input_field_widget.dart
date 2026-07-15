import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryTextInputFieldWidget extends StatelessWidget {
  const SurgeryTextInputFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.keyboardType,
    this.hintText,
    this.hasError = false,
    this.errorText,
    this.inputFormatters,
    this.maxLength,
  });

  final String title;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool hasError;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? effectiveHint = hasError ? errorText : hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF061E40),
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 40.h,
          padding: EdgeInsets.only(left: 12.w, right: 8.w),
          decoration: BoxDecoration(
            color: hasError ? const Color(0xFFFFF8F8) : const Color(0xFFF1F1F1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border(
              bottom: BorderSide(
                color: hasError ? const Color(0xFF852221) : Colors.transparent,
                width: 0.6,
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: hasError ? const Color(0xFFBA2025) : const Color(0xFF4A555F),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              hintText: effectiveHint,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: hasError ? const Color(0xFFBA2025) : const Color(0xFFB6BDC8),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
