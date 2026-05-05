import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Cart screen app bar: back + centered title.
class LabTestCartHeaderWidget extends StatelessWidget {
  const LabTestCartHeaderWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 18.h),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: () => context.pop(),
              child: SizedBox(
                width: 40.r,
                height: 40.r,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: const Color(0xFF061E40),
                  size: 24.r,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }
}
