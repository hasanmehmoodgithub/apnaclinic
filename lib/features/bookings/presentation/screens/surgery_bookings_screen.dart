import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryBookingsScreen extends StatelessWidget {
  const SurgeryBookingsScreen({super.key});

  static const _SurgeryBookingItem _item = _SurgeryBookingItem(
    procedure: 'LAISK Eye',
    hospital: 'Al Shifa Hospital',
    doctor: 'Dr. Sumbal Shahid',
    specialty: 'Eye Surgeon',
    qualification: 'MMBS, FCPS',
    status: 'In Review',
    dateCreated: '11 Feb,2025',
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: EdgeInsets.fromLTRB(0, 20.h, 0, 8.h),
      children: [
        _SurgeryBookingCard(item: _item, textTheme: textTheme),
      ],
    );
  }
}

class _SurgeryBookingCard extends StatelessWidget {
  final _SurgeryBookingItem item;
  final TextTheme textTheme;

  const _SurgeryBookingCard({required this.item, required this.textTheme});

  @override
  Widget build(BuildContext context) {
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
            // Decorative right-side blue blob (larger and more pronounced like target)
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
                  // ─────── TOP SECTION: Bed icon + procedure/hospital + logo + chat ───────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: bed icon ABOVE procedure name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/surgerybooking.svg',
                              width: 18.r,
                              height: 18.r,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              item.procedure,
                              style: textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              item.hospital,
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                      // Right: oladoc logo + chat bubble icon
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // oladoc circular logo
                          Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x36000000),
                                width: 0.4,
                              ),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'ola',
                                      style: TextStyle(color: Color(0xFFF39A2E)),
                                    ),
                                    TextSpan(
                                      text: 'doc',
                                      style: TextStyle(color: Color(0xFF1F3A8A)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // chat bubble svg icon
                          SvgPicture.asset(
                            'assets/icons/surgerymessage.svg',
                            width: 25.r,
                            height: 25.r,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 5.h),

                  // ─────── MIDDLE SECTION: Doctor name | Specialty + qualification ───────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),

                  SizedBox(height: 8.h),
                  Container(height: 0.5, color: const Color(0xFFCBD3D9)),
                  SizedBox(height: 8.h),

                  // ─────── BOTTOM SECTION: Status | Date Created    View Details ───────
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Status column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Status:',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDEF8FB),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                item.status,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF0590A0),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Vertical divider between Status and Date Created
                        Container(
                          width: 0.5,
                          margin: EdgeInsets.symmetric(horizontal: 14.w),
                          color: const Color(0xFF9BA6A7),
                        ),

                        // Date Created column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Date Created',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              item.dateCreated,
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF667B99),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Pill-shaped View Details button
                        SizedBox(
                          height: 40.h,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(
                                color: Color(0xFF9BA6A7),
                                width: 0.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'View Details',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF061E40),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _SurgeryBookingItem {
  final String procedure;
  final String hospital;
  final String doctor;
  final String specialty;
  final String qualification;
  final String status;
  final String dateCreated;

  const _SurgeryBookingItem({
    required this.procedure,
    required this.hospital,
    required this.doctor,
    required this.specialty,
    required this.qualification,
    required this.status,
    required this.dateCreated,
  });
}
