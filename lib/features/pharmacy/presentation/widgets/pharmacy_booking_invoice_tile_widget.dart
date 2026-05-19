import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class PharmacyBookingInvoiceTileWidget extends StatelessWidget {
  const PharmacyBookingInvoiceTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.clrF7F7F7,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              color: AppColors.clrFFE9C3,
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'PDF',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.clrC9252C,
                fontWeight: FontWeight.w700,
                fontSize: 8.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              l10n.pharmacyBookingInvoiceFileName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.clr024886,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
          Icon(
            Icons.download_rounded,
            color: AppColors.clr4A555F,
            size: 18.r,
          ),
        ],
      ),
    );
  }
}
