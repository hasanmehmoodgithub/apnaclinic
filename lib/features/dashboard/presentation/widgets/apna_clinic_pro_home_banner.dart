import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../pro/domain/entities/pro_membership_entity.dart';
import '../../../pro/presentation/show_pro_bottom_sheet.dart';
import 'menu_pro_card.dart';

/// Home Pro section: promo when not subscribed, member status when active.
class ApnaClinicProHomeBanner extends StatelessWidget {
  const ApnaClinicProHomeBanner({
    super.key,
    this.membership,
    this.onTap,
    this.isLoading = false,
    this.imageUrl = '',
  });

  final ProMembershipEntity? membership;
  final VoidCallback? onTap;
  final bool isLoading;

  /// Promo artwork from home `bannerUrl` (empty → card fallback CTA).
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isActive = membership?.isActivePro == true;

    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.clr1FAFA3,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isActive) ...[
          Text(
            l10n.proHomeSectionTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
              color: AppColors.clr111827,
            ),
          ),
          SizedBox(height: 12.h),
        ],
        MenuProCard(
          membership: membership,
          promoImageUrl: imageUrl,
          onTap: onTap ??
              () => showApnaClinicProSheet(context, showServiceActions: true),
        ),
      ],
    );
  }
}
