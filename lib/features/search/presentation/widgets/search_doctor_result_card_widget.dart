import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../consultation/presentation/widgets/consultation_partner_logo_widget.dart';
import '../../domain/entities/search_entity.dart';

class SearchDoctorResultCardWidget extends StatelessWidget {
  const SearchDoctorResultCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  final SearchResultEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fee = item.fee?.trim() ?? '';
    final oldFee = item.oldFee?.trim() ?? '';
    final hasStrike = oldFee.isNotEmpty && oldFee != fee;
    final partnerLogo = item.providerLogo?.trim() ?? '';
    final detailLines = <String>[
      if (item.subtitle.trim().isNotEmpty) item.subtitle.trim(),
      if ((item.description ?? '').trim().isNotEmpty) item.description!.trim(),
      if ((item.hospital ?? '').trim().isNotEmpty) item.hospital!.trim(),
    ];

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl ?? '',
                    width: 72.r,
                    height: 72.r,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => AppShimmer(
                      width: 72.r,
                      height: 72.r,
                      borderRadius: 10.r,
                      shape: ShimmerShape.roundedRectangle,
                    ),
                    errorWidget: (context, _, _) => ColoredBox(
                      color: AppColors.clrF4F4F4,
                      child: SizedBox(
                        width: 72.r,
                        height: 72.r,
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.clr5D758F,
                          size: 30.r,
                        ),
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
                          if (partnerLogo.isNotEmpty) ...[
                            SizedBox(width: 8.w),
                            ConsultationPartnerLogoWidget(
                              logoUrl: partnerLogo,
                              width: 56.w,
                              height: 28.h,
                              compact: true,
                            ),
                          ],
                        ],
                      ),
                      for (final line in detailLines) ...[
                        SizedBox(height: 2.h),
                        Text(
                          line,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.clr667B99,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ],
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6.w,
                              children: [
                                if (hasStrike)
                                  Text(
                                    oldFee,
                                    style: TextStyle(
                                      color: AppColors.clr667B99,
                                      fontSize: 12.sp,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.clr667B99,
                                    ),
                                  ),
                                if (fee.isNotEmpty)
                                  Text(
                                    fee,
                                    style: TextStyle(
                                      color: AppColors.clr060,
                                      fontSize: 14.sp,
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
                              minimumSize: Size(88.w, 34.h),
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              item.primaryActionLabel ?? 'Book Now',
                              style: TextStyle(
                                color: AppColors.clrWhite,
                                fontSize: 13.sp,
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
