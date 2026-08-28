import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/models/surgery_details_item.dart';

class SurgeryBookingAppointmentDetailsCardWidget extends StatelessWidget {
  const SurgeryBookingAppointmentDetailsCardWidget({
    super.key,
    required this.item,
  });

  final SurgeryDetailsItem item;

  bool get _hasScheduledDate =>
      item.appointmentDay.isNotEmpty || item.appointmentDateFull.isNotEmpty;

  String get _appliedOnDateTime {
    final value = item.appointmentTime.trim();
    if (value.isEmpty) return '';
    if (value.toLowerCase() == 'applied on') return '';
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6F7),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Appointment Details',
                  style: textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  item.appointmentSubtitle.isNotEmpty
                      ? item.appointmentSubtitle
                      : (_hasScheduledDate
                          ? 'Your appointment has been scheduled.'
                          : 'Awaiting confirmation.'),
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (!_hasScheduledDate &&
                    item.appointmentDateFull.isEmpty) ...[
                  SizedBox(height: 2.h),
                ],
                if (_hasScheduledDate &&
                    item.appointmentDay.isEmpty &&
                    item.appointmentDateFull.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    item.appointmentDateFull,
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF061E40),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_hasScheduledDate && item.appointmentDay.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: const Color(0xFFB6D2D5)),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                item.appointmentDay,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF061E40),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.appointmentMonth,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item.appointmentWeekday,
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Container(
              width: 0.8,
              height: 30.h,
              color: const Color(0xFFB6D2D5),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12.r,
                      color: const Color(0xFF061E40),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Time',
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF061E40),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  item.appointmentTime,
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              width: 0.8,
              height: 30.h,
              color: const Color(0xFFB6D2D5),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.r,
                        color: const Color(0xFF061E40),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Time',
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Applied On',
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF061E40),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_appliedOnDateTime.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      _appliedOnDateTime,
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF061E40),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
