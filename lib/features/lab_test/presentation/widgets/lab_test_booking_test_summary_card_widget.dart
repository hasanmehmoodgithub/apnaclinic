import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/utils/lab_test_media_url_resolver.dart';
import 'lab_test_figma_image.dart';
import 'lab_test_price_pill.dart';

/// Selected test summary (title, lab logo, requirement, sample type, fees).
class LabTestBookingTestSummaryCardWidget extends StatelessWidget {
  const LabTestBookingTestSummaryCardWidget({
    super.key,
    required this.title,
    required this.labName,
    this.labLogoUrl = '',
    required this.sampleType,
    required this.discountedFee,
    required this.originalFee,
    required this.requirementLabel,
    required this.sampleTypeLabel,
    this.requirement,
    this.showPricing = true,
  });

  final String title;
  final String labName;
  final String labLogoUrl;
  final String sampleType;
  final String discountedFee;
  final String originalFee;
  final String requirementLabel;
  final String sampleTypeLabel;
  final String? requirement;
  final bool showPricing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logo = LabTestMediaUrlResolver.resolveLabLogo(
      labLogoUrl,
      labName: labName,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.clrEDEDED, width: 1.0),
        color: AppColors.clrF1F1F1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 15.h, 14.w, 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: 'Afacad',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          height: 1.2,
                          color: AppColors.clr061E40,
                        ),
                      ),
                      if (labName.trim().isNotEmpty) ...[
                        SizedBox(height: 6.h),
                        Text(
                          labName.trim(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'Afacad',
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            height: 1.2,
                            color: AppColors.clr061E40,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (logo.isNotEmpty) ...[
                  SizedBox(width: 8.w),
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.clrWhite,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.clrEDEDED),
                    ),
                    alignment: Alignment.center,
                    child: LabTestFigmaImage(
                      url: logo,
                      width: 28.w,
                      height: 28.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.clrWhite,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(14.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 13.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (requirement != null) ...[
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFDFDFDF),
                                width: 1.0,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 7.h),
                          child: Row(
                            children: [
                              Text(
                                requirementLabel,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'Afacad',
                                  color: const Color(0xFF2B2B2B),
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.clrB7EAC3,
                                    borderRadius: BorderRadius.circular(59.r),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      requirement!,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        fontFamily: 'Afacad',
                                        color: AppColors.clr198733,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        child: Wrap(
                          spacing: 4.w,
                          runSpacing: 6.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              sampleTypeLabel,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Afacad',
                                color: const Color(0xFF2B2B2B),
                                fontSize: 14.sp,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(59.r),
                                border: Border.all(
                                  color: AppColors.clrE7E7E7,
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                sampleType,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'Afacad',
                                  color: const Color(0xFF959595),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showPricing) ...[
                  SizedBox(width: 8.w),
                  LabTestPricePill(
                    originalFee: originalFee,
                    discountedFee: discountedFee,
                    borderColor: AppColors.clrF1F1F1,
                    outerBorderRadius: 26,
                    discountedBorderRadius: 24.444,
                    originalPadding: const EdgeInsets.all(6.984),
                    discountedPadding: const EdgeInsets.all(6.984),
                    discountedBackgroundColor: AppColors.clr0FAA9A,
                    originalTextColor: const Color(0xFF979797),
                    originalTextStyle: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Afacad',
                      fontSize: 12.sp,
                      height: 1.3,
                    ),
                    discountedTextStyle:
                        theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Afacad',
                      fontSize: 12.sp,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
