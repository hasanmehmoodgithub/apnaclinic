import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/lab_test_cart_item.dart';
import 'lab_test_info_pill_widget.dart';
import 'lab_test_price_pill.dart';

/// One cart row: title, lab, sample type, price, remove.
class LabTestCartItemTileWidget extends StatelessWidget {
  const LabTestCartItemTileWidget({
    super.key,
    required this.item,
    required this.sampleTypeLabel,
    required this.onRemove,
  });

  final LabTestCartItem item;
  final String sampleTypeLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEDE4E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 10.w, 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.testTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF0F0F0),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.close,
                      size: 14.r,
                      color: const Color(0xFF8D8D8D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.labDisplayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4B5B72),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Divider(height: 1, color: const Color(0xFFE4E7EC)),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      sampleTypeLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF2F3E54),
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    LabTestInfoPillWidget(value: item.sampleType),
                    const Spacer(),
                    LabTestPricePill(
                      originalFee: item.originalFee,
                      discountedFee: item.discountedFee,
                      originalPadding: EdgeInsets.fromLTRB(12.w, 7.h, 12.w, 7.h),
                      discountedPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      originalTextStyle: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      discountedTextStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
