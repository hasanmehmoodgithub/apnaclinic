import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import 'pharmacy_quantity_stepper.dart';

class PharmacyCartItemTile extends StatelessWidget {
  const PharmacyCartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
  });

  final PharmacyCartItemEntity item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130.r,
          height: 88.r,
          decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(22.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(item.medicine.imageUrl, fit: BoxFit.cover),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.medicine.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 9.h),
                Row(
                  children: [
                    PharmacyQuantityStepper(
                      quantity: item.quantity,
                      onAdd: onIncrease,
                      onRemove: onDecrease,
                      showBasketIcon: true,
                    ),
                    const Spacer(),
                    Text(
                      '${item.quantity}x Rs ${item.medicine.price.toStringAsFixed(0)}/-',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w500,
                        fontSize: 30.sp / 1.6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
