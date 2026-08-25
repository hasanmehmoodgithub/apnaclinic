import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

/// Shared E-Invoice download row used on all booking detail screens.
class BookingInvoiceTileWidget extends StatelessWidget {
  const BookingInvoiceTileWidget({
    super.key,
    required this.onDownload,
    this.fileName,
  });

  final VoidCallback onDownload;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final label = (fileName?.trim().isNotEmpty == true)
        ? fileName!.trim()
        : l10n.labTestInvoiceFileName;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.clrF7F7F7,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Image.asset(
            Assets.consultationPdfIcon,
            width: 22.w,
            height: 26.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.clr061E40,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDownload,
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              Assets.consultationEInvoiceDownload,
              width: 20.w,
              height: 20.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
