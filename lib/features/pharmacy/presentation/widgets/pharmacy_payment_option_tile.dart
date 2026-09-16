import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../../../../core/widgets/app_info_dialog.dart';
import '../../../../generated/assets.dart';
import '../../../consultation/data/utils/consultation_booking_utils.dart';
import '../../../consultation/domain/entities/payment_provider_entity.dart';

class PharmacyPaymentOptionTile extends StatelessWidget {
  const PharmacyPaymentOptionTile({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentProviderEntity provider;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasBadge = provider.displayLabel.isNotEmpty;
    final hasSubtitle = provider.displaySubtitle.isNotEmpty;
    final termsLabel = provider.displayTermsTitle.isNotEmpty
        ? provider.displayTermsTitle
        : l10n.paymentTermsAndConditionsApply;
    final onTermsTap = _termsTapHandler(context, l10n);
    final hasTerms = provider.hasTerms || onTermsTap != null;
    final badgeColors = _badgeColors();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2.r),
      child: Material(
        elevation: 0.1,
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(2.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(2.r),
          ),
          child: Row(
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.3,
                    color: AppColors.clr9BA6A7,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.r),
                child: _leading(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: [
                        Text(
                          _label(context),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.clr060,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        if (hasBadge)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColors.$1,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              provider.displayLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: badgeColors.$2,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (hasSubtitle) ...[
                      SizedBox(height: 4.h),
                      Text(
                        provider.displaySubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.clr667B99,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                    if (hasTerms) ...[
                      SizedBox(height: 4.h),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4.w,
                        children: [
                          Text(
                            termsLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.clr667B99,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (onTermsTap != null)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onTermsTap,
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 16.r,
                                color: AppColors.clr8A9AAE,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.clr060 : AppColors.clrCBD3DC,
                    width: 1.4,
                  ),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                        width: 12.r,
                        height: 12.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.clr060,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leading() {
    final iconUrl = provider.iconUrl.trim();
    if (iconUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: iconUrl,
        fit: BoxFit.contain,
        placeholder: (_, _) => _fallbackIcon(),
        errorWidget: (_, _, _) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    if (ConsultationBookingUtils.isCashPayment(provider.code)) {
      return SvgPicture.asset(
        Assets.iconsCash,
        fit: BoxFit.contain,
      );
    }
    if (ConsultationBookingUtils.isJazzCashPayment(
      provider.code,
      name: provider.name,
    )) {
      return SvgPicture.asset(
        Assets.iconsJazzCash,
        fit: BoxFit.contain,
      );
    }
    final normalizedCode =
        provider.code.trim().toUpperCase().replaceAll(RegExp(r'[\s_-]'), '');
    if (normalizedCode == 'CARD' || normalizedCode.contains('CARD')) {
      return SvgPicture.asset(
        Assets.iconsDebitCard,
        fit: BoxFit.contain,
      );
    }
    return Icon(
      Icons.payment_rounded,
      size: 22.r,
      color: AppColors.clr5D758F,
    );
  }

  String _label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (ConsultationBookingUtils.isCashPayment(provider.code)) {
      final title = provider.displayTitle;
      return title.isNotEmpty ? title : l10n.pharmacyPaymentCash;
    }
    final name = provider.displayTitle;
    if (name.isNotEmpty) return name;
    if (ConsultationBookingUtils.isJazzCashPayment(provider.code)) {
      return l10n.pharmacyPaymentJazzCash;
    }
    return l10n.pharmacyPaymentDebitCard;
  }

  VoidCallback? _termsTapHandler(BuildContext context, AppLocalizations l10n) {
    final description = provider.displayTermsDescription;
    if (description.isEmpty) return null;
    return () {
      final uri = Uri.tryParse(description);
      final isHttp = uri != null &&
          uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https');
      if (isHttp) {
        AppUrlLauncher.open(url: description);
        return;
      }
      AppInfoDialog.show(
        context,
        title: provider.displayTermsTitle.isNotEmpty
            ? provider.displayTermsTitle
            : l10n.authTermsLabel,
        description: description,
        okLabel: l10n.commonOk,
        icon: Icons.info_outline_rounded,
      );
    };
  }

  (Color, Color) _badgeColors() {
    final hex = provider.displayLabelColor;
    if (hex.isValidHexColor) {
      final background = hex.toColor;
      return (background, background.contrastColor);
    }
    return (AppColors.clrFFFFDB61, AppColors.clr060);
  }
}
