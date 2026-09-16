import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class PaymentOption extends StatelessWidget {
  const PaymentOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    required this.iconBuilder,
    this.subtitle = '',
    this.badge = '',
    this.badgeColorHex = '',
    this.termsTitle = '',
    this.onTermsTap,
  });

  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final String label;
  final Widget Function() iconBuilder;
  final String subtitle;
  final String badge;
  final String badgeColorHex;
  final String termsTitle;
  final VoidCallback? onTermsTap;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasBadge = badge.trim().isNotEmpty;
    final termsLabel = termsTitle.trim().isNotEmpty
        ? termsTitle.trim()
        : l10n.paymentTermsAndConditionsApply;
    final hasTerms = termsTitle.trim().isNotEmpty || onTermsTap != null;
    final hasSubtitle = subtitle.trim().isNotEmpty;
    final badgeColors = _badgeColors();

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Column(
          children: [
            Row(
              children: [
                iconBuilder(),
                SizedBox(width: 14.w),
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
                            label,
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
                                badge.trim(),
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
                          subtitle.trim(),
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
                      color: selected ? AppColors.clr060 : AppColors.clrCBD3DC,
                      width: 1.4,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: selected
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
          ],
        ),
      ),
    );
  }

  (Color, Color) _badgeColors() {
    final hex = badgeColorHex.trim();
    if (hex.isValidHexColor) {
      final background = hex.toColor;
      return (background, background.contrastColor);
    }
    return (AppColors.clrFFFFDB61, AppColors.clr060);
  }
}
