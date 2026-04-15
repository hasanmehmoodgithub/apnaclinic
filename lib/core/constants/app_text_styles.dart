import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static  TextStyle headline1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static  TextStyle bodyText = TextStyle(
    fontSize: 16.sp,
    color: AppColors.secondaryColor,
  );

  static  TextStyle caption = TextStyle(
    fontSize: 12.sp,
    color: AppColors.secondaryColor,
  );
}
