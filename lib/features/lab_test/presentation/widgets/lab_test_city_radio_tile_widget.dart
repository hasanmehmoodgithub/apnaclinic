import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Single city row with trailing radio indicator for the lab test city dialog.
class LabTestCityRadioTileWidget extends StatelessWidget {
  const LabTestCityRadioTileWidget({
    super.key,
    required this.city,
    required this.selected,
    required this.onTap,
  });

  final String city;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected ? AppColors.clrF2F2F2 : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                city,
                style: TextStyle(
                  color: AppColors.clr060,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _RadioCircle(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.clr060 : AppColors.clrBFCAD6,
          width: 1.2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10.r,
                height: 10.r,
                decoration: const BoxDecoration(
                  color: AppColors.clr060,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
