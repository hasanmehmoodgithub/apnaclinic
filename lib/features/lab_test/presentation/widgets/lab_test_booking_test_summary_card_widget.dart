import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'lab_test_price_pill.dart';

/// Selected test summary (title, lab, requirement, sample type, fees).
class LabTestBookingTestSummaryCardWidget extends StatelessWidget {
  const LabTestBookingTestSummaryCardWidget({
    super.key,
    required this.title,
    required this.labName,
    required this.sampleType,
    required this.discountedFee,
    required this.originalFee,
    required this.requirementLabel,
    required this.sampleTypeLabel,
    this.requirement,
  });

  final String title;
  final String labName;
  final String sampleType;
  final String discountedFee;
  final String originalFee;
  final String requirementLabel;
  final String sampleTypeLabel;
  final String? requirement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEDE4E4), width: 1.0),
        color: const Color(0xFFF1F1F1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 15.h, 14.w, 15.h),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Afacad',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(14.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 13.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Afacad',
                    fontSize: 14.sp,
                    height: 1.2,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
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
                                        color: const Color(0xFFB7EAC3),
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
                                            color: const Color(0xFF198733),
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
                                      color: const Color(0xFFE7E7E7),
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
                    SizedBox(width: 8.w),
                    LabTestPricePill(
                      originalFee: originalFee,
                      discountedFee: discountedFee,
                      borderColor: const Color(0xFFF1F1F1),
                      outerBorderRadius: 26,
                      discountedBorderRadius: 24.444,
                      originalPadding: const EdgeInsets.all(6.984),
                      discountedPadding: const EdgeInsets.all(6.984),
                      discountedBackgroundColor: const Color(0xFF0FAA9A),
                      originalTextColor: const Color(0xFF979797),
                      originalTextStyle: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'Afacad',
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                      discountedTextStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Afacad',
                        fontSize: 12.sp,
                        height: 1.3,
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
