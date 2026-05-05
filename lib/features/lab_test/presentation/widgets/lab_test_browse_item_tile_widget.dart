import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import 'lab_test_info_pill_widget.dart';
import 'lab_test_price_pill.dart';

/// Single lab test row in the browse catalog list.
class LabTestBrowseItemTileWidget extends StatelessWidget {
  const LabTestBrowseItemTileWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.requirementLabel,
    required this.sampleTypeLabel,
    required this.feeFallbackText,
  });

  final LabTestItemEntity item;
  final VoidCallback onTap;
  final String requirementLabel;
  final String sampleTypeLabel;
  final String feeFallbackText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountedFee = item.discountedFee ?? feeFallbackText;
    final originalFee = item.originalFee;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFEDE4E4), width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 13.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                ),
                child: Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Afacad',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14.r),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 13.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.labsSummary ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4B5B72),
                        fontSize: 13.sp,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (item.requirement != null && item.requirement!.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            requirementLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF2F3E54),
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          LabTestInfoPillWidget(
                            value: item.requirement!,
                            highlight: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                sampleTypeLabel,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF2F3E54),
                                  fontSize: 13.sp,
                                ),
                              ),
                              LabTestInfoPillWidget(value: item.sampleType),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: LabTestPricePill(
                                originalFee: originalFee,
                                discountedFee: discountedFee,
                                originalTextStyle: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                discountedTextStyle:
                                    theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }
}
