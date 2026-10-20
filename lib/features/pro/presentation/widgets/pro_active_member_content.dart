import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/pro_benefit_entity.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import 'pro_brand_mark.dart';
import 'pro_sheet_header_widget.dart';

/// Bottom-sheet body when [catalog.membership.isActivePro] is true.
class ProActiveMemberContent extends StatelessWidget {
  const ProActiveMemberContent({
    super.key,
    required this.catalog,
    required this.onCancelSubscription,
  });

  final ProCatalogEntity catalog;
  final VoidCallback onCancelSubscription;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final membership = catalog.membership;
    final renewLabel = _renewalLabel(
      l10n: l10n,
      expiresAt: membership.expiresAt,
      autoRenew: membership.autoRenew,
    );

    // Height is owned by the sheet (`shrinkWrap`); keep this a tight column.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProSheetHeaderWidget(
          logoUrl: catalog.logoUrl,
          bannerUrl: catalog.bannerUrl,
        ),
        ColoredBox(
          color: AppColors.clrF3F4F6,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20.w,
              16.h,
              20.w,
              24.h + MediaQuery.paddingOf(context).bottom,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.clrWhite,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.clrE3E8EE),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            catalog.title,
                            style: TextStyle(
                              color: AppColors.clr111827,
                              fontWeight: FontWeight.w800,
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                        if (catalog.allowedActions.canUnsubscribe)
                          _CancelMenuButton(onCancel: onCancelSubscription),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      catalog.tagline.trim().isNotEmpty
                          ? catalog.tagline
                          : l10n.proActiveMemberSubtitle,
                      style: TextStyle(
                        color: AppColors.clr6B7280,
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        height: 1.35,
                      ),
                    ),
                    if (renewLabel != null) ...[
                      SizedBox(height: 14.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.clrFCF5E9,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          renewLabel,
                          style: TextStyle(
                            color: AppColors.clr111827,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        const ProPillBadge(height: 16),
                        SizedBox(width: 6.w),
                        Text(
                          l10n.proActiveBenefitsSuffix,
                          style: TextStyle(
                            color: AppColors.clr111827,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ...catalog.benefits.map(
                      (benefit) => _ActiveBenefitRow(benefit: benefit),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String? _renewalLabel({
    required AppLocalizations l10n,
    required String? expiresAt,
    required bool autoRenew,
  }) {
    final formatted = _formatExpiry(expiresAt);
    if (formatted == null) return null;
    return autoRenew
        ? l10n.proPlanRenewsOn(formatted)
        : l10n.proPlanExpiresOn(formatted);
  }

  static String? _formatExpiry(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null) return raw.trim();
    return DateFormat('d MMM, yyyy').format(parsed.toLocal());
  }
}

class _CancelMenuButton extends StatelessWidget {
  const _CancelMenuButton({required this.onCancel});

  final VoidCallback onCancel;

  static const String _cancelValue = 'cancel_subscription';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      offset: Offset(-4.w, 36.h),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: AppColors.clrWhite,
      elevation: 8,
      onSelected: (value) {
        if (value == _cancelValue) onCancel();
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: _cancelValue,
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Icon(
                Icons.cancel_outlined,
                color: AppColors.clrE01F26,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Text(
                l10n.proCancelSubscription,
                style: TextStyle(
                  color: AppColors.clrE01F26,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
        child: Icon(
          Icons.more_vert_rounded,
          color: AppColors.clr303D4F,
          size: 26.r,
        ),
      ),
    );
  }
}

class _ActiveBenefitRow extends StatelessWidget {
  const _ActiveBenefitRow({required this.benefit});

  final ProBenefitEntity benefit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          const ProCheckBadgeIcon(size: 18),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              benefit.title,
              style: TextStyle(
                color: AppColors.clr111827,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ),
          Text(
            benefit.proValue,
            style: TextStyle(
              color: AppColors.clr111827,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
