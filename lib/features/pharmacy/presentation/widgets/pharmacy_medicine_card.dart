import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        padding: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22.r),
                  child: SizedBox(
                    height: 142.h,
                    width: double.infinity,
                    child: Image.network(
                      medicine.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 4.w,
                  top: 6.h,
                  child: InkWell(
                    onTap: onAddToCart,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF9BA6A7),
                          width: 0.8,
                        ),
                      ),
                      child: SvgPicture.asset(
                        Assets.iconsBasket,
                        width: 15.r,
                        height: 15.r,
                        color: const Color(0xFF667B99),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Assets.iconsMedicine,
                  width: 22.r,
                  height: 22.r,
                ),
                SizedBox(width: 4.w),
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
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Rs ${medicine.price.toStringAsFixed(0)} /-',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF5D758F),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        'Rs ${medicine.oldPrice.toStringAsFixed(0)} /-',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF5D758F),
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
