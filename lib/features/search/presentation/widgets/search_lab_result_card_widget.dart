import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/search_entity.dart';

class SearchLabResultCardWidget extends StatelessWidget {
  const SearchLabResultCardWidget({
    super.key,
    required this.item,
  });

  final SearchResultEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.clrBlack.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 118.r,
            height: 142.r,
            decoration: BoxDecoration(
              color: AppColors.clrF4F4F4,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: item.labLogo != null
                ? Image.asset(item.labLogo!, width: 72.r, fit: BoxFit.contain)
                : Icon(
                    Icons.biotech_outlined,
                    size: 44.r,
                    color: AppColors.clr5D758F,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: AppColors.clr060,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (item.providerLogo != null)
                      SizedBox(
                        width: 46.r,
                        height: 18.r,
                        child: Image.asset(item.providerLogo!, fit: BoxFit.contain),
                      ),
                  ],
                ),
                if (item.subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(color: AppColors.clr667B99, fontSize: 12.sp),
                  ),
                ],
                if ((item.description ?? '').isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      item.description!,
                      style: TextStyle(color: AppColors.clr667B99, fontSize: 12.sp),
                    ),
                  ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.labTestSampleTypeLabel,
                      style: TextStyle(color: AppColors.clr667B99, fontSize: 12.sp),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.clrE7E7E7),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        item.sampleType ?? 'Blood',
                        style: TextStyle(
                          color: AppColors.clr3D3D3D,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_box_outline_blank_rounded,
                      size: 18.r,
                      color: AppColors.clrB5B5B5,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.labTestCheckoutFeeLabel,
                            style: TextStyle(
                              color: AppColors.clr667B99,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            item.fee ?? 'Rs. 15,000/-',
                            style: TextStyle(
                              color: AppColors.clr110844,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.clrDEF8FB,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        item.providerLabel ?? 'Provided By Oladoc',
                        style: TextStyle(
                          color: AppColors.clr0590A0,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
