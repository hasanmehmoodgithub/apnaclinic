import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

/// Read-only city row for the booking flow.
class LabTestBookingCityBoxWidget extends StatelessWidget {
  const LabTestBookingCityBoxWidget({
    super.key,
    required this.city,
    required this.cityLabel,
  });

  final String city;
  final String cityLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 62.h,
      padding: EdgeInsets.fromLTRB(13.w, 14.h, 13.w, 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.32.r),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cityLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF667B99),
              fontSize: 11.sp,
              height: 1,
            ),
          ),
          Text(
            city,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
