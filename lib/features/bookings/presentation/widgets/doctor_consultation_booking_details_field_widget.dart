import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class DoctorConsultationBookingDetailsFieldWidget extends StatelessWidget {
  const DoctorConsultationBookingDetailsFieldWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleSmall),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.clrF7F7F7,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.clr7A8798),
          ),
        ),
      ],
    );
  }
}
