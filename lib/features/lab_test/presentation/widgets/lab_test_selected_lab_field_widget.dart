import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/lab_test_vendor_entity.dart';
import 'lab_test_figma_image.dart';

/// Selected lab row with Change CTA (same layout as the city selector).
class LabTestSelectedLabFieldWidget extends StatelessWidget {
  const LabTestSelectedLabFieldWidget({
    super.key,
    required this.lab,
    required this.changeCta,
    required this.onTap,
  });

  final LabTestVendorEntity lab;
  final String changeCta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = 8.r;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: 62.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: AppColors.clrD6DCE2,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              LabTestFigmaImage(
                url: lab.logoUrl,
                width: 40,
                height: 40,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  lab.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Text(
                changeCta,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.clr667B99,
                  fontSize: 12.sp,
                  height: 1,
                ),
              ),
              SizedBox(width: 6.w),
              LabTestFigmaImage(
                url: Assets.labTestCityChevron,
                width: 8,
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
