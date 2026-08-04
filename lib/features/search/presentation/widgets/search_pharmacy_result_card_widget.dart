import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/search_entity.dart';

class SearchPharmacyResultCardWidget extends StatelessWidget {
  const SearchPharmacyResultCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  final SearchResultEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl?.trim() ?? '';
    final price = item.price?.trim() ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.clrWhite,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.clrE5E8EC),
            ),
            child: Row(
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    color: AppColors.clrE8F0F5,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  child: imageUrl.isEmpty
                      ? Icon(
                          Icons.medication_outlined,
                          size: 28.r,
                          color: AppColors.clr6B7280.withValues(alpha: 0.45),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorWidget: (context, url, error) => Icon(
                            Icons.medication_outlined,
                            size: 28.r,
                            color: AppColors.clr6B7280.withValues(alpha: 0.45),
                          ),
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.clr060,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (price.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          price,
                          style: TextStyle(
                            color: AppColors.clr060,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
