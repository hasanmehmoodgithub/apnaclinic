import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/search_entity.dart';
import 'search_outline_pill_widget.dart';
import 'search_rating_badge_widget.dart';

class SearchDoctorResultCardWidget extends StatelessWidget {
  const SearchDoctorResultCardWidget({
    super.key,
    required this.item,
    required this.showHospital,
    this.onTap,
  });

  final SearchResultEntity item;
  final bool showHospital;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final providerLogo = item.providerLogo?.trim() ?? '';
    final isNetworkLogo = providerLogo.startsWith('http');

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl ?? '',
                    width: 96.r,
                    height: 132.r,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => AppShimmer(
                      width: 96.r,
                      height: 132.r,
                      borderRadius: 10.r,
                      shape: ShimmerShape.roundedRectangle,
                    ),
                    errorWidget: (context, _, _) => ColoredBox(
                      color: AppColors.clrF4F4F4,
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.clr5D758F,
                        size: 34.r,
                      ),
                    ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.clr060,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    if (item.rating != null) ...[
                                      SizedBox(width: 6.w),
                                      SearchRatingBadgeWidget(
                                        rating: item.rating!,
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  item.subtitle,
                                  style: TextStyle(
                                    color: AppColors.clr667B99,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (providerLogo.isNotEmpty)
                            Container(
                              width: 38.r,
                              height: 38.r,
                              margin: EdgeInsets.only(left: 6.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.clrE3E3E3),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: isNetworkLogo
                                  ? CachedNetworkImage(
                                      imageUrl: providerLogo,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.asset(
                                      providerLogo,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                        ],
                      ),
                      if (item.description != null &&
                          item.description!.trim().isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          item.description!,
                          style: TextStyle(
                            color: AppColors.clr667B99,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                      SizedBox(height: 4.h),
                      if (!showHospital &&
                          ((item.date?.isNotEmpty ?? false) ||
                              (item.time?.isNotEmpty ?? false)))
                        Row(
                          children: [
                            if (item.date?.isNotEmpty ?? false)
                              SearchOutlinePillWidget(text: item.date!),
                            if ((item.date?.isNotEmpty ?? false) &&
                                (item.time?.isNotEmpty ?? false))
                              SizedBox(width: 6.w),
                            if (item.time?.isNotEmpty ?? false)
                              SearchOutlinePillWidget(text: item.time!),
                          ],
                        )
                      else if (item.hospital?.isNotEmpty ?? false)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                          child: Text(
                            item.hospital!,
                            style: TextStyle(
                              color: AppColors.clr667B99,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      SizedBox(height: 3.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .labTestCheckoutFeeLabel,
                                  style: TextStyle(
                                    color: AppColors.clr667B99,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  item.fee ?? '',
                                  style: TextStyle(
                                    color: AppColors.clr110844,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: onTap,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.clr0FAA9A,
                              minimumSize: Size(80.w, 35.h),
                              padding:
                                  EdgeInsets.symmetric(horizontal: 18.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              item.primaryActionLabel ?? 'Book Now',
                              style: TextStyle(
                                color: AppColors.clrWhite,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
