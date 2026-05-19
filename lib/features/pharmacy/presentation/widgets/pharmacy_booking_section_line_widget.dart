import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class PharmacyBookingSectionLineWidget extends StatelessWidget {
  const PharmacyBookingSectionLineWidget({
    super.key,
    required this.top,
    required this.bottom,
  });

  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top.h, bottom: bottom.h),
      child: const Divider(
        height: 0.3,
        color: AppColors.clrDDE1E5,
        thickness: 0.3,
      ),
    );
  }
}
