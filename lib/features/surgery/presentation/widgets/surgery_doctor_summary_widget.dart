import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../utils/surgery_experience_label.dart';
import 'surgery_partner_logo_widget.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final experienceEducation = [
      formatSurgeryExperienceLabel(experience),
      qualifications.trim(),
    ].where((part) => part.isNotEmpty).join(' | ');
    final metaStyle = TextStyle(
      color: const Color(0xFFA6A6A6),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    );

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
                  child: imageUrl.trim().isEmpty
                      ? ColoredBox(
                          color: const Color(0xFFEFEFEF),
                          child: Icon(
                            Icons.person,
                            color: const Color(0xFFBDBDBD),
                            size: 28.r,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => const ColoredBox(
                            color: Color(0xFFEFEFEF),
                          ),
                          errorWidget: (_, _, _) => ColoredBox(
                            color: const Color(0xFFEFEFEF),
                            child: Icon(
                              Icons.person,
                              color: const Color(0xFFBDBDBD),
                              size: 28.r,
                            ),
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
                        color: AppColors.clr061E40,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (speciality.trim().isNotEmpty)
                      Text(speciality.trim(), style: metaStyle),
                    if (experienceEducation.isNotEmpty)
                      Text(experienceEducation, style: metaStyle),
                  ],
                ),
              ),
              SurgeryPartnerLogoWidget(
                logoUrl: partnerLogoUrl,
                width: 35.r,
                height: 35.r,
                compact: true,
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
                        color: AppColors.clr061E40,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      procedureName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr061E40,
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
                    l10n.surgeryStartingFrom,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF777272),
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    price,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.clr061E40,
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
