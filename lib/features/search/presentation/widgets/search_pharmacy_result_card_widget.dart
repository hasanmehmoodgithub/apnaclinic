import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/search_entity.dart';

class SearchPharmacyResultCardWidget extends StatelessWidget {
  const SearchPharmacyResultCardWidget({
    super.key,
    required this.item,
  });

  final SearchResultEntity item;

  static const String _pharmacyImageUrl =
      'https://bio-labs.net/wp-content/uploads/2022/10/12-Bio-Col-Tabs.webp';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: 128.r,
            height: 90.r,
            decoration: BoxDecoration(
              color: AppColors.clrE8F0F5,
              borderRadius: BorderRadius.circular(12.r),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: _pharmacyImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.clr060),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                Assets.servicesPharmacy,
                fit: BoxFit.contain,
              ),
              fadeInDuration: const Duration(milliseconds: 300),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: AppColors.clr060,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.price ?? item.subtitle,
                  style: TextStyle(
                    color: AppColors.clr060,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
