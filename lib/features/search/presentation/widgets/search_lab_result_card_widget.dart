import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/search_entity.dart';

class SearchLabResultCardWidget extends StatelessWidget {
  const SearchLabResultCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  final SearchResultEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final feeText = (item.price ?? item.fee)?.trim() ?? '';
    final oldFee = item.oldFee?.trim() ?? '';
    final hasStrike = oldFee.isNotEmpty && oldFee != feeText;
    final labLocation = [
      if (item.subtitle.trim().isNotEmpty) item.subtitle.trim(),
      if ((item.hospital ?? '').trim().isNotEmpty &&
          item.hospital!.trim() != item.subtitle.trim())
        item.hospital!.trim(),
    ].join(' - ');
    final sampleType = (item.sampleType ?? '').trim().isEmpty
        ? 'N/A'
        : item.sampleType!.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            decoration: BoxDecoration(
              color: AppColors.clrWhite,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.clrE5E8EC),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: AppColors.clr060,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (labLocation.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    labLocation,
                    style: TextStyle(
                      color: AppColors.clr667B99,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${l10n.labTestSampleTypeLabel}: $sampleType',
                        style: TextStyle(
                          color: AppColors.clr667B99,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (hasStrike) ...[
                      Text(
                        oldFee,
                        style: TextStyle(
                          color: AppColors.clr667B99,
                          fontSize: 12.sp,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.clr667B99,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    if (feeText.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.clr0FAA9A,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          feeText,
                          style: TextStyle(
                            color: AppColors.clrWhite,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
