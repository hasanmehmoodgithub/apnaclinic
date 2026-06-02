import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class SurgeryDoctorSummaryWidget extends StatelessWidget {
  const SurgeryDoctorSummaryWidget({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.experience,
    required this.qualifications,
    required this.hospitalName,
    required this.procedureName,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.partnerLogoUrl,
  });

  final String doctorName;
  final String speciality;
  final String experience;
  final String qualifications;
  final String hospitalName;
  final String procedureName;
  final String price;
  final String oldPrice;
  final String imageUrl;
  final String partnerLogoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 56.r,
                  height: 56.r,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFEFEFEF),
                      child: const Icon(Icons.person, color: Color(0xFFBDBDBD)),
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
                      doctorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      speciality,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '$experience  $qualifications',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 30.r,
                height: 30.r,
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
                    partnerLogoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospitalName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      procedureName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontSize: 12.sp,
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
                    price,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    oldPrice,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFB4B4B4),
                      fontSize: 11.sp,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
