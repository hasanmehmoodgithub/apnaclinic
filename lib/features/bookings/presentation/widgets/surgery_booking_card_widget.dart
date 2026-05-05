import 'package:apnaclinic/features/bookings/presentation/widgets/surgery_doctor_row.dart';
import 'package:apnaclinic/features/bookings/presentation/widgets/surgery_status_date_row.dart';
import 'package:apnaclinic/features/bookings/presentation/widgets/surgery_top_section_row.dart';
import 'package:flutter/material.dart';


import '../../../../core/extensions/screen_util_extensions.dart';

import '../../data/models/surgery_details_item.dart';

class SurgeryBookingCardWidget extends StatelessWidget {
  const SurgeryBookingCardWidget({
    super.key,
    required this.item,
    required this.statusLabel,
  });

  final SurgeryDetailsItem item;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33053453),
            blurRadius: 64.2,
            offset: Offset(0, 14),
            spreadRadius: -27,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Decorative blue blob
            Positioned(
              right: -100.w,
              top: -40.h,
              child: IgnorePointer(
                child: Container(
                  width: 280.w,
                  height: 280.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDFF1F4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 9.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopSection(item: item, textTheme: textTheme),
                  SizedBox(height: 5.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 5.h),
                  DoctorRow(item: item, textTheme: textTheme),
                  SizedBox(height: 8.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 8.h),
                  StatusDateRow(
                    item: item,
                    statusLabel: statusLabel,
                    textTheme: textTheme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}