import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_rounded_rating_widget.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
    final fee = item.fee?.trim() ?? '';
    final oldFee = item.oldFee?.trim() ?? '';
    final hasStrike = oldFee.isNotEmpty && oldFee != fee;
    final partnerLogo = item.providerLogo?.trim() ?? '';
    final specialty = item.subtitle.trim();
    final detailLines = (item.description ?? '')
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    final ratingValue = double.tryParse(
          (item.rating ?? '').split('/').first.trim(),
        ) ??
        0;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.clrWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8ECF0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14565C67),
                  blurRadius: 8,
                  spreadRadius: 0.6,
                  offset: Offset.zero,
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
                    width: 74.w,
                    height: 84.h,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => AppShimmer(
                      width: 74.w,
                      height: 84.h,
                      borderRadius: 10.r,
                      shape: ShimmerShape.roundedRectangle,
                    ),
                    errorWidget: (context, _, _) => ColoredBox(
                      color: AppColors.clrF4F4F4,
                      child: SizedBox(
                        width: 74.w,
                        height: 84.h,
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.clr5D758F,
                          size: 30.r,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
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
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.clr060,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (ratingValue > 0)
                                      SizedBox(
                                        width: 46.w,
                                        height: 16.h,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: AppRoundedRatingWidget(
                                            rating: ratingValue,
                                            textTheme: theme,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (specialty.isNotEmpty) ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    specialty,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.clr667B99,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                                for (final line in detailLines) ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    line,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.clr667B99,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (partnerLogo.isNotEmpty) ...[
                            SizedBox(width: 4.w),
                            ConsultationPartnerLogoWidget(
                              logoUrl: partnerLogo,
                              width: 56.w,
                              height: 28.h,
                              compact: true,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.bookingsFeeLabel,
                                  style: TextStyle(
                                    color: AppColors.clr667B99,
                                    fontSize: 11.sp,
                                  ),
                                ),
                                if (fee.isNotEmpty) ...[
                                  SizedBox(height: 1.h),
                                  Text(
                                    fee,
                                    style: TextStyle(
                                      color: const Color(0xFF1A2533),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                    ),
                                  ),
                                ],
                                if (hasStrike)
                                  Text(
                                    oldFee,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF979797),
                                      fontSize: 14.sp,
                                      decoration: TextDecoration.lineThrough,
                                      height: 1,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            height: 40.h,
                            width: 114.w,
                            child: FilledButton(
                              onPressed: onTap,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.clr0FAA9A,
                                minimumSize: Size(114.w, 40.h),
                                padding: EdgeInsets.zero,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                item.primaryActionLabel ?? 'Book Now',
                                style: TextStyle(
                                  color: AppColors.clrWhite,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
