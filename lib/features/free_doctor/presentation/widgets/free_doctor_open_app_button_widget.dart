import 'package:apnaclinic/components/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class FreeDoctorOpenAppButtonWidget extends StatelessWidget {
  const FreeDoctorOpenAppButtonWidget({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(20.w, 0, 20.w, 60.h),
      child: AppButton.primary(
        text: label,
        isLoading: isLoading,
        onPressed: onPressed,
        width: double.infinity,
        height: 52.h,
        borderRadius: 14.r,
        elevation: 0,
        backgroundColor: AppColors.clr0FAA9A,
        foregroundColor: AppColors.clrWhite,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
