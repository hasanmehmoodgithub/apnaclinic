import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';

class SurgeryBookingSearchFieldWidget extends StatelessWidget {
  const SurgeryBookingSearchFieldWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.5.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
      ),
      child: TextField(
        controller: controller,
        inputFormatters: NoEmojiTextInputFormatter.merge(null),
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search name..',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 15.h),
          suffixIcon: Icon(
            Icons.search_rounded,
            size: 18.r,
            color: const Color(0xFF5D758F),
          ),
        ),
      ),
    );
  }
}
