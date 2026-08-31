import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';

class InstantDoctorProviderSummaryCard extends StatelessWidget {
  const InstantDoctorProviderSummaryCard({
    super.key,
    required this.provider,
  });

  final InstantDoctorProviderEntity provider;

  static const double _logoSize = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProviderLogo(logoUrl: provider.logoUrl),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.providerName,
                        style: TextStyle(
                          color: AppColors.clr061E40,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          height: 1.2,
                        ),
                      ),
                      if (provider.product.productTitle.trim().isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          provider.product.productTitle.trim(),
                          style: TextStyle(
                            color: AppColors.clr061E40,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                      if (provider.product.priceDisplay.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          provider.product.priceDisplay,
                          style: TextStyle(
                            color: AppColors.clr43,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (provider.product.benefits.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      for (final benefit in provider.product.benefits)
                        _BenefitChip(label: benefit),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderLogo extends StatelessWidget {
  const _ProviderLogo({required this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final url = logoUrl?.trim() ?? '';
    return Container(
      width: InstantDoctorProviderSummaryCard._logoSize.r,
      height: InstantDoctorProviderSummaryCard._logoSize.r,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? Icon(
              Icons.medical_services_outlined,
              size: 24.r,
              color: AppColors.clr6C7C92,
            )
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              errorWidget: (_, _, _) => Icon(
                Icons.medical_services_outlined,
                size: 24.r,
                color: AppColors.clr6C7C92,
              ),
            ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.clrEDEDED,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.clr061E40,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ),
    );
  }
}
