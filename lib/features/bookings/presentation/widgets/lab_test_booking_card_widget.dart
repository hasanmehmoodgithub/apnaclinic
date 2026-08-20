import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../generated/assets.dart';
import '../../../lab_test/presentation/lab_test_route_args.dart';
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

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33053453),
            blurRadius: 64.2,
            offset: Offset(0, 14),
            spreadRadius: -27,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -90.w,
            top: -50.h,
            child: IgnorePointer(
              child: Image.asset(
                Assets.labTestCardVector,
                width: 250.w,
                height: 250.h,
                  fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Assets.iconsTest,
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.clr667B99,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${l10n.labTestOrderNoPrefix}${booking.orderNo}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  l10n.labTestBookingCardSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr667B99,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  l10n.bookingsDateLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.clr667B99,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  booking.dateLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(height: 0.3.h, color: AppColors.clr9BA6A7),
                SizedBox(height: 8.h),
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
                    Container(
                      width: 0.3.w,
                      height: 36.h,
                      color: AppColors.clr9BA6A7,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _MetaColumn(
                        label: l10n.labTestTotalFeeLabel,
                        child: Text(
                          booking.totalFee,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.clr061E40,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.3.w,
                      height: 36.h,
                      color: AppColors.clr9BA6A7,
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      height: 28.h,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.path(AppRoutes.labTestViewDetails),
                            extra: LabTestViewDetailsArgs(
                              orderId: booking.orderNo,
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
        ],
      ),
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
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }
}
