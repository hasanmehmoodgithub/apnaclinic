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
import '../../data/models/doctor_consultation_checkout_model.dart';
import '../../data/utils/consultation_booking_utils.dart';

class DoctorConsultationCheckoutPaymentMethodTileWidget
    extends StatelessWidget {
  const DoctorConsultationCheckoutPaymentMethodTileWidget({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final DoctorConsultationPaymentOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasBadge = option.displayLabel.isNotEmpty;
    final hasSubtitle = option.displaySubtitle.isNotEmpty;
    final termsLabel = option.displayTermsTitle.isNotEmpty
        ? option.displayTermsTitle
        : l10n.paymentTermsAndConditionsApply;
    final onTermsTap = _termsTapHandler(context, l10n);
    final hasTerms = option.hasTerms || onTermsTap != null;
    final badgeColors = _badgeColors();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.clrBlack.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.clrF0F4F8,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.clrE3E8EE),
              ),
              padding: EdgeInsets.all(9.r),
              child: _providerIcon(),
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
                        option.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.clr060,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
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
                            option.displayLabel,
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
                      option.displaySubtitle,
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
                        color: AppColors.clr060,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _providerIcon() {
    final iconUrl = option.iconUrl.trim();
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
    if (ConsultationBookingUtils.isCashPayment(option.code)) {
      return SvgPicture.asset(
        Assets.iconsCash,
        fit: BoxFit.contain,
      );
    }
    if (ConsultationBookingUtils.isJazzCashPayment(
      option.code,
      name: option.name,
    )) {
      return SvgPicture.asset(
        Assets.iconsJazzCash,
        fit: BoxFit.contain,
      );
    }
    final normalized =
        option.code.trim().toUpperCase().replaceAll(RegExp(r'[\s_-]'), '');
    if (normalized == 'CARD' || normalized.contains('CARD')) {
      return SvgPicture.asset(
        Assets.iconsDebitCard,
        fit: BoxFit.contain,
      );
    }
    return Icon(
      Icons.payment_rounded,
      size: 22.r,
      color: AppColors.clr7B8794,
    );
  }

  VoidCallback? _termsTapHandler(BuildContext context, AppLocalizations l10n) {
    final description = option.displayTermsDescription;
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
        title: option.displayTermsTitle.isNotEmpty
            ? option.displayTermsTitle
            : l10n.authTermsLabel,
        description: description,
        okLabel: l10n.commonOk,
        icon: Icons.info_outline_rounded,
      );
    };
  }

  (Color, Color) _badgeColors() {
    final hex = option.displayLabelColor;
    if (hex.isValidHexColor) {
      final background = hex.toColor;
      return (background, background.contrastColor);
    }
    return (AppColors.clrFFFFDB61, AppColors.clr060);
  }
}
