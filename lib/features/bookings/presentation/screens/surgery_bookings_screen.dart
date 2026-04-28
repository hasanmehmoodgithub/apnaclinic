import 'package:flutter/material.dart';
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
        borderRadius: BorderRadius.circular(14.r),
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
        borderRadius: BorderRadius.circular(14.r),
        child: Stack(
          children: [
            // Decorative right-side background vector, matched to Figma card.
            Positioned(
              right: -84.w,
              top: -16.h,
              child: IgnorePointer(
                child: Container(
                  width: 232.w,
                  height: 232.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDFF1F4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 14.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.airline_seat_flat_rounded,
                size: 20.r,
                color: const Color(0xFF5D758F),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.procedure,
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6.h),
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
              SizedBox(
                width: 30.w,
                height: 30.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0x36000000),
                      width: 0.214,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'olx',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF39A2E),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(height: 0.3.h, color: const Color(0xFF9BA6A7)),
          SizedBox(height: 9.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.doctor,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                '${item.specialty}  | ${item.qualification}',
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF333333),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          Container(height: 0.3.h, color: const Color(0xFF9BA6A7)),
          SizedBox(height: 9.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status:',
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEF8FB),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Text(
                      item.status,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF0590A0),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 22.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Created',
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.dateCreated,
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 86.w,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF9BA6A7), width: 0.275),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(39.433.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    minimumSize: Size(86.w, 30.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View Details',
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF061E40),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
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
