import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';
import 'pharmacy_requires_prescription_badge.dart';

class PharmacySelectedCard extends StatelessWidget {
  const PharmacySelectedCard({
    super.key,
    required this.featured,
    required this.onAddToCart,
  });

  final PharmacyMedicineEntity featured;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 260.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26.r),
                color: AppColors.clrE6EDF1,
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: featured.imageUrl,
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) => AppShimmer(
                  width: double.infinity,
                  height: 260.h,
                  borderRadius: 26.r,
                  shape: ShimmerShape.roundedRectangle,
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    color: AppColors.clrE9EEF3,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.medication_rounded,
                      size: 52,
                      color: AppColors.clr8091A8,
                    ),
                  );
                },
              ),
            ),
            if (featured.prescriptionRequired)
              Positioned(
                left: 0,
                top: 0,
                child: const PharmacyRequiresPrescriptionBadge(),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompanyLogo(companyUrl: featured.companyUrl),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          featured.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.clr060,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                              ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${l10n.pharmacyCurrencyPrefix}${featured.price.toStringAsFixed(0)} /-',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.clr4D5A70,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: onAddToCart,
              icon: SvgPicture.asset(
                Assets.iconsBasket,
                width: 15.r,
                height: 15.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.clr667B99,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(l10n.pharmacyAddToCartLower),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.clr9BA6A7, width: 0.8),
                foregroundColor: AppColors.clr060,
                minimumSize: Size(0, 20.r),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          featured.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.clr4A4A4A,
            height: 1.2,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo({required this.companyUrl});

  final String companyUrl;

  @override
  Widget build(BuildContext context) {
    if (companyUrl.isEmpty || !companyUrl.startsWith('data:image')) {
      return const SizedBox.shrink();
    }

    final commaIndex = companyUrl.indexOf(',');
    if (commaIndex == -1 || commaIndex + 1 >= companyUrl.length) {
      return const SizedBox.shrink();
    }

    try {
      final bytes = base64Decode(companyUrl.substring(commaIndex + 1));
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.memory(bytes, fit: BoxFit.contain),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}
