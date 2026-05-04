import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Reusable header for pharmacy flow screens (cart, checkout).
class PharmacyFlowHeaderWidget extends StatelessWidget {
  const PharmacyFlowHeaderWidget({
    super.key,
    required this.title,
    required this.onBackTap,
    this.trailingWidth = 44,
  });

  final String title;
  final VoidCallback onBackTap;
  final double trailingWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 13.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF061E40),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF061E40),
                fontSize: 31.sp / 1.6,
              ),
            ),
          ),
          SizedBox(width: trailingWidth.w),
        ],
      ),
    );
  }
}
