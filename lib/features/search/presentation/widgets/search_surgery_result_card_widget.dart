import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../surgery/presentation/widgets/surgery_partner_logo_widget.dart';
import '../../domain/entities/search_entity.dart';

class SearchSurgeryResultCardWidget extends StatelessWidget {
  const SearchSurgeryResultCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  final SearchResultEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fee = (item.fee ?? item.price)?.trim() ?? '';
    final surgeryType = (item.packageName ?? item.subtitle).trim();
    final hospital = (item.hospital ?? '').trim();
    final partnerLogo = item.providerLogo?.trim() ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.clrWhite,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.clrE5E8EC),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl ?? '',
                        width: 56.r,
                        height: 56.r,
                        fit: BoxFit.cover,
                        placeholder: (context, _) => AppShimmer(
                          width: 56.r,
                          height: 56.r,
                          borderRadius: 10.r,
                          shape: ShimmerShape.roundedRectangle,
                        ),
                        errorWidget: (context, _, _) => ColoredBox(
                          color: AppColors.clrF4F4F4,
                          child: SizedBox(
                            width: 56.r,
                            height: 56.r,
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.clr5D758F,
                              size: 26.r,
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
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.clr060,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (hospital.isNotEmpty) ...[
                            SizedBox(height: 3.h),
                            Text(
                              hospital,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.clr667B99,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (surgeryType.isNotEmpty) ...[
                            SizedBox(height: 3.h),
                            Text(
                              surgeryType,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.clr667B99,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (partnerLogo.isNotEmpty) ...[
                          SurgeryPartnerLogoWidget(
                            logoUrl: partnerLogo,
                            width: 48.w,
                            height: 28.h,
                            compact: true,
                          ),
                          if (fee.isNotEmpty) SizedBox(height: 8.h),
                        ],
                        if (fee.isNotEmpty) ...[
                          Text(
                            l10n.surgeryStartingFrom,
                            style: TextStyle(
                              color: AppColors.clr667B99,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            fee,
                            style: TextStyle(
                              color: AppColors.clr060,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  height: 44.h,
                  child: FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.clr0FAA9A,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      item.primaryActionLabel ?? 'Book Now',
                      style: TextStyle(
                        color: AppColors.clrWhite,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
