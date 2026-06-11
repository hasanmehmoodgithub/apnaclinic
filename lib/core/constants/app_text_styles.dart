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

  // Login screen
  static TextStyle loginTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.clr060,
  );

  static TextStyle loginSubtitle = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.clr98A2B3,
  );

  static TextStyle loginField = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.clrBlack,
  );

  static TextStyle loginFieldHint = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.clr667085,
  );

  static TextStyle loginPrefix = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.clr060,
  );

  static TextStyle loginCaption = TextStyle(
    fontSize: 10.sp,
    color: AppColors.clr98A2B3,
  );

  static TextStyle loginError = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.clrE01F26,
  );

  static TextStyle loginOtpTitle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.clr060,
  );

  static TextStyle loginOtpDigit = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.clr4A555F,
  );

  static TextStyle loginResend = TextStyle(
    fontSize: 12.sp,
    color: AppColors.clr5D758F,
  );

  static TextStyle loginLegal = TextStyle(
    fontSize: 10.sp,
    height: 1.65,
    color: AppColors.clr667085,
  );

  static TextStyle loginLegalLink = TextStyle(
    fontSize: 10.sp,
    height: 1.65,
    fontWeight: FontWeight.w700,
    color: AppColors.clr09,
  );
}
