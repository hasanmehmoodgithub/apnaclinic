import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../pro/domain/entities/pro_membership_entity.dart';
import '../../../pro/presentation/show_pro_bottom_sheet.dart';
import 'apna_clinic_pro_home_banner.dart';

/// Menu Pro entry: promo banner when not Pro, status card when active.
class MenuProCard extends StatelessWidget {
  const MenuProCard({
    super.key,
    required this.membership,
    this.onTap,
    this.promoImageUrl = ApnaClinicProHomeBanner.defaultImageUrl,
  });

  final ProMembershipEntity? membership;
  final VoidCallback? onTap;
  final String promoImageUrl;

  @override
  Widget build(BuildContext context) {
    final isActive = membership?.isActivePro == true;
    final open = onTap ?? () => showApnaClinicProSheet(context);

    if (isActive) {
      return _ProMemberStatusCard(
        membership: membership!,
        onTap: open,
      );
    }

    return _ProSubscribePromoCard(
      imageUrl: promoImageUrl,
      onTap: open,
    );
  }
}

class _ProSubscribePromoCard extends StatelessWidget {
  const _ProSubscribePromoCard({
    required this.imageUrl,
    required this.onTap,
  });

  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (_, _) => Container(
            height: 140.h,
            color: AppColors.clrE8F8F5,
            alignment: Alignment.center,
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.clr1FAFA3,
              ),
            ),
          ),
          errorWidget: (_, _, _) => Container(
            height: 140.h,
            color: AppColors.clrE8F8F5,
            padding: EdgeInsets.all(16.w),
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.proHomeCardFallbackCta,
              style: TextStyle(
                color: AppColors.clr1FAFA3,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProMemberStatusCard extends StatelessWidget {
  const _ProMemberStatusCard({
    required this.membership,
    required this.onTap,
  });

  final ProMembershipEntity membership;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expiryLine = _expiryLine(l10n, membership);

    return Material(
      color: AppColors.clrWhite,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.clr1FAFA3, width: 1.2),
          ),
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 12.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.proBadgeCrown,
                    height: 22.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      l10n.proMenuYouAreMember,
                      style: TextStyle(
                        color: AppColors.clr111827,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.clr1FAFA3, width: 1.2),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.clr1FAFA3,
                      size: 22.r,
                    ),
                  ),
                ],
              ),
              if (expiryLine != null) ...[
                SizedBox(height: 12.h),
                Divider(height: 1.h, color: AppColors.clrE3E8EE),
                SizedBox(height: 10.h),
                Text(
                  expiryLine,
                  style: TextStyle(
                    color: AppColors.clr111827,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String? _expiryLine(
    AppLocalizations l10n,
    ProMembershipEntity membership,
  ) {
    final formatted = _formatExpiry(membership.expiresAt);
    if (formatted == null) return null;
    return membership.autoRenew
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
