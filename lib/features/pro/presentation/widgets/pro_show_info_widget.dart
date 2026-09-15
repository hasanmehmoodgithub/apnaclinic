import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'pro_brand_mark.dart';

/// Upsell / info strip for Pro discounts (title, subtitle, discount).
/// Hidden when [isVisible] is false. Not wired to screens yet.
class ProShowInfoWidget extends StatelessWidget {
  const ProShowInfoWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.discount,
    this.isVisible = true,
    this.sectionTitle,
    this.ctaLabel,
    this.onSubscribeTap,
  });

  /// e.g. "Doctor Consultation Discount"
  final String title;

  /// e.g. "Become a pro member to get additional discount"
  final String subtitle;

  /// e.g. "20%" or "20% OFF"
  final String discount;

  /// When false, renders [SizedBox.shrink].
  final bool isVisible;

  /// Optional header above the card (defaults to l10n subscribe-to-pro copy).
  final String? sectionTitle;

  /// Optional CTA text (defaults to l10n).
  final String? ctaLabel;

  final VoidCallback? onSubscribeTap;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final header = sectionTitle?.trim().isNotEmpty == true
        ? sectionTitle!.trim()
        : l10n.proShowInfoSectionTitle;
    final cta = ctaLabel?.trim().isNotEmpty == true
        ? ctaLabel!.trim()
        : l10n.proShowInfoSubscribeCta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            color: AppColors.clr111827,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Material(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(14.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onSubscribeTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.clr1FAFA3, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const ProPillBadge(height: 18),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppColors.clr111827,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        discount,
                        style: TextStyle(
                          color: AppColors.clr111827,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Divider(height: 1.h, color: AppColors.clrE3E8EE),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: AppColors.clr111827,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            height: 1.35,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        cta,
                        style: TextStyle(
                          color: AppColors.clr1FAFA3,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
