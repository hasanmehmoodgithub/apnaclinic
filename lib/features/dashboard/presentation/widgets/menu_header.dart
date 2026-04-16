import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(6.w, 6.h, 16.w, 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF08294D),
            ),
          ),
          Expanded(
            child: Text(
              'Menu',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0E2D55),
                fontWeight: FontWeight.w700,
                fontSize: (32 / 1.6).sp,
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}
