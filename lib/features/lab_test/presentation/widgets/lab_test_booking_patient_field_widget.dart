import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

/// Booking row that shows Self / patient name and opens the add-patient sheet.
class LabTestBookingPatientFieldWidget extends StatelessWidget {
  const LabTestBookingPatientFieldWidget({
    super.key,
    required this.heading,
    required this.displayName,
    required this.onEditTap,
  });

  final String heading;
  final String displayName;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          heading,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          height: 56.h,
          padding: EdgeInsets.only(left: 16.w, right: 6.w),
          decoration: BoxDecoration(
            color: AppColors.clrF1F1F1,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr110844,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    height: 1.0,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEditTap,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Image.asset(
                      Assets.labTestPencil,
                      width: 20.r,
                      height: 20.r,
                      color: AppColors.clr061E40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
