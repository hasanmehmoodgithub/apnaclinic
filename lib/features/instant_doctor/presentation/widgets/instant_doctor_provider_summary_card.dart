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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderLogo(logoUrl: provider.logoUrl),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  provider.providerName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.clr060,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
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
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: AppColors.clrF4F6F8,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.clrE4E7EB),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? Icon(
              Icons.medical_services_outlined,
              size: 20.r,
              color: AppColors.clr6C7C92,
            )
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Icon(
                Icons.medical_services_outlined,
                size: 20.r,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.clrF4F6F8,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.clr0B2239,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ),
    );
  }
}
