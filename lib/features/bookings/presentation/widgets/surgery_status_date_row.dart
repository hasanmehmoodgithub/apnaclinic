import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/models/surgery_details_item.dart';

class StatusDateRow extends StatelessWidget {
  const StatusDateRow({super.key,
    required this.item,
    required this.statusLabel,
    required this.textTheme,
  });

  final SurgeryDetailsItem item;
  final String statusLabel;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Status column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status:',
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDEF8FB),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statusLabel,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF0590A0),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 0.5,
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            color: const Color(0xFF9BA6A7),
          ),
          // Date column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date Created',
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                item.dateCreated,
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
