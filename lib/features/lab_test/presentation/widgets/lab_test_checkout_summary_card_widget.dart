import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../lab_test_route_args.dart';
import 'lab_test_figma_image.dart';

class LabTestCheckoutSummaryCardWidget extends StatelessWidget {
  const LabTestCheckoutSummaryCardWidget({super.key, required this.args});

  final LabTestCheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A053453),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -70.w,
            top: -40.h,
            child: IgnorePointer(
              child: Image.asset(
                Assets.labTestCardVector,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 88.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                    color: AppColors.clrF4F4F4,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  alignment: Alignment.center,
                  child: LabTestFigmaImage(
                    url: args.labLogoUrl,
                    width: 64.w,
                    height: 64.w,
                    fit: BoxFit.contain,
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
                            child: Text(
                              args.testTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.clr061E40,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (args.partnerLogoUrl.trim().isNotEmpty) ...[
                            SizedBox(width: 6.w),
                            LabTestFigmaImage(
                              url: args.partnerLogoUrl,
                              width: 28.w,
                              height: 28.w,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        args.labDisplayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.clr667B99,
                          fontSize: 12.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: [
                          _pill(
                            context,
                            '${l10n.labTestSampleTypeLabel}: ${args.sampleType}',
                          ),
                          _pill(
                            context,
                            args.bookingMethodIsHomeSample
                                ? l10n.labTestBookingMethodHomeSample
                                : l10n.labTestBookingMethodWalkInCompact,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.labTestCheckoutFeeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.clr667B99,
                          fontSize: 11.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Text(
                            args.discountedFee,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.clr061E40,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                              height: 1.2,
                            ),
                          ),
                          if (args.originalFee.trim().isNotEmpty &&
                              args.originalFee != args.discountedFee) ...[
                            SizedBox(width: 8.w),
                            Text(
                              args.originalFee,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.clr667B99,
                                fontSize: 12.sp,
                                height: 1.2,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
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

  Widget _pill(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(color: AppColors.clrE7E7E7),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.clr667B99,
              fontSize: 11.sp,
              height: 1.2,
            ),
      ),
    );
  }
}
