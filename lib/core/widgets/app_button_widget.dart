import 'package:flutter/material.dart';

import '../extensions/screen_util_extensions.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    super.key,
    required this.title,
    this.bgClr = const Color(0xFF1FAFA3),
    required this.onTap,
  });

  final String title;
  final Color bgClr;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: bgClr,
        minimumSize: Size.fromHeight(62.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
      ),
    );
  }
}
