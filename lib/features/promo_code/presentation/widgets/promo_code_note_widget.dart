import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// API `note` shown after a promo code is applied.
class PromoCodeNoteWidget extends StatelessWidget {
  const PromoCodeNoteWidget({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final text = note.trim();
    if (text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.clr6B7280,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          height: 1.35,
        ),
      ),
    );
  }
}
