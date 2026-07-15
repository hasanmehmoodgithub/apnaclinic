import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../consultation/presentation/widgets/consultation_partner_logo_widget.dart';
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
              if (item.procedureSubtitle.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  item.procedureSubtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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
              clipBehavior: Clip.antiAlias,
              child: Center(
                child: ConsultationPartnerLogoWidget(
                  logoUrl: item.partnerLogoUrl,
                  width: 30.w,
                  height: 30.h,
                  fit: BoxFit.contain,
                  compact: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}