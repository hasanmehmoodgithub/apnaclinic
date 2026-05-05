import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/models/surgery_details_item.dart';

class DoctorRow extends StatelessWidget {
   const DoctorRow({super.key, required this.item, required this.textTheme});

  final SurgeryDetailsItem item;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.doctor,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontSize: 15.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '${item.specialty}  |  ${item.qualification}',
          style: textTheme.bodySmall?.copyWith(
            color: const Color(0xFF667B99),
            fontSize: 12.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}