import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/pharmacy_medicine_entity.dart';

class PharmacyMedicineCard extends StatelessWidget {
  const PharmacyMedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onAddToCart,
  });

  final PharmacyMedicineEntity medicine;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: SizedBox(
                    height: 132.h,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: medicine.imageUrl,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => AppShimmer(
                        width: double.infinity,
                        height: 132.h,
                        borderRadius: 18.r,
                        shape: ShimmerShape.roundedRectangle,
                      ),
                      errorWidget: (context, url, error) {
                        return const ColoredBox(
                          color: Color(0xFFF0F4F8),
                          child: Center(
                            child: Icon(Icons.medication_rounded, color: Color(0xFF8A9AAE)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: onAddToCart,
                    icon: SvgPicture.asset(
                      Assets.iconsBasket,
                      color: const Color(0xFF061E40),
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF9BA6A7), width: 0.8),
                      minimumSize: Size(32.r, 32.r),
                      maximumSize: Size(32.r, 32.r),
                      padding:  EdgeInsets.all(8.r),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompanyLogo(companyUrl: medicine.companyUrl),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF061E40),
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Rs ${medicine.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF203A59),
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                        if (medicine.oldPrice > medicine.price)
                          Text(
                            'Rs ${medicine.oldPrice.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF7C8EA5),
                              decoration: TextDecoration.lineThrough,
                              fontSize: 10.sp,
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
          color: Colors.white,
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
