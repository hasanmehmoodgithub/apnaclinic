import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'surgery_booking_doctor_card_data.dart';

class SurgeryBookingDoctorCardWidget extends StatelessWidget {
  const SurgeryBookingDoctorCardWidget({
    super.key,
    required this.data,
    required this.onBookNowTap,
  });

  final SurgeryBookingDoctorCardData data;
  final VoidCallback onBookNowTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(8, 97, 156, 0.2),
            blurRadius: 59,
            offset: Offset(0, 18),
            spreadRadius: -27,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7.8.r),
                child: Container(
                  width: 59.h,
                  height: 59.h,
                  color: const Color(0xFFF4F4F4),
                  child: Image.network(
                    data.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.person_rounded,
                          size: 28.r,
                          color: const Color(0xFFB1B1B1),
                        ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.doctorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      data.speciality,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '${data.experience}  ${data.qualifications}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 35.r,
                height: 35.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.21),
                    width: 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipOval(
                  child: Image.network(
                    data.partnerLogoUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF7F7F7)),
                bottom: BorderSide(color: Color(0xFFF7F7F7)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.hospitalName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        data.procedureName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 11.sp,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Stating from',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF777272),
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      data.price,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      data.oldPrice,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF979797),
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onBookNowTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0FAA9A),
                minimumSize: Size.fromHeight(30.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.5.r),
                ),
              ),
              child: Text(
                'Book Now',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
