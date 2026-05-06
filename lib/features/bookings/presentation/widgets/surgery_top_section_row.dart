import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../data/models/surgery_details_item.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key, required this.item, required this.textTheme});

  final SurgeryDetailsItem item;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Column(
          children: [
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
          ],
        ),
      ],
    );
  }
}