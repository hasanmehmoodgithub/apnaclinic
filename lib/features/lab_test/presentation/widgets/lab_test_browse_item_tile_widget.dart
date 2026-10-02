import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
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
    this.showLabsSummary = true,
    this.compactText = false,
  });

  final LabTestItemEntity item;
  final VoidCallback onTap;
  final String requirementLabel;
  final String sampleTypeLabel;
  final String feeFallbackText;
  final bool showLabsSummary;

  /// Text 1sp smaller. Used on select-test.
  final bool compactText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountedFee = item.discountedFee ?? feeFallbackText;
    final originalFee = item.originalFee;
    final requirement = item.requirement?.trim();
    final hasRequirement = requirement != null && requirement.isNotEmpty;
    final radius = 16.r;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.clrEDEDED, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                color: AppColors.clrF4F4F4,
                child: Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Afacad',
                    color: AppColors.clr061E40,
                    fontWeight: FontWeight.w600,
                    fontSize: (compactText ? 17 : 18).sp,
                    height: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showLabsSummary &&
                        item.labsSummary != null &&
                        item.labsSummary!.isNotEmpty) ...[
                      Text(
                        item.labsSummary!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.clr4B5668,
                          fontSize: (compactText ? 12 : 13).sp,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8.w,
                            runSpacing: 6.h,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                sampleTypeLabel,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.clr303D4F,
                                  fontSize: (compactText ? 12 : 13).sp,
                                ),
                              ),
                              LabTestInfoPillWidget(
                            value: item.sampleType,
                            fontSize: compactText ? 12.sp : null,
                          ),
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
                                originalTextStyle:
                                    theme.textTheme.bodySmall?.copyWith(
                                  fontSize: (compactText ? 11 : 12).sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                discountedTextStyle:
                                    theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: (compactText ? 11 : 12).sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (hasRequirement) ...[
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            requirementLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.clr303D4F,
                              fontSize: (compactText ? 12 : 13).sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          LabTestInfoPillWidget(
                            value: requirement,
                            highlight: true,
                            fontSize: compactText ? 12.sp : null,
                          ),
                        ],
                      ),
                    ],
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
