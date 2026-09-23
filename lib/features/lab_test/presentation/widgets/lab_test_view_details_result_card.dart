import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../bookings/data/models/lab_test_booking_item_model.dart';
import '../../domain/utils/lab_test_price_formatter.dart';
import 'lab_test_figma_image.dart';

class LabTestViewDetailsResultCard extends StatelessWidget {
  const LabTestViewDetailsResultCard({
    super.key,
    required this.title,
    required this.labName,
    required this.labLogoUrl,
    required this.partnerLogoUrl,
    required this.sampleType,
    required this.orderTypeLabel,
    required this.status,
    required this.discountedFee,
    required this.originalFee,
    this.onDownload,
  });

  final String title;
  final String labName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String orderTypeLabel;
  final String status;
  final String discountedFee;
  final String originalFee;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final statusKind = LabTestBookingStatusKind.fromStatus(status);
    final Color statusBg;
    final Color statusFg;
    final String statusText;
    if (statusKind == LabTestBookingStatusKind.pending) {
      statusText = l10n.bookingsStatusPending;
      statusBg = AppColors.clrFFF4E5;
      statusFg = AppColors.clrC85600;
    } else if (statusKind == LabTestBookingStatusKind.failed) {
      statusText = status;
      statusBg = AppColors.clrFBDEDE;
      statusFg = AppColors.clrBA2025;
    } else {
      statusText = l10n.bookingsStatusConfirmed;
      statusBg = AppColors.clrDEF8FB;
      statusFg = AppColors.clr15A9A0;
    }

    final sampleTags = <String>[
      if (sampleType.trim().isNotEmpty) sampleType.trim(),
      if (orderTypeLabel.trim().isNotEmpty) orderTypeLabel.trim(),
    ];

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.clrE8E8E8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: AppColors.clrF2F2F4,
              ),
              alignment: Alignment.center,
              child: LabTestFigmaImage(
                url: labLogoUrl,
                width: 90.w,
                height: 90.h,
                fit: BoxFit.contain,
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
                          Text(
                            title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.clr202B3A,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (labName.trim().isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              labName.trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.clr8A93A0,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.clrWhite,
                        border: Border.all(color: AppColors.clrE7E7E7),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 8.h,
                        ),
                        child: LabTestFigmaImage(
                          url: partnerLogoUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                if (sampleTags.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        l10n.labTestSampleTypeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.clr8A93A0,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Wrap(
                          spacing: 6.w,
                          runSpacing: 4.h,
                          children: [
                            for (final tag in sampleTags) _Tag(text: tag),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 10.h),
                _Line(),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.bookingsStatusLabel}:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.clr8A93A0,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              statusText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: statusFg,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 44.h,
                      color: AppColors.clrE8E8E8,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.labTestCheckoutFeeLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.clr8A93A0,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            discountedFee,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.clr1A2533,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          if (originalFee.trim().isNotEmpty &&
                              !LabTestPriceFormatter.isSameFee(
                                originalFee,
                                discountedFee,
                              ))
                            Text(
                              originalFee,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.clr9A9A9A,
                                fontSize: 9.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      height: 28.h,
                      child: OutlinedButton(
                        onPressed: onDownload,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: onDownload == null
                                ? AppColors.clrD0D5DD
                                : AppColors.clr9BA6A7,
                            width: 0.275.r,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(39.433.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          foregroundColor: onDownload == null
                              ? AppColors.clr6B7280
                              : AppColors.clr061E40,
                          disabledForegroundColor: AppColors.clr6B7280,
                          textStyle: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(l10n.bookingsDownloadCta),
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

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.clrE3E3E3),
        color: AppColors.clrFCFCFC,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.clr9AA1AA,
              fontSize: 10.sp,
            ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.clrEAEAEA);
  }
}
