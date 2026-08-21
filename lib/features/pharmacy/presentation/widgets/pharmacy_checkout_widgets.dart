import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';
import '../../domain/entities/pharmacy_cart_item_entity.dart';
import 'pharmacy_network_image.dart';

class PharmacySummaryRow extends StatelessWidget {
  const PharmacySummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
    this.bgColor,
    this.padding = EdgeInsets.zero,
    this.titleFontSize,
    this.valueFontSize,
  });

  final String title;
  final double value;
  final bool isBold;
  final Color? bgColor;
  final EdgeInsetsGeometry padding;
  final double? titleFontSize;
  final double? valueFontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amountSize = valueFontSize ?? (isBold ? 17.sp / 1.6 : 16.sp / 1.6);
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: AppColors.clr060,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
      fontSize: amountSize,
    );
    return Container(
      color: bgColor,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.clr060,
                  fontWeight: FontWeight.w400,
                  fontSize: titleFontSize ?? 13.sp,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                style: style,
                children: [
                  TextSpan(
                    text: l10n.pharmacyCurrencyPrefix,
                    style: style?.copyWith(
                      color: AppColors.clr5D758F,
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: value.toStringAsFixed(2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PharmacyCheckoutField extends StatelessWidget {
  const PharmacyCheckoutField({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.clr060,
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.clrF7F7F7,
            borderRadius: BorderRadius.circular(2.r),
          ),
          child: Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.clr5D758F,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class PharmacyCheckoutEditableField extends StatelessWidget {
  const PharmacyCheckoutEditableField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.inputFontSize,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final double? inputFontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fieldFontSize = inputFontSize ?? (16.sp / 1.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.clr060,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          height: 42.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColors.clrF7F7F7,
            borderRadius: BorderRadius.circular(2.r),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              inputFormatters: NoEmojiTextInputFormatter.merge(
                const <TextInputFormatter>[],
                allowBasicPunctuation: true,
              ),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.clr5D758F,
                fontSize: fieldFontSize,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.clr8C9CB0,
                  fontSize: fieldFontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PharmacyCheckoutCityField extends StatelessWidget {
  const PharmacyCheckoutCityField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.clr060,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Material(
          color: AppColors.clrF7F7F7,
          borderRadius: BorderRadius.circular(2.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(2.r),
            child: Container(
              width: double.infinity,
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.clr5D758F,
                        fontSize: 19.sp / 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more_rounded,
                    color: AppColors.clr5D758F,
                    size: 20.r,
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

class PharmacyCheckoutCartItemRow extends StatelessWidget {
  const PharmacyCheckoutCartItemRow({super.key, required this.item});

  final PharmacyCartItemEntity item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 130.r,
          height: 88.r,
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(22.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: PharmacyNetworkImage(
            imageUrl: item.medicine.imageUrl,
            width: 130.r,
            height: 88.r,
            fit: BoxFit.contain,
            placeholderBorderRadius: 22.r,
            memCacheWidth: 400,
            errorBackgroundColor: AppColors.clrE9EEF3,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item.medicine.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.clr060,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 5.h),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.quantity}x ',
                        style: const TextStyle(color: AppColors.clr667B99),
                      ),
                      TextSpan(
                        text:
                            '${l10n.pharmacyCurrencyPrefix}${item.displayUnitPrice.toStringAsFixed(0)}/-',
                        style: const TextStyle(color: AppColors.clr060),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PharmacyInfoCard extends StatelessWidget {
  final String? title;
  final String message;
  final String? footer;
  final Color bgColor;
  final Color footerBgColor;
  final FontWeight messageFontWeight;

  const PharmacyInfoCard({
    super.key,
    this.title,
    required this.message,
    this.footer,
    this.bgColor = AppColors.clrWhite,
    this.footerBgColor = AppColors.clrFFE9C3,
    this.messageFontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 11.h, 16.w, 11.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.clr060,
                fontWeight: FontWeight.w800,
                fontSize: 17.sp / 1.6,
              ),
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.clr060,
              fontSize: 16.sp / 1.6,
              fontWeight: messageFontWeight,
              height: 1.3,
            ),
          ),
          if (footer != null) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: footerBgColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                footer!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr060,
                  fontSize: 16.sp / 1.6,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
