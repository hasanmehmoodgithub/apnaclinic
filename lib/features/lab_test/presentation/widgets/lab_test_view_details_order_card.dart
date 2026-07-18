import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import 'lab_test_figma_image.dart';

class LabTestViewDetailsOrderCard extends StatelessWidget {
  const LabTestViewDetailsOrderCard({
    super.key,
    required this.patientName,
    required this.orderNo,
    required this.bookingDate,
    required this.totalFee,
    this.discountCode,
  });

  final String patientName;
  final String orderNo;
  final String bookingDate;
  final String totalFee;
  final String? discountCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final code = discountCode?.trim() ?? '';
    final hasDiscountCode = code.isNotEmpty;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1FB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 240,
            bottom: -100,
            child: IgnorePointer(
              child: SvgPicture.asset(
                'assets/svg/lab_test/card_bg_vector.svg',
                width: 170.w,
                height: 290.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
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
                                patientName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF202B3A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${l10n.labTestOrderNoPrefix} $orderNo',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF6F7784),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.labTestBookingDateLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF8A93A0),
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              bookingDate,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: const Color(0xFF202B3A),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(height: 1, color: const Color(0xFF84848C)),
                    SizedBox(height: 12.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.labTestTotalFeeLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6F7784),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          totalFee,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF1F2A3B),
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (hasDiscountCode)
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.labTestDiscountCodeCopied)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7EFC7),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12.r),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              LabTestFigmaImage(
                                url: Assets.labTestDiscountIcon,
                                width: 15.r,
                                height: 15.r,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  l10n.labTestDiscountCodeLabel,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF1C232D),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                              Text(
                                code,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF1C232D),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Container(height: 1, color: const Color(0xFFE1D49D)),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.labTestShowCodeInstruction,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF4A5059),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
