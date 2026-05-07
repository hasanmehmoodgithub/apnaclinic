import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class PharmacyBookingMedicineCardWidget extends StatelessWidget {
  const PharmacyBookingMedicineCardWidget({super.key});

  static const String _demoMedicineImage =
      'https://www.figma.com/api/mcp/asset/3909d803-17a5-457b-b419-b32bdab07adf';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 91.h,
      child: Row(
        children: [
          Container(
            width: 130.w,
            height: 91.h,
            decoration: BoxDecoration(
              color: AppColors.clrF9F9F9,
              borderRadius: BorderRadius.circular(8.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: _demoMedicineImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => AppShimmer(
                width: 130.w,
                height: 91.h,
                borderRadius: 8.r,
                shape: ShimmerShape.roundedRectangle,
              ),
              errorWidget: (context, url, error) => const ColoredBox(
                color: AppColors.clrE9EEF3,
                child: Center(
                  child: Icon(
                    Icons.medication_rounded,
                    color: AppColors.clr8091A8,
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
                  l10n.pharmacyBookingMedicineName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.clr060,
                    fontSize: 16.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: '${l10n.pharmacyBookingMedicineQty}x ',
                        style: const TextStyle(color: AppColors.clr667B99),
                      ),
                      TextSpan(
                        text: '${l10n.pharmacyCurrencyPrefix}1900/-',
                        style: const TextStyle(color: AppColors.clr060),
                      ),
                    ],
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
