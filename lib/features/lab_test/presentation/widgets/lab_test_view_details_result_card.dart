import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import 'lab_test_figma_image.dart';

class LabTestViewDetailsResultCard extends StatelessWidget {
  const LabTestViewDetailsResultCard({
    super.key,
    required this.title,
    required this.labName,
    required this.labLogoUrl,
    required this.partnerLogoUrl,
    required this.sampleType,
    required this.status,
    required this.discountedFee,
    required this.originalFee,
  });

  final String title;
  final String labName;
  final String labLogoUrl;
  final String partnerLogoUrl;
  final String sampleType;
  final String status;
  final String discountedFee;
  final String originalFee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
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
                color: const Color(0xFFF2F2F4),
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
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp,
                          color: const Color(0xFF202B3A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE7E7E7)),
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
                SizedBox(height: 1.h),
                Text(
                  labName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF8A93A0),
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                _Line(),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      'Sample Type',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF8A93A0),
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _Tag(text: sampleType),
                    const Spacer(),
                    const _Tag(text: 'Lab Test'),
                  ],
                ),
                SizedBox(height: 8.h),
                _Line(),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF8A93A0),
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
                              color: const Color(0xFFD8F5EE),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              status,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF0DAA9A),
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60.h,
                      color: const Color(0xFFE8E8E8),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fee',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF8A93A0),
                                    fontSize: 11.sp,
                                  ),
                                ),
                                Text(
                                  discountedFee,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: const Color(0xFF1A2533),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  originalFee,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF9A9A9A),
                                    fontSize: 11.sp,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(width: 8.w),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFC),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: const Color(0xFFE6E6E6)),
                          ),
                          child: Text(
                            'Download Report',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFB3B3B3),
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
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
        border: Border.all(color: const Color(0xFFE3E3E3)),
        color: const Color(0xFFFCFCFC),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color(0xFF9AA1AA),
          fontSize: 10.sp,
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFEAEAEA));
  }
}
