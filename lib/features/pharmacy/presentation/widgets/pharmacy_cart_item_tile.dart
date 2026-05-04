import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 108.r,
          height: 88.r,
          decoration: BoxDecoration(
            color: AppColors.clrECECEC,
            borderRadius: BorderRadius.circular(22.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: item.medicine.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => AppShimmer(
              width: 130.r,
              height: 88.r,
              borderRadius: 22.r,
              shape: ShimmerShape.roundedRectangle,
            ),
            errorWidget: (context, url, error) => const ColoredBox(
              color: AppColors.clrE9EEF3,
              child: Center(
                child: Icon(
                  Icons.medication_rounded,
                  color: AppColors.clr8091A8,
                ),
              ),
            ),
          ),
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
                    color: AppColors.clr060,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
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
                      itemSpacing: 18.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: '${item.quantity}x ',
                                  style: const TextStyle(
                                    color: AppColors.clr667B99,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${l10n.pharmacyCurrencyPrefix}${item.medicine.price.toStringAsFixed(0)}/-',
                                  style: const TextStyle(
                                    color: AppColors.clr060,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
