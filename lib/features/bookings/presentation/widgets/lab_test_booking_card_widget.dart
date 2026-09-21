import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../lab_test/domain/utils/lab_test_media_url_resolver.dart';
import '../../../lab_test/presentation/lab_test_route_args.dart';
import '../../../lab_test/presentation/widgets/lab_test_figma_image.dart';
import '../../data/models/lab_test_booking_item_model.dart';

class LabTestBookingCardWidget extends StatelessWidget {
  const LabTestBookingCardWidget({super.key, required this.booking});

  final LabTestBookingItemModel booking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final statusKind = LabTestBookingStatusKind.fromStatus(booking.statusLabel);
    final String statusText;
    final Color statusBg;
    final Color statusFg;
    if (statusKind == LabTestBookingStatusKind.pending) {
      statusText = l10n.bookingsStatusPending;
      statusBg = AppColors.clrFFF4E5;
      statusFg = AppColors.clrC85600;
    } else if (statusKind == LabTestBookingStatusKind.failed) {
      statusText = booking.statusLabel;
      statusBg = AppColors.clrFBDEDE;
      statusFg = AppColors.clrBA2025;
    } else {
      statusText = l10n.bookingsStatusConfirmed;
      statusBg = AppColors.clrDEF8FB;
      statusFg = AppColors.clr15A9A0;
    }

    final labLogo = LabTestMediaUrlResolver.resolveLabLogo(
      booking.labLogoUrl,
      labName: booking.labName,
    );
    final partnerName = booking.partnerName.trim();
    final partnerLogo = LabTestMediaUrlResolver.resolvePartnerLogo(
      partnerName: partnerName,
      raw: booking.partnerLogoUrl,
    );
    final showPartner = partnerName.isNotEmpty || partnerLogo.isNotEmpty;
    final testTitle = booking.reportTitle.trim().isNotEmpty
        ? booking.reportTitle.trim()
        : l10n.labTestBookingCardSubtitle;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrEDEDED),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 68.w,
                  height: 68.w,
                  decoration: BoxDecoration(
                    color: AppColors.clrF4F4F4,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: LabTestFigmaImage(
                    url: labLogo,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.labTestOrderNoPrefix}${booking.orderNo}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.clr061E40,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        testTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.clr061E40,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                      if (showPartner) ...[
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            if (partnerLogo.isNotEmpty) ...[
                              Container(
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.clrWhite,
                                  border: Border.all(
                                    color: AppColors.clrD6DCE2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: LabTestFigmaImage(
                                  url: partnerLogo,
                                  width: 14.w,
                                  height: 14.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 6.w),
                            ],
                            if (partnerName.isNotEmpty)
                              Expanded(
                                child: Text.rich(
                                  _fulfilledBySpans(
                                    l10n.labTestCartFulfilledBy(partnerName),
                                    partnerName,
                                    theme,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(height: 1, thickness: 1, color: AppColors.clrE4E4E4),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _MetaColumn(
                    label: '${l10n.bookingsStatusLabel}:',
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Text(
                        statusText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: statusFg,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                _VerticalDivider(),
                Expanded(
                  child: _MetaColumn(
                    label: l10n.labTestTotalFeeLabel,
                    child: Text(
                      booking.totalFee,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.clr061E40,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                _VerticalDivider(),
                Expanded(
                  child: _MetaColumn(
                    label: l10n.bookingsDateLabel,
                    child: Text(
                      booking.dateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr061E40,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                _VerticalDivider(),
                SizedBox(
                  height: 28.h,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(
                        AppRoutes.path(AppRoutes.labTestViewDetails),
                        extra: LabTestViewDetailsArgs(
                          orderId: booking.orderId.isNotEmpty
                              ? booking.orderId
                              : booking.publicId,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.clr9BA6A7,
                        width: 0.275.r,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(39.433.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      foregroundColor: AppColors.clr061E40,
                      textStyle: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(l10n.bookingsViewDetailsCta),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5.w,
      height: 36.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      color: AppColors.clrE4E4E4,
    );
  }
}

class _MetaColumn extends StatelessWidget {
  const _MetaColumn({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }
}

TextSpan _fulfilledBySpans(
  String fullText,
  String partnerName,
  ThemeData theme,
) {
  final base =
      theme.textTheme.bodySmall?.copyWith(
        color: AppColors.clr667B99,
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        height: 1.2,
      ) ??
      const TextStyle();
  final bold = base.copyWith(fontWeight: FontWeight.w700);
  final index = fullText.indexOf(partnerName);
  if (index < 0) {
    return TextSpan(text: fullText, style: base);
  }
  return TextSpan(
    style: base,
    children: [
      TextSpan(text: fullText.substring(0, index)),
      TextSpan(text: partnerName, style: bold),
      TextSpan(text: fullText.substring(index + partnerName.length)),
    ],
  );
}
